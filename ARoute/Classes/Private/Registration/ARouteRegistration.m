//
//  ARouteRegistration.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteRegistration.h"

@interface ARouteRegistration ()

@property (strong, nonatomic, nonnull) ARoute *router;
@property (strong, nonatomic, nonnull, readwrite) NSArray <ARouteRegistrationItem *> *items;
@property (strong, nonatomic, nonnull) NSString *separator;

@property (strong, nonatomic, nonnull) ARouteRegistrationStorage *routeRegistrationStorage;

@end

@implementation ARouteRegistration

+ (instancetype)routeRegistrationWithRouter:(ARoute *)router routes:(nonnull NSDictionary<NSString *,Class> *)routes routeName:(nullable NSString *)routeName
{
    ARouteRegistration *routeRegistration = [ARouteRegistration new];
    routeRegistration.router = router;
    
    ARouteRegistrationItem *item = [ARouteRegistrationItem new];
    
    NSString *route = routes.allKeys.firstObject;
    Class destinationViewControllerClass = routes.allValues.firstObject;
    
    item.router = router;
    item.routeName = routeName;
    item.route = route;
    item.destinationViewControllerClass = destinationViewControllerClass;
    item.type = ARouteRegistrationItemTypeNamedRoute;
    item.separator = routeRegistration.separator;
    
    routeRegistration.items = @[item];
    
    return routeRegistration;
}

+ (instancetype)routeRegistrationWithRouter:(ARoute *)router routes:(NSDictionary<NSString *,Class> *)routes routesGroupName:(NSString *)routesGroupName
{
    ARouteRegistration *routeRegistration = [ARouteRegistration new];
    routeRegistration.router = router;

    NSMutableArray *items = [NSMutableArray new];
    
    [routes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull route, Class  _Nonnull destinationViewControllerClass, BOOL * _Nonnull stop) {
        
        ARouteRegistrationItem *item = [ARouteRegistrationItem new];
        
        item.router = router;
        item.route = route;
        item.destinationViewControllerClass = destinationViewControllerClass;
        item.type = ARouteRegistrationItemTypeNamedRoute;
        item.separator = routeRegistration.separator;
        
        [items addObject:item];
    }];
    
    routeRegistration.items = @[items];
    
    return routeRegistration;
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

@end
