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
    
    if (presentingViewController) {
        [[UIViewController visibleViewController:nil] presentViewController:presentingViewController animated:animated completion:^{
            if (routeRequest.configuration.completionBlock) {
                routeRequest.configuration.completionBlock(routeResponse);
            }
        }];
    }
    
    if (routeResponse && routeResponseCallback) {
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
    NSError *errorPtr;
    ARouteResponse *response = [ARouteResponse new];
    __kindof UIViewController *destinationViewController;
    __kindof UIViewController *embeddingViewController;
    
    // preparing params
    Class destinationViewControllerClass;
    void (^callbackBlock)(ARouteResponse *);
    BOOL animated = routeRequest.configuration.animatedBlock ? routeRequest.configuration.animatedBlock() : routeRequest.router.configuration.animate;
    response.parameters = routeRequest.configuration.parametersBlock ? routeRequest.configuration.parametersBlock() : nil;
    
    NSString *castingSeparator;
    NSDictionary *routeParameters;
    NSDictionary *registrationParameters;
    
    BOOL (^protectBlock)(ARouteResponse * _Nonnull routeResponse, NSError * __autoreleasing _Nullable * _Nullable errorPtr);
    ARouteEmbeddingType requestEmbeddingType = routeRequest.configuration.embeddingType;
    ARouteEmbeddingType registrationEmbeddingType = ARouteEmbeddingTypeNotDefined;

    NSArray *previousViewControllers;
    
    ARoute *router = routeRequest.router;
    id <AConfigurable> overridenConfiguration;
    
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
            registrationEmbeddingType = result.routeRegistrationItem.embeddingType;
            previousViewControllers = result.routeRegistrationItem.previousViewControllersBlock ? result.routeRegistrationItem.previousViewControllersBlock(response) : nil;
            overridenConfiguration = result.routeRegistrationItem.configurationObject;
            
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
            registrationEmbeddingType = result.routeRegistrationItem.embeddingType;
            previousViewControllers = result.routeRegistrationItem.previousViewControllersBlock ? result.routeRegistrationItem.previousViewControllersBlock(response) : nil;
            overridenConfiguration = result.routeRegistrationItem.configurationObject;
            
            break;
        }
        case ARouteRequestTypeViewController: {
            destinationViewController = routeRequest.viewController;
            
            break;
        }
        case ARouteRequestTypeURL: {
            ARouteRegistrationStorageResult *result = [self.routeRegistrationStorage routeRegistrationResultForURL:routeRequest.URL router:router];
            destinationViewControllerClass = result.routeRegistrationItem.destinationViewControllerClass;
            callbackBlock = result.routeRegistrationItem.destinationCallback;
            routeParameters = result.routeParameters;
            protectBlock = result.routeRegistrationItem.protectBlock;
            castingSeparator = result.routeRegistrationItem.castingSeparator;
            registrationParameters = result.routeRegistrationItem.parametersBlock ? result.routeRegistrationItem.parametersBlock() : nil;
            registrationEmbeddingType = result.routeRegistrationItem.embeddingType;
            previousViewControllers = result.routeRegistrationItem.previousViewControllersBlock ? result.routeRegistrationItem.previousViewControllersBlock(response) : nil;
            overridenConfiguration = result.routeRegistrationItem.configurationObject;

            break;
        }
        default:
            return nil;
    }
    
    if (overridenConfiguration) {
        if ([overridenConfiguration respondsToSelector:@selector(destinationViewControllerClass)]) {
            destinationViewControllerClass = [overridenConfiguration destinationViewControllerClass];
        }
        if ([overridenConfiguration respondsToSelector:@selector(castingSeparator)]) {
            castingSeparator = [overridenConfiguration castingSeparator];
        }
        if ([overridenConfiguration respondsToSelector:@selector(animated)]) {
            animated = [overridenConfiguration animated];
        }
        if ([overridenConfiguration respondsToSelector:@selector(parameters)]) {
            registrationParameters = [overridenConfiguration parameters];
        }
        if ([overridenConfiguration respondsToSelector:@selector(callbackBlock)]) {
            callbackBlock = [overridenConfiguration callbackBlock];
        }
        if ([overridenConfiguration respondsToSelector:@selector(transitioningDelegate)]) {
            routeRequest.configuration.transitioningDelegateBlock = ^id <UIViewControllerTransitioningDelegate>{
                return [overridenConfiguration transitioningDelegate];
            };
        }
        if ([overridenConfiguration respondsToSelector:@selector(embeddingType)]) {
            registrationEmbeddingType = [overridenConfiguration embeddingType];
        }
        if ([overridenConfiguration respondsToSelector:@selector(previousEmbeddingItems)]) {
            previousViewControllers = [overridenConfiguration previousEmbeddingItems];
        }
        if ([overridenConfiguration respondsToSelector:@selector(customEmbeddingViewController)]) {
            embeddingViewController = [overridenConfiguration customEmbeddingViewController];
        }
        if ([overridenConfiguration respondsToSelector:@selector(constructorSelector)]) {
            routeRequest.configuration.constructorBlock = ^SEL(ARouteResponse *routeResponse) {
                return [overridenConfiguration constructorSelector];
            };
        }
        if ([overridenConfiguration respondsToSelector:@selector(completionBlock)]) {
            routeRequest.configuration.completionBlock = [overridenConfiguration completionBlock];
        }
        if ([overridenConfiguration respondsToSelector:@selector(failureBlock)]) {
            routeRequest.configuration.failureBlock = [overridenConfiguration failureBlock];
        }
        if ([overridenConfiguration respondsToSelector:@selector(protectBlock)]) {
            protectBlock = [overridenConfiguration protectBlock];
        }
    
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
        proceed = !protectBlock(response, &errorPtr);
    }
    
    proceed = proceed && errorPtr == nil;
    
    if (!proceed) {
        self.classPointer = nil;
        routeRequest.configuration.failureBlock(response, errorPtr);
        return nil;
    }
    
    // check if callback
    if (callbackBlock) {
        self.classPointer = nil;
        *routeResponsePtr = response;
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
    ARouteEmbeddingType embeddingType = ARouteEmbeddingTypeNotDefined;
    if (routeRequest.configuration.embeddingViewControllerBlock) {
        embeddingViewController = routeRequest.configuration.embeddingViewControllerBlock();
    } else {
        if (requestEmbeddingType != ARouteEmbeddingTypeNotDefined) {
            embeddingType = requestEmbeddingType;
        } else {
            embeddingType = registrationEmbeddingType;
        }
        
        if (routeRequest.configuration.previousViewControllersBlock) {
            previousViewControllers = routeRequest.configuration.previousViewControllersBlock(response);
        }
    }
    
    // populate data on created view controller
    
    // present view controller
    
    UIViewController *presentingViewController = [self presentingViewControllerWithEmbeddingViewController:&embeddingViewController destinationViewController:destinationViewController embeddingType:embeddingType previousRouteItems:previousViewControllers routeResponse:response router:router];
    
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

- (UIViewController *)presentingViewControllerWithEmbeddingViewController:(__kindof UIViewController * __autoreleasing *)embeddingViewController destinationViewController:(__kindof UIViewController *)destinationViewController embeddingType:(ARouteEmbeddingType)embeddingType previousRouteItems:(NSArray *)previousRouteItems routeResponse:(ARouteResponse *)routeResponse router:(ARoute *)router
{
    UIViewController *presentingViewController;

    if (*embeddingViewController) {
        if ([*embeddingViewController respondsToSelector:@selector(embedDestinationViewController:withRouteResponse:)]) {
            [*embeddingViewController performSelector:@selector(embedDestinationViewController:withRouteResponse:) withObject:destinationViewController withObject:routeResponse];
        }
        presentingViewController = *embeddingViewController;
    } else {
        if (embeddingType == ARouteEmbeddingTypeNavigationController) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:destinationViewController];
            
            if (previousRouteItems.count) {
                __block NSMutableArray *viewControllers = [NSMutableArray new];
                
                [previousRouteItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (object_isClass(obj)) {
                        id classPointer = [obj alloc];
                        if ([classPointer respondsToSelector:@selector(initWithRouteResponse:)]) {
                            [viewControllers addObject:[classPointer initWithRouteResponse:routeResponse]];
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
            *embeddingViewController = navigationController;
        } else if (embeddingType == ARouteEmbeddingTypeTabBarController) {
            UITabBarController *tabBarController = [UITabBarController new];
            [tabBarController setViewControllers:@[destinationViewController] animated:NO];
            presentingViewController = tabBarController;
            *embeddingViewController = tabBarController;
        } else {
            presentingViewController = destinationViewController;
        }
    }
    
    return presentingViewController;
}

#pragma mark - Properties

- (ARouteRegistrationStorage *)routeRegistrationStorage
{
    return [ARouteRegistrationStorage sharedInstance];
}

@end
