//
//  ARouteRegistrationStorageResult.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARouteRegistrationStorageResult : NSObject

@property (strong, nonatomic, nonnull) ARouteRegistrationItem *routeRegistrationItem;
@property (strong, nonatomic, nullable) NSDictionary <NSString*, NSString*> *routeParameters;

@end
