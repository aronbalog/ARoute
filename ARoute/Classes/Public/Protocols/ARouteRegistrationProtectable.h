//
//  ARouteRegistrationProtectable.h
//  Pods
//
//  Created by Aron Balog on 14/07/16.
//
//

#import <Foundation/Foundation.h>

@protocol ARouteRegistrationExecutable;
@protocol ARouteRegistrationConfigurable;
@protocol ARouteRegistrationInitiable;

@protocol ARouteRegistrationProtectable <NSObject>

- (nonnull id <ARouteRegistrationExecutable, ARouteRegistrationConfigurable>)protect:(BOOL(^ _Nonnull)(ARouteResponse * _Nonnull routeResponse, NSError * __autoreleasing _Nullable * _Nullable errorPtr))protect;

@end
