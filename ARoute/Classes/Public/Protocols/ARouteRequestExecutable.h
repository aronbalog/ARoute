//
//  ARouteRequestExecutable.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARouteRequestExecutable <NSObject>

- (void)execute;
- (nullable __kindof UIViewController *)viewController;

@end
