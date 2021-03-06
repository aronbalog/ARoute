//
//  ARouteRequestExecutor.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARouteRequest;

@interface ARouteRequestExecutor : NSObject

+ (nonnull instancetype)sharedInstance;

- (void)executeRouteRequest:(nonnull ARouteRequest *)routeRequest routeResponse:(void (^ _Nullable)(ARouteResponse * _Nonnull))routeResponseCallback;
- (void)pushRouteRequest:(nonnull ARouteRequest *)routeRequest routeResponse:(void (^ _Nullable)(ARouteResponse * _Nonnull))routeResponseCallback;
- (nullable UIViewController *)viewControllerForRouteRequest:(nonnull ARouteRequest *)routeRequest;
- (nullable UIViewController *)embeddingViewControllerForRouteRequest:(nonnull ARouteRequest *)routeRequest;

@end
