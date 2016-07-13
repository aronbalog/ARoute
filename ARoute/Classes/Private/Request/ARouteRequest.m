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

- (id<ARouteRequestInitiable,ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)initSelector:(SEL  _Nonnull (^)())initSelector objects:(NSDictionary * _Nullable (^)())objects
{
    self.configuration.instantiationSelector = initSelector();
    if (objects) {
        self.configuration.instantiationArguments = objects();
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