//
//  ARouteViewController.m
//  ARoute
//
//  Created by Aron Balog on 07/13/2016.
//  Copyright (c) 2016 Aron Balog. All rights reserved.
//

#import "ARouteViewController.h"
#import <ARoute/ARoute.h>

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
    
    [[[[ARoute sharedRouter] route:@"user-profile/{aron}"] animated:^BOOL{
        return NO;
    }] execute];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
