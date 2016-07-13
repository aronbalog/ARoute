//
//  UserViewController.m
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "UserViewController.h"

@implementation UserViewController

- (instancetype)initWithRouteResponse:(ARouteResponse *)routeResponse
{
    self = [self init];
    
    NSLog(@"Route response: %@", routeResponse);
    
    return self;
}

@end
