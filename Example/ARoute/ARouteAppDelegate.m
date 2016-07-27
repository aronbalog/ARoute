//
//  ARouteAppDelegate.m
//  ARoute
//
//  Created by Aron Balog on 07/13/2016.
//  Copyright (c) 2016 Aron Balog. All rights reserved.
//

#import "ARouteAppDelegate.h"

#import <ARoute/ARoute.h>

#import "UserViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "YellowViewController.h"
#import "HomeViewController.h"
#import "RouteConfiguration.h"

@implementation ARouteAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RouteConfiguration *config = [RouteConfiguration new];
    config.callbackBlock = ^(ARouteResponse *routeResponse) {
        
    };
    
    NSDictionary *routes = @{
      @"home":[HomeViewController class],
      @"user/{userId|number}":config
      };
    
    [[[ARoute sharedRouter] registerRoutes:routes] execute];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    [[[ARoute sharedRouter] URL:url] execute];
    return YES;
}

@end
