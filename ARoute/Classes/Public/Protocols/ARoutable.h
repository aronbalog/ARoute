//
//  ARoutable.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARouteResponse;

@protocol ARoutable <NSObject>

- (nullable instancetype)initWithRouteResponse:(nonnull ARouteResponse *)routeResponse;

@end
