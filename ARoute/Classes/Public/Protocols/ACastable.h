//
//  AEmbeddable.h
//  ARoute
//
//  Created by Aron Balog on 16/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ACastable <NSObject>

+ (nonnull instancetype)objectWithRouteParameterValue:(nonnull NSString *)value;

@end
