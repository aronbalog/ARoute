//
//  ARouteRegistrationExecutable.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARouteRegistrationConfigurable;
@protocol ARouteRegistrationProtectable;
@protocol ARouteRegistrationInitiable;

@protocol ARouteRegistrationExecutable <NSObject>

- (void)execute;

@end
