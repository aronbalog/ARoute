//
//  ARouteResponse.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteResponse.h"

@interface ARouteResponse ()

@property (strong, nonatomic, nullable, readwrite) NSDictionary <NSString *, NSString *> *routeParameters;
@property (strong, nonatomic, nullable, readwrite) NSDictionary <NSDictionary *, NSDictionary *> *parameters;
@property (strong, nonatomic, nullable, readwrite) __kindof UIViewController *destinationViewController;
@property (strong, nonatomic, nullable, readwrite) __kindof UIViewController *embeddingViewController;

@end

@implementation ARouteResponse

@end
