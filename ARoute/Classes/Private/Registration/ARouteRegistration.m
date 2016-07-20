//
//  ARouteRegistration.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteRegistration.h"
#import <objc/runtime.h>
@interface ARouteRegistration ()

@property (strong, nonatomic, nonnull) ARoute *router;
@property (strong, nonatomic, nonnull, readwrite) NSArray <ARouteRegistrationItem *> *items;
@property (strong, nonatomic, nonnull) NSString *separator;
@property (strong, nonatomic, nonnull) NSString *castingSeparator;

@property (strong, nonatomic, nonnull) ARouteRegistrationStorage *routeRegistrationStorage;

@end

@implementation ARouteRegistration

+ (instancetype)routeRegistrationWithRouter:(ARoute *)router routes:(nonnull NSDictionary<NSString *,id> *)routes routeName:(nullable NSString *)routeName
{
    ARouteRegistration *routeRegistration = [ARouteRegistration new];
    routeRegistration.router = router;
    
    ARouteRegistrationItem *item = [ARouteRegistrationItem new];
    
    NSString *route = routes.allKeys.firstObject;
    id value = routes.allValues.firstObject;
    
    if (object_isClass(value)) {
        item.destinationViewControllerClass = value;
    } else {
        item.destinationCallback = value;
    }
    
    item.router = router;
    item.routeName = routeName;
    item.route = route;
    item.type = ARouteRegistrationItemTypeNamedRoute;
    item.separator = routeRegistration.separator;
    
    routeRegistration.items = @[item];
    
    return routeRegistration;
}

+ (instancetype)routeRegistrationWithRouter:(ARoute *)router routes:(NSDictionary<NSString *,id> *)routes routesGroupName:(NSString *)routesGroupName
{
    ARouteRegistration *routeRegistration = [ARouteRegistration new];
    routeRegistration.router = router;

    NSMutableArray *items = [NSMutableArray new];
    
    [routes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull route, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        ARouteRegistrationItem *item = [ARouteRegistrationItem new];
        
        if (object_isClass(value)) {
            item.destinationViewControllerClass = value;
        } else {
            item.destinationCallback = value;
        }
        
        item.router = router;
        item.route = route;
        item.type = ARouteRegistrationItemTypeNamedRoute;
        item.separator = routeRegistration.separator;
        
        [items addObject:item];
    }];
    
    routeRegistration.items = items;
    
    return routeRegistration;
}

- (instancetype)embedInNavigationController
{
    [self.items enumerateObjectsUsingBlock:^(ARouteRegistrationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.embeddingType = ARouteEmbeddingTypeNavigationController;
    }];
    return self;
}

- (instancetype)embedInNavigationController:(NSArray *(^)(ARouteResponse *))previousViewControllers
{
    [self.items enumerateObjectsUsingBlock:^(ARouteRegistrationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.previousViewControllersBlock = previousViewControllers;
        obj.embeddingType = ARouteEmbeddingTypeNavigationController;
    }];
    return self;
}

- (instancetype)embedInTabBarController
{
    [self.items enumerateObjectsUsingBlock:^(ARouteRegistrationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.embeddingType = ARouteEmbeddingTypeTabBarController;
    }];
    return self;
}

- (instancetype)embedIn:(__kindof UIViewController<AEmbeddable> *(^)(ARouteResponse * _Nonnull))embeddingViewController
{
    [self.items enumerateObjectsUsingBlock:^(ARouteRegistrationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.embeddingType = ARouteEmbeddingTypeCustomViewController;
    }];
    return self;
}

- (id<ARouteRegistrationExecutable,ARouteRegistrationConfigurable,ARouteRegistrationProtectable>)separator:(NSString * _Nonnull (^)())separator
{
    if (separator) {
        self.separator = separator();
        [self.items enumerateObjectsUsingBlock:^(ARouteRegistrationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.separator = self.separator;
        }];
    }
    
    return self;
}

- (id<ARouteRegistrationExecutable,ARouteRegistrationConfigurable,ARouteRegistrationProtectable>)castingSeparator:(NSString * _Nonnull (^)())castingSeparator
{
    if (castingSeparator) {
        self.castingSeparator = castingSeparator();
        [self.items enumerateObjectsUsingBlock:^(ARouteRegistrationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.castingSeparator = self.castingSeparator;
        }];
    }
    
    return self;
}

- (id<ARouteRegistrationExecutable,ARouteRegistrationConfigurable,ARouteRegistrationProtectable>)parameters:(NSDictionary<id,id> * _Nullable (^)())parameters
{
    if (parameters) {
        self.registrationConfiguration.parametersBlock = parameters;
        [self.items enumerateObjectsUsingBlock:^(ARouteRegistrationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.parametersBlock = self.registrationConfiguration.parametersBlock;
        }];
    }
    
    return self;
}

- (id <ARouteRegistrationExecutable, ARouteRegistrationConfigurable>)protect:(BOOL (^)(ARouteResponse * _Nonnull, NSError * _Nullable __autoreleasing * _Nullable))protect
{
    if (protect) {
        self.registrationConfiguration.protectBlock = protect;
        [self.items enumerateObjectsUsingBlock:^(ARouteRegistrationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.protectBlock = self.registrationConfiguration.protectBlock;
        }];
    }
    
    return self;
}

- (void)execute
{
    [self.routeRegistrationStorage storeRouteRegistration:self];
}

#pragma mark - Properties

- (ARouteRegistrationStorage *)routeRegistrationStorage
{
    return [ARouteRegistrationStorage sharedInstance];
}

- (NSString *)separator
{
    if (!_separator) {
        _separator = self.router.configuration.separator;
    }
    
    return _separator;
}

- (ARouteRegistrationConfiguration *)registrationConfiguration
{
    if (!_registrationConfiguration) {
        _registrationConfiguration = [ARouteRegistrationConfiguration new];
    }
    
    return _registrationConfiguration;
}

@end
