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

- (nonnull id <ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)initSelector:(SEL _Nonnull(^ _Nonnull)())initSelector objects:(NSArray * _Nullable(^ _Nullable)())objects;
- (nonnull id <ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestEmbeddable, ARouteRequestConfigurable>)parameters:(NSDictionary <id, id> * _Nullable(^ _Nonnull)())parameters;

@end
