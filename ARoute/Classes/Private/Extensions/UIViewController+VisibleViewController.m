//
//  UIViewController+VisibleViewController.m
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "UIViewController+VisibleViewController.h"

@implementation UIViewController (VisibleViewController)

+ (instancetype)visibleViewController:(UIViewController *)rootViewController
{
    if (!rootViewController) {
        rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        if (!rootViewController) {
            return nil;
        }
    }
    
    if (!rootViewController.presentedViewController) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [self visibleViewController:lastViewController];
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return [self visibleViewController:selectedViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    
    return [self visibleViewController:presentedViewController];
}

@end
