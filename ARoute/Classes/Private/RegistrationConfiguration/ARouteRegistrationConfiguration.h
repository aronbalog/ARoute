//
//  ARouteRegistrationConfiguration.h
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARouteRegistrationConfiguration : NSObject

@property (strong, nonatomic, nullable) BOOL (^protectBlock)(ARouteResponse * _Nonnull routeResponse, NSError * __autoreleasing _Nullable * _Nullable errorPtr);
@property (strong, nonatomic, nullable) NSDictionary <id, id> * _Nullable(^parametersBlock)();

@end
