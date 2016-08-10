//
//  ARouteRequestInitiable.h
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARouteRequestConfiguration;

@protocol ARouteRequestExecutable;
@protocol ARouteRequestProtectable;
@protocol ARouteRequestEmbeddable;
@protocol ARouteRequestConfigurable;

@protocol ARouteRequestInitiable <NSObject>

- (nonnull id <ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)constructor:(SEL _Nonnull(^ _Nonnull)(ARouteResponse * _Nonnull routeResponse))constructor objects:(NSArray * _Nullable(^ _Nullable)(ARouteResponse * _Nonnull routeResponse))objects;
- (nonnull id <ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)embedInNavigationController;
- (nonnull id <ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)embedInNavigationControllerClass:(Class _Nonnull(^ _Nonnull)(ARouteResponse * _Nonnull routeResponse))navigationControllerClass;
- (nonnull id <ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)embedInNavigationController:(NSArray * _Nullable(^ _Nonnull)(ARouteResponse * _Nonnull routeResponse))previousViewControllers;
- (nonnull id <ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)embedInTabBarController;

@end
