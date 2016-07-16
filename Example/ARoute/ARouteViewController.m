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
        
    [[[[ARoute sharedRouter] route:@"user-profile/1234"] initSelector:^SEL _Nonnull{
        return @selector(anotherMethod:);
    } objects:^NSArray * _Nullable{
        return @[@"Test"];
    }] execute];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[[ARoute sharedRouter] route:@"user-profile/1234"] initSelector:^SEL _Nonnull{
            return @selector(anotherMethod:);
        } objects:^NSArray * _Nullable{
            return @[@"Test 2"];
        }] execute];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
