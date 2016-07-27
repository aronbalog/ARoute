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
#import "YellowViewController.h"

@implementation ARouteAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *routes =
    @{
      @"home":[HomeViewController class],
      @"first":[FirstViewController class],
      @"user/{userId=number}": [UserViewController class]
      };
    
    [[[[ARoute sharedRouter]
        registerRoutes:routes] protect:^BOOL(ARouteResponse * _Nonnull routeResponse, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        return YES;
    }] execute];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    [[[ARoute sharedRouter] URL:url] execute];
    return YES;
}

@end
