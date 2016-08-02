//
//  ARouteRegistrationItem.h
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARoute.h"
#import "AConfigurable.h"

typedef NS_ENUM(NSInteger, ARouteRegistrationItemType) {
    ARouteRegistrationItemTypeRoute,
    ARouteRegistrationItemTypeNamedRoute
};

@interface ARouteRegistrationItem : NSObject

@property (strong, nonatomic, nonnull) ARoute *router;
@property (strong, nonatomic, nonnull) NSString *route;
@property (strong, nonatomic, nonnull) NSString *routeName;
@property (strong, nonatomic, nullable) Class destinationViewControllerClass;
@property (strong, nonatomic, nullable) __kindof UIViewController *destinationViewController;
@property (strong, nonatomic, nonnull) id (^destinationCallback)(ARouteResponse * _Nonnull routeResponse);
@property (strong, nonatomic, nonnull) BOOL (^protectBlock)(ARouteResponse * _Nonnull routeResponse, NSError * __autoreleasing _Nullable * _Nullable errorPtr);
@property (strong, nonatomic, nullable) NSDictionary <id, id> * _Nullable(^parametersBlock)();
@property (strong, nonatomic, nonnull) NSString *separator;
@property (strong, nonatomic, nonnull) NSString *castingSeparator;
@property (assign, nonatomic) ARouteRegistrationItemType type;
@property (assign, nonatomic) ARouteEmbeddingType embeddingType;
@property (assign, nonatomic, nonnull) NSArray * _Nonnull(^previousViewControllersBlock)(ARouteResponse * _Nonnull routeResponse);
@property (strong, nonatomic, nonnull) id <AConfigurable> configurationObject;

@end
