//
//  UIViewController+TransitioningDelegate.m
//  ARoute
//
//  Created by Aron Balog on 01/08/16.
//
//

#import "UIViewController+TransitioningDelegate.h"
#import <objc/runtime.h>

@implementation UIViewController (TransitioningDelegate)

@dynamic aroute_transitioningDelegate;
@dynamic aroute_navigationControllerDelegate;

- (void)setAroute_transitioningDelegate:(id<UIViewControllerTransitioningDelegate>)aroute_transitioningDelegate
{
    objc_setAssociatedObject(self, @selector(aroute_transitioningDelegate), aroute_transitioningDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIViewControllerTransitioningDelegate>)aroute_transitioningDelegate
{
    return objc_getAssociatedObject(self, @selector(aroute_transitioningDelegate));
}

- (void)setAroute_navigationControllerDelegate:(id<UINavigationControllerDelegate>)aroute_navigationControllerDelegate
{
    objc_setAssociatedObject(self, @selector(aroute_navigationControllerDelegate), aroute_navigationControllerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UINavigationControllerDelegate>)aroute_navigationControllerDelegate
{
    return objc_getAssociatedObject(self, @selector(aroute_navigationControllerDelegate));
}

@end
