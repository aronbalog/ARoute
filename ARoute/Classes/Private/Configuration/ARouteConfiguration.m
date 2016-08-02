//
//  ARouteConfiguration.m
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteConfiguration.h"

@implementation ARouteConfiguration

- (NSString *)separator
{
    if (!_separator) {
        _separator = @"{}";
    }
    
    return _separator;
}

- (NSString *)castingSeparator
{
    if (!_castingSeparator) {
        _castingSeparator = @"|";
    }
    
    return _castingSeparator;
}

- (BOOL)animate
{
    if (!_animate) {
        _animate = YES;
    }
    
    return _animate;
}

@end
