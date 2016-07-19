//
//  ARouteAppDelegate.m
//  ARoute
//
//  Created by Aron Balog on 07/13/2016.
//  Copyright (c) 2016 Aron Balog. All rights reserved.
//

#import "ARouteAppDelegate.h"

#import <ARoute/ARoute.h>

#import "HomeViewController.h"
#import "UserViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@implementation ARouteAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *route = @{@"second":[SecondViewController class]};
    
    [[[ARoute sharedRouter] registerRoutes:route] execute];
    
    NSDictionary *routes =
    @{
      @"home":[HomeViewController class],
      @"first":[FirstViewController class],
      @"user/{userId=number}": [UserViewController class]
      };
    
    [[[[[[ARoute sharedRouter]
        registerRoutes:routes] separator:^NSString * _Nonnull{
        return @"{}";
    }] parameters:^NSDictionary<id,id> * _Nullable{
        return @{@"Key3":@"Value3"};
    }] castingSeparator:^NSString * _Nonnull{
        return @"=";
    }] execute];
    
    return YES;
}

@end
