//
//  YellowViewController.m
//  ARoute
//
//  Created by Aron Balog on 18/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "YellowViewController.h"

@interface YellowViewController ()

@end

@implementation YellowViewController

- (instancetype)initWithRouteResponse:(ARouteResponse *)routeResponse
{
    self = [self init];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
