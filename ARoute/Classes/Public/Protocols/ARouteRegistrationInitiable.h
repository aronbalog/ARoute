//
//  ARouteRegistrationInitiable.h
//  Pods
//
//  Created by Aron Balog on 14/07/16.
//
//

#import <Foundation/Foundation.h>

@protocol ARouteRegistrationExecutable;
@protocol ARouteRegistrationConfigurable;
@protocol ARouteRegistrationProtectable;

@protocol ARouteRegistrationInitiable <NSObject>

- (nonnull id <ARouteRegistrationExecutable, ARouteRegistrationConfigurable, ARouteRegistrationProtectable>)separator:(NSString * _Nonnull(^ _Nonnull)())separator;
- (nonnull id <ARouteRegistrationExecutable, ARouteRegistrationConfigurable, ARouteRegistrationProtectable>)parameters:(NSDictionary <id, id> * _Nullable(^ _Nonnull)())parameters;

@end
