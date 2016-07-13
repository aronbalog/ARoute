//
//  ARouteRegistration.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARoute.h"

@class ARouteRegistrationConfiguration;
@class ARouteRegistrationItem;

@interface ARouteRegistration : NSObject <ARouteRegistrationExecutable>

@property (strong, nonatomic, nonnull) ARouteRegistrationConfiguration *registrationConfiguration;
@property (strong, nonatomic, nonnull, readonly) NSArray <ARouteRegistrationItem *> *items;

+ (nonnull instancetype)routeRegistrationWithRouter:(nonnull ARoute *)router routes:(nonnull NSDictionary <NSString*,Class> *)routes routeName:(nullable NSString *)routeName;
+ (nonnull instancetype)routeRegistrationWithRouter:(nonnull ARoute *)router routes:(nonnull NSDictionary <NSString*,Class> *)routes routesGroupName:(nullable NSString *)routesGroupName;

@end
