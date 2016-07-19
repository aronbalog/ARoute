//
//  ARouteRequestExecutor.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteRequestExecutor.h"
#import <objc/runtime.h>

@class ARouteRegistrationStorage;
@protocol ARoutable;

@interface ARouteResponse ()

@property (strong, nonatomic, nullable, readwrite) NSDictionary <NSString *, NSString *> *routeParameters;
@property (strong, nonatomic, nullable, readwrite) NSDictionary <id, id> *parameters;
@property (strong, nonatomic, nullable, readwrite) __kindof UIViewController *destinationViewController;
@property (strong, nonatomic, nullable, readwrite) __kindof UIViewController *embeddingViewController;

@end

@interface ARouteRequestExecutor ()

@property (strong, nonatomic, nonnull) ARouteRegistrationStorage *routeRegistrationStorage;
@property (strong, nonatomic, nullable) id classPointer;

@end

@implementation ARouteRequestExecutor

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    
    return instance;
}

- (void)executeRouteRequest:(ARouteRequest *)routeRequest routeResponse:(void (^ _Nullable)(ARouteResponse * _Nonnull))routeResponseCallback
{
    ARouteResponse *routeResponse;
    BOOL animated;
    UIViewController *presentingViewController = [self viewControllerForRouteRequest:routeRequest routeResponse:&routeResponse animated:&animated];
    
    [[UIViewController visibleViewController:nil] presentViewController:presentingViewController animated:animated completion:^{
        if (routeRequest.configuration.completionBlock) {
            routeRequest.configuration.completionBlock(routeResponse);
        }
    }];
    if (routeResponseCallback) {
        routeResponseCallback(routeResponse);
    }
}

- (UIViewController *)viewControllerForRouteRequest:(ARouteRequest *)routeRequest
{
    ARouteResponse *routeResponse;
    BOOL animated;
    
    return [self viewControllerForRouteRequest:routeRequest routeResponse:&routeResponse animated:&animated];
}

#pragma mark - Private

- (UIViewController *)viewControllerForRouteRequest:(ARouteRequest *)routeRequest routeResponse:(ARouteResponse * __autoreleasing *)routeResponsePtr animated:(BOOL*)animatedPtr
{
    ARouteResponse *response = [ARouteResponse new];
    __kindof UIViewController *destinationViewController;
    __kindof UIViewController *embeddingViewController;
    
    // preparing params
    Class destinationViewControllerClass;
    void (^callbackBlock)(ARouteResponse *);
    BOOL animated = routeRequest.configuration.animatedBlock ? routeRequest.configuration.animatedBlock() : NO;
    response.parameters = routeRequest.configuration.parametersBlock ? routeRequest.configuration.parametersBlock() : nil;
    
    NSString *castingSeparator;
    NSDictionary *routeParameters;
    NSDictionary *registrationParameters;
    
    BOOL (^protectBlock)(ARouteResponse *);
    ARouteEmbeddingType embeddingType = 0;
    NSArray *previousViewControllers;
    
    ARoute *router = routeRequest.router;
    
    // find route registration
    switch (routeRequest.type) {
        case ARouteRequestTypeRoute: {
            ARouteRegistrationStorageResult *result = [self.routeRegistrationStorage routeRegistrationResultForRoute:routeRequest.route router:router];
            destinationViewControllerClass = result.routeRegistrationItem.destinationViewControllerClass;
            callbackBlock = result.routeRegistrationItem.destinationCallback;
            routeParameters = result.routeParameters;
            protectBlock = result.routeRegistrationItem.protectBlock;
            castingSeparator = result.routeRegistrationItem.castingSeparator;
            registrationParameters = result.routeRegistrationItem.parametersBlock ? result.routeRegistrationItem.parametersBlock() : nil;
            embeddingType = result.routeRegistrationItem.embeddingType;
            previousViewControllers = result.routeRegistrationItem.previousViewControllersBlock ? result.routeRegistrationItem.previousViewControllersBlock(response) : nil;
            break;
        }
        case  ARouteRequestTypeRouteName: {
            ARouteRegistrationStorageResult *result = [self.routeRegistrationStorage routeRegistrationResultForRouteName:routeRequest.routeName router:router];
            destinationViewControllerClass = result.routeRegistrationItem.destinationViewControllerClass;
            callbackBlock = result.routeRegistrationItem.destinationCallback;
            routeParameters = result.routeParameters;
            protectBlock = result.routeRegistrationItem.protectBlock;
            castingSeparator = result.routeRegistrationItem.castingSeparator;
            registrationParameters = result.routeRegistrationItem.parametersBlock ? result.routeRegistrationItem.parametersBlock() : nil;
            embeddingType = result.routeRegistrationItem.embeddingType;
            previousViewControllers = result.routeRegistrationItem.previousViewControllersBlock ? result.routeRegistrationItem.previousViewControllersBlock(response) : nil;
            
            break;
        }
        case ARouteRequestTypeViewController: {
            destinationViewController = routeRequest.viewController;
            
            break;
        }
        case ARouteRequestTypeURL: {
            
            break;
        }
        default:
            return nil;
            break;
    }
    
    // combine parameters
    response.parameters = [self combineRequestParameters:response.parameters withRegistrationParameters:registrationParameters];
    
    // set casting separator
    [response setValue:castingSeparator forKey:@"castingSeparator"];
    response.routeParameters = routeParameters;
    
    BOOL proceed = YES;
    
    // check if protected
    if (routeRequest.configuration.protectBlock) {
        protectBlock = routeRequest.configuration.protectBlock;
    }
    
    if (protectBlock) {
        proceed = !protectBlock(response);
    }
    
    if (!proceed) {
        self.classPointer = nil;
        return nil;
    }
    
    // check if callback
    if (callbackBlock) {
        self.classPointer = nil;
        callbackBlock(response);
        return nil;
    }
    
    if (!destinationViewController && destinationViewControllerClass) {
        destinationViewController = [self viewControllerWithClass:destinationViewControllerClass routeRequest:routeRequest routeResponse:response];
    }
    
    if (!destinationViewController) {
        self.classPointer = nil;
        return nil;
    }
    
    response.destinationViewController = destinationViewController;
    
    // embed if neccessary
    if (routeRequest.configuration.embeddingViewControllerBlock) {
        embeddingViewController = routeRequest.configuration.embeddingViewControllerBlock();
    } else {
        embeddingType = routeRequest.configuration.embeddingType;
        if (routeRequest.configuration.previousViewControllersBlock) {
            previousViewControllers = routeRequest.configuration.previousViewControllersBlock(response);
        }
    }
    
    // populate data on created view controller
    
    // present view controller
    
    UIViewController *presentingViewController;
    if (embeddingViewController) {
        if ([embeddingViewController respondsToSelector:@selector(embedDestinationViewController:withRouteResponse:)]) {
            [embeddingViewController performSelector:@selector(embedDestinationViewController:withRouteResponse:) withObject:destinationViewController withObject:response];
        }
        presentingViewController = embeddingViewController;
    } else {
        if (embeddingType == ARouteEmbeddingTypeNavigationController) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:destinationViewController];
            
            if (previousViewControllers.count) {
                __block NSMutableArray *viewControllers = [NSMutableArray new];
                
                [previousViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (object_isClass(obj)) {
                        id classPointer = [obj alloc];
                        if ([classPointer respondsToSelector:@selector(initWithRouteResponse:)]) {
                            [viewControllers addObject:[classPointer initWithRouteResponse:response]];
                        }
                    } else if ([obj isKindOfClass:[NSString class]]) {
                        UIViewController *viewController = [[router route:obj] viewController];
                        [viewControllers addObject:viewController];
                    } else if ([obj isKindOfClass:[UIViewController class]]) {
                        [viewControllers addObject:obj];
                    }
                }];
                [viewControllers addObject:destinationViewController];
                
                [navigationController setViewControllers:viewControllers animated:NO];
            }
            
            presentingViewController = navigationController;
            embeddingViewController = navigationController;
        } else if (embeddingType == ARouteEmbeddingTypeTabBarController) {
            UITabBarController *tabBarController = [UITabBarController new];
            [tabBarController setViewControllers:@[destinationViewController] animated:NO];
            presentingViewController = tabBarController;
            embeddingViewController = tabBarController;
        } else {
            presentingViewController = destinationViewController;
        }
    }
    
    response.embeddingViewController = embeddingViewController;
    
    destinationViewController.transitioningDelegate = routeRequest.configuration.transitioningDelegateBlock ? routeRequest.configuration.transitioningDelegateBlock() : nil;
    
    *routeResponsePtr = response;
    *animatedPtr = animated;
    
    return presentingViewController;
}

