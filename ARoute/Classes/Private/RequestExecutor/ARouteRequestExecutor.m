//
//  ARouteRequestExecutor.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteRequestExecutor.h"

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

- (void)executeRouteRequest:(ARouteRequest *)routeRequest
{
    ARouteResponse *response = [ARouteResponse new];
    __kindof UIViewController *destinationViewController;
    __kindof UIViewController *embeddingViewController;
    
    // preparing params
    Class destinationViewControllerClass;
    void (^callbackBlock)(ARouteResponse *);
    BOOL animated = routeRequest.configuration.animatedBlock ? routeRequest.configuration.animatedBlock() : NO;
    response.parameters = routeRequest.configuration.parametersBlock ? routeRequest.configuration.parametersBlock() : nil;
    
    ARoute *router = routeRequest.router;
    
    // find route registration
    switch (routeRequest.type) {
        case ARouteRequestTypeRoute: {
            ARouteRegistrationStorageResult *result = [self.routeRegistrationStorage routeRegistrationResultForRoute:routeRequest.route router:router];
            destinationViewControllerClass = result.routeRegistrationItem.destinationViewControllerClass;
            callbackBlock = result.routeRegistrationItem.destinationCallback;
            response.routeParameters = result.routeParameters;
            
            break;
        }
        case  ARouteRequestTypeRouteName: {
            ARouteRegistrationStorageResult *result = [self.routeRegistrationStorage routeRegistrationResultForRouteName:routeRequest.routeName router:router];
            destinationViewControllerClass = result.routeRegistrationItem.destinationViewControllerClass;
            callbackBlock = result.routeRegistrationItem.destinationCallback;
            response.routeParameters = result.routeParameters;
            
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
            return;
    }
    
    // check if callback
    if (callbackBlock) {
        callbackBlock(response);
        return;
    }
    
    if (!destinationViewController && destinationViewControllerClass) {
        destinationViewController = [self viewControllerWithClass:destinationViewControllerClass routeRequest:routeRequest routeResponse:response];
    }
    
    if (!destinationViewController) {
        return;
    }
    
    response.destinationViewController = destinationViewController;
    
    // embed if neccessary
    if (routeRequest.configuration.embeddingViewControllerBlock) {
        embeddingViewController = routeRequest.configuration.embeddingViewControllerBlock();
    }
    
    // populate data on created view controller
    
    // present view controller
    
    UIViewController *presentingViewController;
    if (embeddingViewController) {
        response.embeddingViewController = embeddingViewController;
        if ([embeddingViewController respondsToSelector:@selector(embedDestinationViewController:withRouteResponse:)]) {
            [embeddingViewController performSelector:@selector(embedDestinationViewController:withRouteResponse:) withObject:destinationViewController withObject:response];
        }
        presentingViewController = embeddingViewController;
    } else {
        presentingViewController = destinationViewController;
    }
    
    destinationViewController.transitioningDelegate = routeRequest.configuration.transitioningDelegateBlock ? routeRequest.configuration.transitioningDelegateBlock() : nil;
    
    [[UIViewController visibleViewController:nil] presentViewController:presentingViewController animated:animated completion:^{
        if (routeRequest.configuration.completionBlock) {
            routeRequest.configuration.completionBlock(response);
        }
    }];
}

- (__kindof UIViewController *)viewControllerWithClass:(Class)aClass routeRequest:(ARouteRequest *)routeRequest routeResponse:(ARouteResponse *)routeResponse
{
    UIViewController *viewController;
    
    SEL initSelector = routeRequest.configuration.instantiationSelector;
    if (initSelector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        BOOL respondsToInitSelector = [aClass instancesRespondToSelector:initSelector];
        if (respondsToInitSelector) {
            NSDictionary *arguments = routeRequest.configuration.instantiationArguments;
            
            if (arguments.count > 0) {
                viewController = [[aClass alloc] performSelector:initSelector withObject:arguments];
            } else {
                viewController = [[aClass alloc] performSelector:initSelector];
            }
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

#pragma mark - Private

- (ARouteRegistrationStorage *)routeRegistrationStorage
{
    return [ARouteRegistrationStorage sharedInstance];
}

@end
