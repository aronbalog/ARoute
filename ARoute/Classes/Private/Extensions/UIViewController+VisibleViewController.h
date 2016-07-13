//
//  UIViewController+VisibleViewController.h
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (VisibleViewController)

+ (nonnull instancetype)visibleViewController:(nullable UIViewController *)rootViewController;

@end
