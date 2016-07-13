//
//  AEmbeddable.h
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARouteResponse;

@protocol AEmbeddable <NSObject>

- (void)embedDestinationViewController:(nonnull UIViewController *)destinationViewController withRouteResponse:(nonnull ARouteResponse *)routeResponse;

@end
