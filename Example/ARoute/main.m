//
//  main.m
//  ARoute
//
//  Created by Aron Balog on 07/13/2016.
//  Copyright (c) 2016 Aron Balog. All rights reserved.
//

@import UIKit;
#import "ARouteAppDelegate.h"
#import "ARouteTestAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        Class appDelegate = (NSClassFromString(@"XCTestCase")) ? [ARouteTestAppDelegate class] : [ARouteAppDelegate class];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegate));
    }
}
