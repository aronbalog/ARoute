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
@property (strong, nonatomic, nullable, readwrite) __kindof UIViewController *viewControllerObject;

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
    routeRequest.viewControllerObject = viewController;
    
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

- (id<ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)embedInNavigationControllerClass:(Class _Nonnull (^)(ARouteResponse * _Nonnull))navigationControllerClass
{
    self.configuration.embeddingType = ARouteEmbeddingTypeNavigationController;
    self.configuration.navigationControllerClassBlock = navigationControllerClass;
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

- (id<ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)embedInTabBarController
{
    self.configuration.embeddingType = ARouteEmbeddingTypeTabBarController;
    
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

- (id<ARouteRequestInitiable,ARouteRequestExecutable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)protect:(BOOL (^)(ARouteResponse * _Nonnull, NSError * _Nullable __autoreleasing * _Nullable))protect
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

- (id<ARouteRequestExecutable,ARouteRequestConfigurable>)failure:(void (^)(ARouteResponse * _Nonnull, NSError * _Nullable))failure
{
    if (failure) {
        self.configuration.failureBlock = failure;
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
    [self execute:nil];
}

- (void)execute:(void (^)(ARouteResponse * _Nonnull))routeResponse
{
    [self.executor executeRouteRequest:self routeResponse:routeResponse];
}

- (void)push
{
    [self push:nil];
}

- (void)push:(void (^)(ARouteResponse * _Nonnull))routeResponse
{
    [self push:nil routeResponse:routeResponse];
}

- (void)push:(id<UINavigationControllerDelegate>  _Nullable (^)())navigationControllerDelegate routeResponse:(void (^)(ARouteResponse * _Nonnull))routeResponse
{
    if (navigationControllerDelegate) {
        self.configuration.navigationViewControllerDelegateBlock = navigationControllerDelegate;
    }
    
    [self.executor pushRouteRequest:self routeResponse:routeResponse];
}

- (UIViewController *)viewController
{
    return [self.executor viewControllerForRouteRequest:self];
}

- (UIViewController *)embeddingViewController
{
    return [self.executor embeddingViewControllerForRouteRequest:self];
}

- (void)pop:(BOOL)animated
{
    [self pop:animated navigationControllerDelegate:nil];
}

- (void)pop:(BOOL)animated navigationControllerDelegate:(id<UINavigationControllerDelegate>  _Nullable (^ _Nullable)())navigationControllerDelegate
{
    UIViewController *currentViewController = [UIViewController visibleViewController:nil];
    UINavigationController *navigationController = currentViewController.navigationController;
    if (!navigationController) {
        navigationController = [currentViewController isKindOfClass:[UINavigationController class]] ? (UINavigationController *)currentViewController : nil;
    }
    
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        if (navigationControllerDelegate) {
            navigationController.delegate = navigationControllerDelegate();
        }
        [navigationController popViewControllerAnimated:animated];
    }
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
