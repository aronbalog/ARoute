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
- (nonnull id <ARouteRegistrationExecutable, ARouteRegistrationConfigurable, ARouteRegistrationProtectable>)parameters:(NSDictionary <id, id> * _Nullable(^ _Nonnull)())parameters;
- (nonnull id <ARouteRegistrationExecutable, ARouteRegistrationConfigurable, ARouteRegistrationProtectable>)separator:(NSString * _Nonnull(^ _Nonnull)())separator;

@end
