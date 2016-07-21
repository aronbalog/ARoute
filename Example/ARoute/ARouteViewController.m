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
    /*
    [[[[[[[[[[[ARoute sharedRouter] route:@"user/12345"] embedInNavigationController:^NSArray * _Nullable(ARouteResponse * _Nonnull routeResponse) {
        return @[[HomeViewController new], @"second"];
    }] protect:^BOOL(ARouteResponse * _Nonnull routeResponse, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        *errorPtr = [NSError errorWithDomain:@"my.domain" code:1000 userInfo:@{@"message": @"not authorized"}];
        return YES;
    }] constructor:^SEL _Nonnull(ARouteResponse * _Nonnull routeResponse) {
        return @selector(initCustomMethod:anotherString:);
    } objects:^NSArray * _Nullable(ARouteResponse * _Nonnull routeResponse) {
        return @[@"Title", @"Name"];
    }] parameters:^NSDictionary<id,id> * _Nullable{
        return @{
                 @"Key1": @"Value1",
                 @"Key2": @"Value2"
                 };
    }] transitioningDelegate:^id<UIViewControllerTransitioningDelegate> _Nullable{
        // return object conforming <UIViewControllerTransitioningDelegate>
        return nil;
    }] animated:^BOOL{
        return YES;
    }] completion:^(ARouteResponse * _Nonnull routeResponse) {
        
    }] failure:^(ARouteResponse * _Nonnull routeResponse, NSError * _Nullable error) {
        
    }] execute:^(ARouteResponse * _Nonnull routeResponse) {
        
    }];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
