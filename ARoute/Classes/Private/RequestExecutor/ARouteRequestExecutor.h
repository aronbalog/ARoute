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

- (void)executeRouteRequest:(nonnull ARouteRequest *)routeRequest;

@end
