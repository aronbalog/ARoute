//
//  ARouteRequestExecutor.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteRequestExecutor.h"
#import <objc/runtime.h>
#import "UIViewController+TransitioningDelegate.h"

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
    UIViewController *presentingViewController;
    [self viewControllerForRouteRequest:routeRequest routeResponse:&routeResponse animated:&animated presentingViewController:&presentingViewController];
    
    if (presentingViewController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIViewController visibleViewController:nil] presentViewController:presentingViewController animated:animated completion:^{
                if (routeRequest.configuration.completionBlock) {
                    routeRequest.configuration.completionBlock(routeResponse);
                }
            }];
        });
    }
    
    if (routeResponse && routeResponseCallback) {
        routeResponseCallback(routeResponse);
    }
}

- (void)pushRouteRequest:(ARouteRequest *)routeRequest routeResponse:(void (^)(ARouteResponse * _Nonnull))routeResponseCallback
{
 
    ARouteResponse *routeResponse;
    BOOL animated;
    UIViewController *destinationViewController = [self viewControllerForRouteRequest:routeRequest routeResponse:&routeResponse animated:&animated presentingViewController:nil];
    
    if (destinationViewController) {
        UIViewController *currentViewController = [UIViewController visibleViewController:nil];
        UINavigationController *navigationController;
        
        if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            navigationController = (UINavigationController *)currentViewController;
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            if ([((UITabBarController *)currentViewController).selectedViewController isKindOfClass:[UINavigationController class]]) {
                navigationController = ((UITabBarController *)currentViewController).selectedViewController;
            }
        } else {
            navigationController = currentViewController.navigationController;
        }
        
        if (navigationController) {
            navigationController.delegate = destinationViewController.aroute_transitioningDelegate;
            destinationViewController.transitioningDelegate = nil;
            
            [navigationController pushViewController:destinationViewController animated:animated];
            if (routeRequest.configuration.completionBlock) {
                routeRequest.configuration.completionBlock(routeResponse);
            }
        }
    }
    
    if (routeResponse && routeResponseCallback) {
        routeResponseCallback(routeResponse);
    }
}

- (UIViewController *)viewControllerForRouteRequest:(ARouteRequest *)routeRequest
{
    ARouteResponse *routeResponse;
    
    BOOL animated;
    
    return [self viewControllerForRouteRequest:routeRequest routeResponse:&routeResponse animated:&animated presentingViewController:nil];
}

- (UIViewController *)embeddingViewControllerForRouteRequest:(ARouteRequest *)routeRequest
{
    ARouteResponse *routeResponse;
    UIViewController *presentingViewController;

    BOOL animated;
    
    [self viewControllerForRouteRequest:routeRequest routeResponse:&routeResponse animated:&animated presentingViewController:&presentingViewController];
    
    return presentingViewController;
}

#pragma mark - Private

- (UIViewController *)viewControllerForRouteRequest:(ARouteRequest *)routeRequest routeResponse:(ARouteResponse * __autoreleasing *)routeResponsePtr animated:(BOOL*)animatedPtr presentingViewController:(UIViewController * __autoreleasing *)presentingViewControllerPtr
{
    NSError *errorPtr;
    ARouteResponse *response = [ARouteResponse new];
    __kindof UIViewController *destinationViewController;
    __kindof UIViewController *embeddingViewController;
    
    // preparing params
    Class destinationViewControllerClass;
    id (^callbackBlock)(ARouteResponse *);
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
            destinationViewController = result.routeRegistrationItem.destinationViewController;
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
            destinationViewController = result.routeRegistrationItem.destinationViewController;
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
            destinationViewController = routeRequest.viewControllerObject;
            
            break;
        }
        case ARouteRequestTypeURL: {
            ARouteRegistrationStorageResult *result = [self.routeRegistrationStorage routeRegistrationResultForURL:routeRequest.URL router:router];
            destinationViewControllerClass = result.routeRegistrationItem.destinationViewControllerClass;
            destinationViewController = result.routeRegistrationItem.destinationViewController;
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
        if ([overridenConfiguration respondsToSelector:@selector(destinationViewController)]) {
            destinationViewController = [overridenConfiguration destinationViewController];
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
        *routeResponsePtr = response;
        id destination = callbackBlock(response);
        if (object_isClass(destination)) {
            destinationViewControllerClass = destination;
        } else if ([destination isKindOfClass:[UIViewController class]]) {
            destinationViewController = destination;
        } else {
            self.classPointer = nil;
            return nil;
        }
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
    id embeddingPointer;
    
    if (routeRequest.configuration.embeddingViewControllerBlock) {
        embeddingViewController = routeRequest.configuration.embeddingViewControllerBlock();
    } else if (routeRequest.configuration.navigationControllerClassBlock) {
        embeddingPointer = routeRequest.configuration.navigationControllerClassBlock(response);
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
    
    if (embeddingViewController) {
        embeddingPointer = embeddingViewController;
    }
    
    // populate data on created view controller
    
    // present view controller
    
    UIViewController *presentingViewController = [self presentingViewControllerWithEmbeddingViewController:&embeddingPointer destinationViewController:destinationViewController embeddingType:embeddingType previousRouteItems:previousViewControllers routeResponse:response router:router];
    
    response.embeddingViewController = embeddingPointer;
    
    if (routeRequest.configuration.transitioningDelegateBlock) {
        id delegate = routeRequest.configuration.transitioningDelegateBlock();
        presentingViewController.aroute_transitioningDelegate = delegate;
        presentingViewController.transitioningDelegate = presentingViewController.aroute_transitioningDelegate;
    }
    
    *routeResponsePtr = response;
    *animatedPtr = animated;
    if (presentingViewControllerPtr) {
        *presentingViewControllerPtr = presentingViewController;
    }
    
    return destinationViewController;
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

- (UIViewController *)presentingViewControllerWithEmbeddingViewController:(id*)embeddingViewController destinationViewController:(__kindof UIViewController *)destinationViewController embeddingType:(ARouteEmbeddingType)embeddingType previousRouteItems:(NSArray *)previousRouteItems routeResponse:(ARouteResponse *)routeResponse router:(ARoute *)router
{
    UIViewController *presentingViewController;

    if (*embeddingViewController) {
        if (object_isClass(*embeddingViewController)) {
            if ([[*embeddingViewController alloc] respondsToSelector:@selector(initWithRootViewController:)]) {
                presentingViewController = [[*embeddingViewController alloc] initWithRootViewController:destinationViewController];
            }
        } else {
            if ([*embeddingViewController respondsToSelector:@selector(embedDestinationViewController:withRouteResponse:)]) {
                [*embeddingViewController performSelector:@selector(embedDestinationViewController:withRouteResponse:) withObject:destinationViewController withObject:routeResponse];
            }
            presentingViewController = *embeddingViewController;
        }
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
