//
//  ARouteRegistrationItem.h
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARoute;

typedef NS_ENUM(NSInteger, ARouteRegistrationItemType) {
    ARouteRegistrationItemTypeRoute,
    ARouteRegistrationItemTypeNamedRoute
};

typedef NS_ENUM(NSInteger, ARouteEmbeddingType) {
    ARouteEmbeddingTypeNotDefined,
    ARouteEmbeddingTypeDoNotEmbed,
    ARouteEmbeddingTypeNavigationController,
    ARouteEmbeddingTypeTabBarController,
    ARouteEmbeddingTypeCustomViewController
};

@interface ARouteRegistrationItem : NSObject

@property (strong, nonatomic, nonnull) ARoute *router;
@property (strong, nonatomic, nonnull) NSString *route;
@property (strong, nonatomic, nonnull) NSString *routeName;
@property (strong, nonatomic, nonnull) Class destinationViewControllerClass;
@property (strong, nonatomic, nonnull) void (^destinationCallback)(ARouteResponse * _Nonnull routeResponse);
@property (strong, nonatomic, nonnull) BOOL (^protectBlock)(ARouteResponse * _Nonnull routeResponse, NSError * __autoreleasing _Nullable * _Nullable errorPtr);
@property (strong, nonatomic, nullable) NSDictionary <id, id> * _Nullable(^parametersBlock)();
@property (strong, nonatomic, nonnull) NSString *separator;
@property (strong, nonatomic, nonnull) NSString *castingSeparator;
@property (assign, nonatomic) ARouteRegistrationItemType type;
@property (assign, nonatomic) ARouteEmbeddingType embeddingType;
@property (assign, nonatomic) NSArray * _Nonnull(^ _Nonnull previousViewControllersBlock)(ARouteResponse * _Nonnull routeResponse);

@end
