//
//  ARouteRequestExecutable.h
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARouteRequestExecutable <NSObject>

- (void)execute;
- (void)execute:(void(^ _Nonnull)(ARouteResponse * _Nonnull routeResponse))routeResponse;
- (void)push;
- (void)push:(void(^ _Nonnull)(ARouteResponse * _Nonnull routeResponse))routeResponse;
- (nullable __kindof UIViewController *)viewController;
- (nullable __kindof UIViewController *)embeddingViewController;

@end
