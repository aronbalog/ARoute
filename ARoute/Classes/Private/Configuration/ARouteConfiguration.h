//
//  ARouteConfiguration.h
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARouteConfiguration : NSObject

@property (strong, nonatomic, nonnull) NSString *separator;
@property (strong, nonatomic, nonnull) NSString *castingSeparator;
@property (assign, nonatomic) BOOL animate;

@end
