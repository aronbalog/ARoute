//
//  ARouteAction.h
//  ARoute
//
//  Created by Aron Balog on 01/08/16.
//
//

#import <Foundation/Foundation.h>

#import "AConfigurable.h"

@interface ARouteAction : NSObject <AConfigurable>

@property (strong, nonatomic, nullable) Class destinationViewControllerClass;
@property (strong, nonatomic, nullable) __kindof UIViewController *destinationViewController;
@property (strong, nonatomic, nullable) NSString *separator;
@property (strong, nonatomic, nullable) NSString *castingSeparator;
@property (assign, nonatomic) BOOL animated;
@property (strong, nonatomic, nullable) NSDictionary *parameters;
@property (strong, nonatomic, nullable) void (^callbackBlock)(ARouteResponse * _Nonnull routeResponse);
@property (strong, nonatomic, nullable) id <UIViewControllerTransitioningDelegate> transitioningDelegate;
@property (assign, nonatomic) ARouteEmbeddingType embeddingType;
@property (strong, nonatomic, nullable) NSArray *previousEmbeddingItems;
@property (strong, nonatomic, nullable) __kindof UIViewController <AEmbeddable> *customEmbeddingViewController;
@property (assign, nonatomic) SEL _Nullable constructorSelector;
@property (strong, nonatomic, nullable) void (^completionBlock)(ARouteResponse * _Nonnull routeResponse);
@property (strong, nonatomic, nullable) void (^failureBlock)(ARouteResponse * _Nonnull routeResponse, NSError * _Nullable error);
@property (strong, nonatomic, nullable) BOOL (^protectBlock)(ARouteResponse * _Nonnull routeResponse, NSError * __autoreleasing _Nullable * _Nullable errorPtr);

@end
