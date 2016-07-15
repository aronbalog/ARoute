//
//  MyObject.m
//  ARoute
//
//  Created by Aron Balog on 16/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "MyObject.h"

@interface MyObject ()

@property (strong, nonatomic, nonnull) NSString *myValue;

@end

@implementation MyObject

+ (instancetype)objectWithRouteParameterValue:(NSString *)value
{
    MyObject *object = [MyObject new];
    
    object.myValue = value;
    
    return object;
}

@end
