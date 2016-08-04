#import "RouteConfiguration.h"
#import "UserViewController.h"

@implementation RouteConfiguration

@synthesize completionBlock = _completionBlock;
@synthesize failureBlock = _failureBlock;
@synthesize protectBlock = _protectBlock;
@synthesize callbackBlock = _callbackBlock;

- (BOOL)animated
{
    return NO;
}

- (Class)destinationViewControllerClass
{
    return [UserViewController class];
}

@end
