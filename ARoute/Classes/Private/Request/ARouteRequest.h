//
//  ARouteRequest.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARoute;

typedef NS_ENUM(NSInteger, ARouteRequestType) {
    ARouteRequestTypeRoute,
    ARouteRequestTypeRouteName,
    ARouteRequestTypeViewController,
    ARouteRequestTypeURL
};

@interface ARouteRequest : NSObject <ARouteRequestInitiable, ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>

@property (assign, nonatomic, readonly) ARouteRequestType type;

@property (strong, nonatomic, nonnull, readonly) ARoute *router;

@property (strong, nonatomic, nullable, readonly) NSString *route;
@property (strong, nonatomic, nullable, readonly) NSString *routeName;
@property (strong, nonatomic, nonnull, readonly) ARouteRequestConfiguration *configuration;
@property (strong, nonatomic, nullable, readonly) __kindof UIViewController *viewController;
@property (strong, nonatomic, nullable, readonly) NSURL *URL;

+ (nonnull instancetype)routeRequestWithRouter:(nonnull ARoute *)router route:(nonnull NSString *)route;
+ (nonnull instancetype)routeRequestWithRouter:(nonnull ARoute *)router routeName:(nonnull NSString *)routeName;
+ (nonnull instancetype)routeRequestWithRouter:(nonnull ARoute *)router viewController:(nonnull __kindof UIViewController *)viewController;
+ (nonnull instancetype)routeRequestWithRouter:(nonnull ARoute *)router URL:(nonnull __kindof NSURL *)URL;

@end
