//
//  ARouteRegistrationConfigurable.h
//  Pods
//
//  Created by Aron Balog on 14/07/16.
//
//

#import <Foundation/Foundation.h>

@protocol ARouteRegistrationExecutable;
@protocol ARouteRegistrationInitiable;
@protocol ARouteRegistrationProtectable;

@protocol ARouteRegistrationConfigurable <NSObject>

- (nonnull id <ARouteRegistrationExecutable, ARouteRegistrationConfigurable, ARouteRegistrationProtectable>)castingSeparator:(NSString * _Nonnull(^ _Nullable)())castingSeparator;

@end
