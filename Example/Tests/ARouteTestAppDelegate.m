//
//  ARouteTestAppDelegate.m
//  ARoute
//
//  Created by Aron Balog on 18/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteTestAppDelegate.h"

@implementation ARouteTestAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController *rootViewController = [UIViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = rootViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
