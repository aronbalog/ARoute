//
//  UserViewController.m
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "UserViewController.h"

@implementation UserViewController

- (instancetype)initCustomMethod:(NSString *)string anotherString:(NSString *)another
{
    self = [[UserViewController alloc] init];
    
    NSLog(@"Route response: %@", string);

    
    return self;
}

- (instancetype)anotherMethod:(NSString *)string
{
    UserViewController *vc = [UserViewController new];
    
    NSLog(@"Route response: %@", string);
    
    return vc;
}

- (instancetype)initWithRouteResponse:(ARouteResponse *)routeResponse
{
    self = [self init];
    
    NSLog(@"Route response: %@", routeResponse);
    
    return self;
}

@end
