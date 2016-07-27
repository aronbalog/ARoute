//
//  ARouteViewController.m
//  ARoute
//
//  Created by Aron Balog on 07/13/2016.
//  Copyright (c) 2016 Aron Balog. All rights reserved.
//

#import "ARouteViewController.h"
#import <ARoute/ARoute.h>
#import "UserViewController.h"
#import "HomeViewController.h"
@interface ARouteViewController ()

@end

@implementation ARouteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[[[[[[[[ARoute sharedRouter] route:@"user/12345"] embedInNavigationController] protect:^BOOL(ARouteResponse * _Nonnull routeResponse, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        // return YES if you don't want to handle the route
        return NO;
    }] parameters:^NSDictionary*{
        return @{
                 @"Key1": @"Value1",
                 @"Key2": @"Value2"
                 };
    }] transitioningDelegate:^id<UIViewControllerTransitioningDelegate>{
        // return object conforming <UIViewControllerTransitioningDelegate>
        return nil;
    }] animated:^BOOL{
        return YES;
    }] completion:^(ARouteResponse *routeResponse) {
        
    }] failure:^(ARouteResponse * _Nonnull routeResponse, NSError * _Nullable error) {
        
    }] execute];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
