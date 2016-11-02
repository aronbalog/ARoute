//
//  UIViewController+TransitioningDelegate.h
//  Pods
//
//  Created by Aron Balog on 01/08/16.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (TransitioningDelegate)

@property (strong, nonatomic, nullable) id <UIViewControllerTransitioningDelegate> aroute_transitioningDelegate;
@property (strong, nonatomic, nullable) id <UINavigationControllerDelegate> aroute_navigationControllerDelegate;

@end
