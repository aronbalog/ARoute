//
//  ARouteResponse.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARouteResponse : NSObject

@property (strong, nonatomic, nullable, readonly) NSDictionary <NSString *, NSString *> *routeParameters;
@property (strong, nonatomic, nullable, readonly) NSDictionary <id, id> *parameters;
@property (strong, nonatomic, nullable, readonly) __kindof UIViewController *destinationViewController;
@property (strong, nonatomic, nullable, readonly) __kindof UIViewController *embeddingViewController;

@end
