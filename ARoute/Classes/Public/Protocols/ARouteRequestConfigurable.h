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

- (nonnull id <ARouteRequestExecutable, ARouteRequestConfigurable>)animated:(BOOL(^ _Nonnull)())animated;
- (nonnull id <ARouteRequestExecutable, ARouteRequestConfigurable>)completion:(void(^ _Nonnull)(ARouteResponse * _Nonnull routeResonse))completion;
- (nonnull id <ARouteRequestExecutable, ARouteRequestConfigurable>)transitioningDelegate:(id <UIViewControllerTransitioningDelegate>_Nullable(^ _Nonnull)())transitioningDelegate;
- (nonnull id <ARouteRequestExecutable, ARouteRequestConfigurable>)parameters:(NSDictionary <id, id> * _Nullable(^ _Nonnull)())parameters;

@end