- (__kindof UIViewController *)viewControllerWithClass:(Class)aClass routeRequest:(ARouteRequest *)routeRequest routeResponse:(ARouteResponse *)routeResponse
{
    UIViewController *viewController;
    
    SEL initSelector = routeRequest.configuration.constructorBlock ? routeRequest.configuration.constructorBlock(routeResponse) : nil;
    if (initSelector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        BOOL respondsToInitSelector = [aClass instancesRespondToSelector:initSelector];
        if (respondsToInitSelector) {
        
            NSMethodSignature *signature = [aClass instanceMethodSignatureForSelector:initSelector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            self.classPointer = [aClass alloc];
            [invocation setTarget:self.classPointer];
            [invocation setSelector:initSelector];
            NSArray *arguments = routeRequest.configuration.instantiationArgumentsBlock(routeResponse);

            for (NSInteger i = 0; i < arguments.count; i++)
            {
                id __unsafe_unretained argument = arguments[i];
                [invocation setArgument:&argument atIndex:(i+2)];
            }
            [invocation retainArguments];

            id __unsafe_unretained result = nil;
            [invocation invoke];
            [invocation getReturnValue:&result];
            
            viewController = result;
        }
        
#pragma clang diagnostic pop
    } else {
        BOOL conformsToProtocol = [aClass conformsToProtocol:@protocol(ARoutable)];
        if (conformsToProtocol) {
            __kindof UIViewController <ARoutable> *conformedViewController = [[aClass alloc] initWithRouteResponse:routeResponse];
            viewController = conformedViewController;
        }
    }
    
    return viewController;
}

- (NSDictionary *)combineRequestParameters:(NSDictionary *)requestParameters withRegistrationParameters:(NSDictionary *)registrationParameters
{
    NSMutableDictionary *combined = [NSMutableDictionary new];
    
    [combined addEntriesFromDictionary:registrationParameters];
    [requestParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        combined[key] = obj;
    }];
    
    return combined;
}

#pragma mark - Properties

- (ARouteRegistrationStorage *)routeRegistrationStorage
{
    return [ARouteRegistrationStorage sharedInstance];
}

@end
