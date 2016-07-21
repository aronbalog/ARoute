//
//  ARoute.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARoutable.h"
#import "AEmbeddable.h"
#import "ACastable.h"

#import "ARouteRequestInitiable.h"
#import "ARouteRequestExecutable.h"
#import "ARouteRequestProtectable.h"
#import "ARouteRequestEmbeddable.h"
#import "ARouteRequestConfigurable.h"

#import "ARouteRegistrationInitiable.h"
#import "ARouteRegistrationProtectable.h"
#import "ARouteRegistrationExecutable.h"
#import "ARouteRegistrationConfigurable.h"

#import "ARouteResponse.h"

@class ARouteConfiguration;

@interface ARoute : NSObject

@property (strong, nonatomic, nullable) NSString *name;
@property (strong, nonatomic, nonnull, readonly) ARouteConfiguration *configuration;

+ (nonnull instancetype)sharedRouter;
+ (nonnull instancetype)createRouterWithName:(nonnull NSString *)name;
+ (nonnull instancetype)routerNamed:(nonnull NSString *)routerName;

+ (nonnull ARouteConfiguration *)configuration;

- (nonnull id <ARouteRequestInitiable, ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)route:(nonnull NSString *)route;
- (nonnull id <ARouteRequestInitiable, ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)routeNamed:(nonnull NSString *)routeName;
- (nonnull id <ARouteRequestInitiable, ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)viewController:(nonnull __kindof UIViewController *)viewController;
- (nonnull id <ARouteRequestInitiable, ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)URL:(nonnull NSURL *)URL;

- (nonnull id <ARouteRegistrationInitiable, ARouteRegistrationExecutable, ARouteRegistrationProtectable, ARouteRegistrationConfigurable>)registerRoutes:(nonnull NSDictionary <NSString*, id> *)routes;
- (nonnull id <ARouteRegistrationInitiable, ARouteRegistrationExecutable, ARouteRegistrationProtectable, ARouteRegistrationConfigurable>)registerRoute:(nonnull NSDictionary <NSString*, id> *)route withName:(nonnull NSString *)routeName;
- (nonnull id <ARouteRegistrationInitiable, ARouteRegistrationExecutable, ARouteRegistrationProtectable, ARouteRegistrationConfigurable>)registerRoutes:(nonnull NSDictionary <NSString*, id> *)routes withGroupName:(nonnull NSString *)groupName;
- (nonnull id <ARouteRegistrationInitiable, ARouteRegistrationExecutable, ARouteRegistrationProtectable, ARouteRegistrationConfigurable>)registerURLs:(nonnull NSDictionary <NSURL*, id> *)routes;

- (void)clearAllRouteRegistrations;

@end
