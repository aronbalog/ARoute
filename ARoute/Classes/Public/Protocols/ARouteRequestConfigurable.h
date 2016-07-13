//
//  ARouteRequestConfigurable.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARouteRequestInitiable;
@protocol ARouteRequestExecutable;
@protocol ARouteRequestProtectable;
@protocol ARouteRequestEmbeddable;

@class ARouteRequestConfiguration;

@protocol ARouteRequestConfigurable <NSObject>

- (nonnull id <ARouteRequestInitiable, ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestConfigurable>)animated:(BOOL(^ _Nonnull)())animated;
- (nonnull id <ARouteRequestInitiable, ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestConfigurable>)completion:(void(^ _Nonnull)(ARouteResponse * _Nonnull routeResonse))completion;
- (nonnull id <ARouteRequestInitiable, ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestConfigurable>)transitioningDelegate:(id <UIViewControllerTransitioningDelegate>_Nullable(^ _Nonnull)())transitioningDelegate;

@end