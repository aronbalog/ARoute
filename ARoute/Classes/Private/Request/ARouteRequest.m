//
//  ARouteRequest.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteRequest.h"

@interface ARouteRequest ()

@property (assign, nonatomic, readwrite) ARouteRequestType type;

@property (strong, nonatomic, nonnull, readwrite) ARoute *router;

@property (strong, nonatomic, nonnull, readwrite) NSString *route;
@property (strong, nonatomic, nonnull, readwrite) NSString *routeName;
@property (strong, nonatomic, nonnull, readwrite) ARouteRequestConfiguration *configuration;
@property (strong, nonatomic, nullable, readwrite) __kindof UIViewController *viewController;

@property (strong, nonatomic, nullable, readwrite) NSURL *URL;

@property (strong, nonatomic, nonnull) ARouteRequestExecutor *executor;

@end

@implementation ARouteRequest

+ (instancetype)routeRequestWithRouter:(ARoute *)router route:(NSString *)route
{
    ARouteRequest *routeRequest = [ARouteRequest new];
    
    routeRequest.type = ARouteRequestTypeRoute;
    routeRequest.router = router;
    routeRequest.route = route;
    
    return routeRequest;
}

+ (instancetype)routeRequestWithRouter:(ARoute *)router routeName:(NSString *)routeName
{
    ARouteRequest *routeRequest = [ARouteRequest new];
    
    routeRequest.type = ARouteRequestTypeRouteName;
    routeRequest.router = router;
    routeRequest.routeName = routeName;
    
    return routeRequest;
}

+ (instancetype)routeRequestWithRouter:(ARoute *)router viewController:(__kindof UIViewController *)viewController
{
    ARouteRequest *routeRequest = [ARouteRequest new];
    
    routeRequest.type = ARouteRequestTypeViewController;
    routeRequest.router = router;
    routeRequest.viewController = viewController;
    
    return routeRequest;
}

+ (instancetype)routeRequestWithRouter:(ARoute *)router URL:(nonnull __kindof NSURL *)URL
{
    ARouteRequest *routeRequest = [ARouteRequest new];
    
    routeRequest.type = ARouteRequestTypeURL;
    routeRequest.router = router;
    routeRequest.URL = URL;
    
    return routeRequest;
}

#pragma mark - ARouteRequestInitiable

- (id<ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)constructor:(SEL  _Nonnull (^)(ARouteResponse * _Nonnull))constructor objects:(NSArray * _Nullable (^)(ARouteResponse * _Nonnull))objects
{
    self.configuration.constructorBlock = constructor;
    
    if (objects) {
        self.configuration.instantiationArgumentsBlock = objects;
    }
    
    return self;
}

- (id<ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)embedInNavigationController
{
    self.configuration.embeddingType = ARouteEmbeddingTypeNavigationController;
    
    return self;
}

- (id<ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)embedInNavigationController:(NSArray * _Nullable (^)(ARouteResponse * _Nonnull))previousViewControllers
{
    self.configuration.embeddingType = ARouteEmbeddingTypeNavigationController;
    if (previousViewControllers) {
        self.configuration.previousViewControllersBlock = previousViewControllers;
    }
    
    return self;
}

- (id<ARouteRequestInitiable,ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)parameters:(NSDictionary <id, id> * _Nullable (^)())parameters
{
    if (parameters) {
        self.configuration.parametersBlock = parameters;
    }
    
    return self;
}

#pragma mark - ARouteRequestProtectable

- (id<ARouteRequestInitiable,ARouteRequestExecutable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)protect:(BOOL (^)(ARouteResponse *))protect
{
    if (protect) {
        self.configuration.protectBlock = protect;
    }
    
    return self;
}

#pragma mark - ARouteRequestConfigurable

- (id<ARouteRequestInitiable,ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestConfigurable>)animated:(BOOL (^)())animated
{
    if (animated) {
        self.configuration.animatedBlock = animated;
    }
    
    return self;
}

- (id<ARouteRequestInitiable,ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestConfigurable>)completion:(void (^)(ARouteResponse * _Nonnull))completion
{
    if (completion) {
        self.configuration.completionBlock = completion;
    }
    
    return self;
}

- (id<ARouteRequestInitiable,ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestConfigurable>)transitioningDelegate:(id<UIViewControllerTransitioningDelegate>  _Nullable (^)())transitioningDelegate
{
    if (transitioningDelegate) {
        self.configuration.transitioningDelegateBlock = transitioningDelegate;
    }
    
    return self;
}

- (id<ARouteRequestExecutable,ARouteRequestConfigurable>)links:(NSDictionary * _Nonnull (^)(ARouteResponse * _Nonnull))links
{
    if (links) {
        
    }
    
    return self;
}

#pragma mark - ARouteRequestEmbeddable

- (id<ARouteRequestInitiable,ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestConfigurable>)embedIn:(__kindof UIViewController<AEmbeddable> * _Nonnull (^)())embeddingViewController
{
    if (embeddingViewController) {
        self.configuration.embeddingViewControllerBlock = embeddingViewController;
    }
    
    return self;
}

#pragma mark - ARouteRequestExecutable

- (void)execute
{
    [self.executor executeRouteRequest:self];
}

- (UIViewController *)viewController
{
    return [self.executor viewControllerForRouteRequest:self];
}

#pragma mark - Private

- (ARouteRequestConfiguration *)configuration
{
    if (!_configuration) {
        _configuration = [ARouteRequestConfiguration new];
    }
    
    return _configuration;
}

- (ARouteRequestExecutor *)executor
{
    return [ARouteRequestExecutor sharedInstance];
}

@end
