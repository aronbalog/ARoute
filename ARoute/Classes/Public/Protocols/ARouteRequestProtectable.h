//
//  ARouteRequestProtectable.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARouteRequestProtectable <NSObject>

- (nonnull id <ARouteRequestInitiable, ARouteRequestExecutable,ARouteRequestEmbeddable, ARouteRequestConfigurable>)protect:(BOOL(^ _Nonnull)(ARouteResponse * _Nonnull routeResponse))protect;

@end
