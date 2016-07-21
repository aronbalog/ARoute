//
//  ARoute.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARoute.h"
#import <objc/runtime.h>
@class ARouteRequest;

@interface ARoute ()

@property (strong, nonatomic, nonnull, readwrite) ARouteConfiguration *configuration;
@property (strong, nonatomic, nonnull) ARouteRegistrationStorage *storage;

@end

@implementation ARoute

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
    [router swizzle];
    
    router.name = name;
    
    return router;
}

- (void)swizzle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [[UIApplication sharedApplication].delegate class];
        
        SEL originalSelector = @selector(application:openURL:options:);
        SEL swizzledSelector = @selector(aroute_application:openURL:options:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (BOOL)aroute_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    [[[ARoute sharedRouter] URL:url] execute];
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

- (id<ARouteRegistrationInitiable,ARouteRegistrationExecutable,ARouteRegistrationProtectable,ARouteRegistrationConfigurable>)registerURLs:(NSDictionary<NSURL *,id> *)routes
{
    return [ARouteRegistration routeRegistrationWithRouter:self routes:routes routesGroupName:nil];
}

- (void)clearAllRouteRegistrations
{
    [self.storage purgeRouteRegistrations];
}

#pragma mark - Properties

- (ARouteConfiguration *)configuration
{
    if (!_configuration) {
        _configuration = [ARoute configuration];
    }
    
    return _configuration;
}

- (ARouteRegistrationStorage *)storage
{
    return [ARouteRegistrationStorage sharedInstance];
}

@end
