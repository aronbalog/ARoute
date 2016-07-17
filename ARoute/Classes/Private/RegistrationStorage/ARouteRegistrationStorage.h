//
//  ARouteRegistrationStorage.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARoute;
@class ARouteRegistrationStorageResult;

@interface ARouteRegistrationStorage : NSObject

+ (nonnull instancetype)sharedInstance;

- (void)storeRouteRegistration:(nonnull ARouteRegistration *)routeRegistration;
- (nullable ARouteRegistrationStorageResult *)routeRegistrationResultForRoute:(nonnull NSString *)route router:(nonnull ARoute *)router;
- (nullable ARouteRegistrationStorageResult *)routeRegistrationResultForRouteName:(nonnull NSString *)routeName router:(nonnull ARoute *)router;
- (void)purgeRouteRegistrations;

@end
