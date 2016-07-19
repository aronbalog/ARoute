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

#import "HomeViewController.h"
#import "BlueViewController.h"
#import "YellowViewController.h"
#import "RedViewController.h"
#import "GrayViewController.h"

SpecBegin(ARoute)

beforeEach(^{
    [[ARoute sharedRouter] clearAllRouteRegistrations];
});

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

describe(@"when registering route with parameters", ^{
    ARoute *sut = [ARoute sharedRouter];
    
    NSDictionary *parameters = @{@"key1": @"value1"};
    
    NSDictionary *routes = @{
                             @"test":[RoutableViewController class]
                             };
    
    [[[sut registerRoutes:routes] parameters:^NSDictionary<id,id> * _Nullable{
        return parameters;
    }] execute];
    
    context(@"and executing route", ^{
        __block ARouteResponse *completeRouteResponseObject;
        
        NSDictionary *parameters2 = @{@"key2": @"value2",
                                      @"key1": @"value3"
                                      };
        
        waitUntil(^(DoneCallback done) {
            [[[[sut route:@"test"] parameters:^NSDictionary<id,id> * _Nullable{
                return parameters2;
            }] completion:^(ARouteResponse *routeResponse){
                completeRouteResponseObject = routeResponse;
                done();
            }] execute];
        });
        
        it(@"routeResponse object in completon is overriden", ^{
            NSDictionary *expected = @{@"key1":@"value3",
                                       @"key2":@"value2"};
            expect(completeRouteResponseObject.parameters).to.equal(expected);
        });
    });
});

fdescribe(@"when registering route with embedding in navigation controller with stack", ^{
    ARoute *sut = [ARoute sharedRouter];
    
    NSDictionary *routes = @{
                             @"home":[HomeViewController class],
                             @"blue":[BlueViewController class],
                             @"yellow":[YellowViewController class],
                             @"red":[RedViewController class]
                             };
    
    [[sut registerRoutes:routes] execute];
    
    context(@"and executing route", ^{
        __block ARouteResponse *completeRouteResponseObject;
        
        waitUntil(^(DoneCallback done) {
            [[[[sut route:@"home"] embedInNavigationController:^NSArray * _Nullable(ARouteResponse * _Nonnull routeResponse) {
                return @[@"red", @"yellow", [BlueViewController class], [GrayViewController new]];
            }] completion:^(ARouteResponse *routeResponse){
                completeRouteResponseObject = routeResponse;
                done();
            }] execute];
        });
        
        UINavigationController *navigationController = completeRouteResponseObject.embeddingViewController;
        
        it(@"embedding view controller is navigation controller", ^{
            expect(completeRouteResponseObject.embeddingViewController).to.beInstanceOf([UINavigationController class]);
        });
        
        it(@"navigation controller has red vc 1", ^{
            expect(navigationController.viewControllers[0]).to.beInstanceOf([RedViewController class]);
            
        });
        
        it(@"navigation controller has yellow vc 2", ^{
            expect(navigationController.viewControllers[1]).to.beInstanceOf([YellowViewController class]);
            
        });
        
        it(@"navigation controller has blue vc 3", ^{
            expect(navigationController.viewControllers[2]).to.beInstanceOf([BlueViewController class]);
            
        });
        
        it(@"navigation controller has gray vc 4", ^{
            expect(navigationController.viewControllers[3]).to.beInstanceOf([GrayViewController class]);
            
        });

    });
});


SpecEnd
