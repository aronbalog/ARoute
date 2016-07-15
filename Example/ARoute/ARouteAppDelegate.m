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

@implementation ARouteAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *routes =
    @{
      @"home":[HomeViewController class],
      @"user-profile/{userId=number}": [UserViewController class]
      };
    
    [[[[ARoute sharedRouter] registerRoutes:routes] castingSeparator:^NSString*{
        return @"=";
    }] execute];
    
    return YES;
}

@end
