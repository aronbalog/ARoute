//
//  ARouteRequestEmbeddable.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARouteRequestInitiable;
@protocol ARouteRequestExecutable;
@protocol ARouteRequestProtectable;
@protocol ARouteRequestConfigurable;

@class ARouteRequestConfiguration;

@protocol ARouteRequestEmbeddable <NSObject>

- (nonnull id <ARouteRequestInitiable, ARouteRequestExecutable, ARouteRequestProtectable, ARouteRequestConfigurable>)embedIn:(__kindof UIViewController <AEmbeddable> * _Nonnull(^ _Nonnull)())embeddingViewController;
@end
