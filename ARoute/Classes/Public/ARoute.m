//
//  ARoute.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARoute.h"

@class ARouteRequest;

@interface ARoute ()

@property (strong, nonatomic, nonnull, readwrite) ARouteConfiguration *configuration;

@end

@implementation ARoute

- (void)test
{
    [[[ARoute sharedRouter] registerRoute:@{@"":[NSString class]} withName:@""] execute];
    
    [[[[ARoute sharedRouter] route:@""] initSelector:^SEL _Nonnull{
        return @selector(init);
    } objects:nil] execute];
}

+ (instancetype)sharedRouter
{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self createRouterWithName:[NSUUID UUID].UUIDString];
    });
    
    return instance;
}

+ (instancetype)createRouterWithName:(NSString *)name
{
    ARoute *router = [self new];
    
    router.name = name;
    
    return router;
}

+ (instancetype)routerNamed:(NSString *)routerName
{
    return [self createRouterWithName:routerName];
}

+ (ARouteConfiguration *)configuration
{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [ARouteConfiguration new];
    });
    
    return instance;
}

- (id<ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)route:(NSString *)route
{
    return [ARouteRequest routeRequestWithRouter:self route:route];
}

- (id<ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)routeNamed:(NSString *)routeName
{
    return [ARouteRequest routeRequestWithRouter:self routeName:routeName];
}

- (id<ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)viewController:(__kindof UIViewController *)viewController
{
    return [ARouteRequest routeRequestWithRouter:self viewController:viewController];
}

- (id<ARouteRequestExecutable,ARouteRequestProtectable,ARouteRequestEmbeddable,ARouteRequestConfigurable>)URL:(NSURL *)URL
{
    return [ARouteRequest routeRequestWithRouter:self URL:URL];
}

#pragma mark - Route registration

- (id<ARouteRegistrationInitiable,ARouteRegistrationExecutable,ARouteRegistrationProtectable,ARouteRegistrationConfigurable>)registerRoutes:(NSDictionary<NSString *,id> *)routes
{
    return [ARouteRegistration routeRegistrationWithRouter:self routes:routes routesGroupName:nil];
}

- (id<ARouteRegistrationInitiable,ARouteRegistrationExecutable,ARouteRegistrationProtectable,ARouteRegistrationConfigurable>)registerRoute:(NSDictionary<NSString *,id> *)route withName:(NSString *)routeName
{
    return [ARouteRegistration routeRegistrationWithRouter:self routes:route routeName:routeName];
}

- (id<ARouteRegistrationInitiable,ARouteRegistrationExecutable,ARouteRegistrationProtectable,ARouteRegistrationConfigurable>)registerRoutes:(NSDictionary<NSString *,id> *)routes withGroupName:(nonnull NSString *)groupName
{
    return [ARouteRegistration routeRegistrationWithRouter:self routes:routes routesGroupName:groupName];
}

#pragma mark - Properties

- (ARouteConfiguration *)configuration
{
    if (!_configuration) {
        _configuration = [ARoute configuration];
    }
    
    return _configuration;
}

@end
