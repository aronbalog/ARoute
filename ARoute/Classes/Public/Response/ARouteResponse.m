//
//  ARouteResponse.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteResponse.h"
#import <objc/runtime.h>

@interface ARouteResponse ()

@property (strong, nonatomic, nullable, readwrite) NSDictionary <NSString *, id> *routeParameters;
@property (strong, nonatomic, nullable, readwrite) NSDictionary <NSString *, NSString *> *rawRouteParameters;
@property (strong, nonatomic, nullable, readwrite) NSDictionary <NSDictionary *, NSDictionary *> *parameters;
@property (strong, nonatomic, nullable, readwrite) __kindof UIViewController *destinationViewController;
@property (strong, nonatomic, nullable, readwrite) __kindof UIViewController *embeddingViewController;
@property (strong, nonatomic, nonnull) NSString *castingSeparator;

@end

@implementation ARouteResponse

- (void)setRouteParameters:(NSDictionary<NSString *,id> *)routeParameters
{
    _rawRouteParameters = routeParameters;
    _routeParameters = [self castedRouteParameters:routeParameters];
}

#pragma mark - Private

- (NSDictionary *)castedRouteParameters:(NSDictionary *)routeParameters
{
    NSMutableDictionary *castedRouteParameters = [NSMutableDictionary new];
    
    [routeParameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray <NSString *> *components = [key componentsSeparatedByString:self.castingSeparator];
        if (components.count == 2) {
            // check for scalar casting
            if ([components[1].lowercaseString isEqualToString:@"bool"]) {
                if ([obj.lowercaseString isEqualToString:@"true"]) {
                    castedRouteParameters[components.firstObject] = [NSNumber numberWithBool:YES];
                } else if ([obj.lowercaseString isEqualToString:@"false"]) {
                    castedRouteParameters[components.firstObject] = [NSNumber numberWithBool:NO];
                } else {
                    castedRouteParameters[components.firstObject] = [NSNumber numberWithBool:obj.boolValue];
                }
            } else {
                Class aClass = [self classForCasting:components[1]];
                castedRouteParameters[components.firstObject] = [self castedValue:obj toClass:aClass];
            }
        } else {
            castedRouteParameters[key] = obj;
        }
    }];
    
    return castedRouteParameters;
}

- (id)castedValue:(NSString *)value toClass:(Class)aClass
{
    if ([aClass instancesRespondToSelector:@selector(objectWithRouteParameterValue:)]) {
        return [[aClass alloc] initWithRouteParameterValue:value];
    }
    
    if (aClass == [NSNumber class]) {
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        return [numberFormatter numberFromString:value];
    } else if (aClass == [NSDecimalNumber class]) {
        return [NSDecimalNumber decimalNumberWithString:value];
    }
    
    return value;
}

- (Class)classForCasting:(NSString *)casting
{
    Class aClass = NSClassFromString(casting);
    if (object_isClass(aClass)) {
        return aClass;
    }
    
    if ([casting.lowercaseString isEqualToString:@"number"]) {
        return [NSNumber class];
    } else if ([casting.lowercaseString isEqualToString:@"decimal"]) {
        return [NSDecimalNumber class];
    }
    
    return [NSString class];
}

#pragma mark - Properties

- (NSString *)castingSeparator
{
    if (!_castingSeparator) {
        _castingSeparator = @"|";
    }
    
    return _castingSeparator;
}

@end
