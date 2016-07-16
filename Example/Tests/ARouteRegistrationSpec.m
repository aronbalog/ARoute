//
//  ARouteRegistrationSpec.m
//  ARoute
//
//  Created by Aron Balog on 16/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RoutableViewController.h"
#import <ARoute/ARoute.h>

SpecBegin(ARoute)

describe(@"when registering route with class parameters", ^{
    ARoute *sut = [ARoute sharedRouter];
    NSString *routeParamKey = @"testingParam";
    NSNumber *routeParamValue = @1234;
    
    NSString *routeKey = [NSString stringWithFormat:@"test/{%@|NSNumber}", routeParamKey];
    
    NSDictionary *routes = @{
                             routeKey:[RoutableViewController class]
                             };
    
    [[sut registerRoutes:routes] execute];
    
    context(@"and executing route", ^{
        NSString *route = [NSString stringWithFormat:@"test/%@", routeParamValue];
        __block ARouteResponse *completeRouteResponseObject;
        
        waitUntil(^(DoneCallback done) {
            [[[sut route:route] completion:^(ARouteResponse *routeResponse){
                completeRouteResponseObject = routeResponse;
                done();
            }] execute];
        });
        
        it(@"routeResponse object in completon is not nil", ^{
            expect(completeRouteResponseObject).toNot.beNil();
        });

        NSDictionary *routeParameters = completeRouteResponseObject.routeParameters;
        context(@"route parameters object", ^{
            it(@"did map key", ^{
                NSString *key = routeParameters.allKeys.firstObject;
                
                expect(key).to.equal(routeParamKey);
            });
            
            it(@"did map value", ^{
                NSString *value = routeParameters.allValues.firstObject;
                
                expect(value).to.equal(routeParamValue);
            });
            
        });
        
        context(@"destination view controller", ^{
            it(@"exists", ^{
                UIViewController *viewController = completeRouteResponseObject.destinationViewController;
                expect(viewController).toNot.beNil();
            });
        });
    });
});


SpecEnd
