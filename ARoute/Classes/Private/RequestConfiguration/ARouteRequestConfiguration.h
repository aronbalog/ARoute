//
//  ARouteRequestConfiguration.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARouteRequestConfiguration : NSObject

@property (assign, nonatomic) SEL _Nullable instantiationSelector;
@property (strong, nonatomic, nullable) NSArray *instantiationArguments;
@property (strong, nonatomic, nullable) UIViewController * _Nullable (^embeddingViewControllerBlock)();
@property (strong, nonatomic, nullable) void (^completionBlock)(ARouteResponse * _Nonnull);
@property (strong, nonatomic, nullable) BOOL (^animatedBlock)();
@property (strong, nonatomic, nullable) BOOL (^protectBlock)(ARouteResponse * _Nonnull routeResponse);
@property (strong, nonatomic, nullable) NSDictionary <id, id> * _Nullable(^parametersBlock)();
@property (strong, nonatomic, nullable) id <UIViewControllerTransitioningDelegate> _Nullable(^transitioningDelegateBlock)();

@end
