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

- (nonnull instancetype)embedInNavigationController;
- (nonnull instancetype)embedInNavigationController:(NSArray * _Nullable(^ _Nonnull)(ARouteResponse * _Nonnull routeResponse))aheadViewControllers;
- (nonnull instancetype)embedInTabBarController;

@end
