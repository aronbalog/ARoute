//
//  UserViewController.h
//  ARoute
//
//  Created by Aron Balog on 13/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ARoute/ARoute.h>

@interface UserViewController : UIViewController <ARoutable>

- (instancetype)initCustomMethod:(NSString *)string anotherString:(NSString *)another;
- (instancetype)anotherMethod:(NSString *)string;

@end
