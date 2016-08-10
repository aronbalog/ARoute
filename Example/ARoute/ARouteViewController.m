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

@property (strong, nonatomic, nonnull) UserViewController *userViewController;

@end

@implementation ARouteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[[ARoute sharedRouter] route:@"home"] embedInNavigationController] execute:^(ARouteResponse * _Nonnull routeResponse) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UserViewController *)userViewController
{
    if (!_userViewController) {
        _userViewController = [UserViewController new];
    }
    
    return _userViewController;
}

@end
