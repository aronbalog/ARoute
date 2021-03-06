//
//  ARouteRequestConfiguration.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARouteRequestConfiguration : NSObject

@property (assign, nonatomic) SEL _Nonnull(^ _Nonnull constructorBlock)(ARouteResponse * _Nonnull routeResponse);
;
@property (strong, nonatomic, nullable) NSArray * _Nonnull(^ instantiationArgumentsBlock)(ARouteResponse * _Nonnull);
@property (strong, nonatomic, nullable) UIViewController * _Nullable (^embeddingViewControllerBlock)();
@property (strong, nonatomic, nullable) void (^completionBlock)(ARouteResponse * _Nonnull);
@property (strong, nonatomic, nullable) void (^failureBlock)(ARouteResponse * _Nonnull, NSError * _Nullable error);
@property (strong, nonatomic, nullable) BOOL (^animatedBlock)();
@property (strong, nonatomic, nullable) BOOL (^protectBlock)(ARouteResponse * _Nonnull routeResponse, NSError * __autoreleasing _Nullable * _Nullable errorPtr);
@property (strong, nonatomic, nullable) NSDictionary <id, id> * _Nullable(^parametersBlock)();
@property (strong, nonatomic, nullable) id <UIViewControllerTransitioningDelegate> _Nullable(^transitioningDelegateBlock)();
@property (strong, nonatomic, nullable) id <UINavigationControllerDelegate> _Nullable(^navigationViewControllerDelegateBlock)();
@property (assign, nonatomic) ARouteEmbeddingType embeddingType;
@property (strong, nonatomic, nonnull) NSArray *_Nullable(^ previousViewControllersBlock)(ARouteResponse * _Nonnull routeResponse);
@property (strong, nonatomic, nullable) Class _Nullable(^ navigationControllerClassBlock)(ARouteResponse * _Nonnull routeResponse);
@end
