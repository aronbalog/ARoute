# ARoute

[![Build Status](https://travis-ci.org/aronbalog/ARoute.svg?branch=master)](https://travis-ci.org/aronbalog/ARoute)
[![Version](https://img.shields.io/cocoapods/v/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)
[![License](https://img.shields.io/cocoapods/l/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)
[![Platform](https://img.shields.io/cocoapods/p/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)

## Table of contents

1. [Demo](#demo)
1. [Requirements](#requirements)
1. [Installation](#installation)
1. [Simple usage](#simple-usage)
	1. [Route registration](#route-registration)
	1. [Route execution](#route-execution)
	1. [Animations](#animations)
1. [Advanced usage](#advanced-usage)
	1. [Parameters](#parameters)
	1. [Custom separator](#custom-separator)
	1. [Parameter casting](#parameter-casting)
	1. [Callbacks](#callbacks)
	1. [Custom animations](#custom-animations)
	1. [Embedding](#embedding)
	1. [Custom initiation](#custom-initiation)
	1. [Catching completion & failure](#catching-completion-failure) 
1. [ACL](#acl)
1. [`ARouteResponse`](#ARouteResponse)
1. [Routes separation](#routes-separation)

<br><br>

## <a name="demo"></a> Demo

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## <a name="requirements"></a> Requirements

- iOS 7.0 or greater

## <a name="installation"></a> Installation

ARoute is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ARoute"
```

--

<br><br>
## <a name="simple-usage"></a> 🍼 Simple usage

### <a name="route-registration"></a> Route registration

First thing to be done is registering the routes on appropriate place in app, e.g. `AppDelegate`:

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *routes = @{
                             @"home":[HomeViewController class],
                             @"user-profile/{userId}": [UserViewController class]
                             };
    
    [[[ARoute sharedRouter] registerRoutes:routes] execute];
    
    return YES;
}

```

Take a look at route:

- `user-profile/{userId}`

Notice that `userId` is wrapped in `{` `}`.

This parameter and its value will be accesible in `ARouteResponse`'s property `routeParameters` which is actually `NSDictionary` object. Read more about `ARouteResponse`.

### <a name="route-execution"></a> Route execution

Executing the route is trivial.

Pass the route pattern string you used in route registration, but remember to replace the wrapped value with the actual one.

```
- (void)openUserProfileViewControllerWithUserId:(NSString *)userId
{
	NSString *userProfileRoute = [NSString stringWithFormat:@"user-profile/%@", userId];
	[[[ARoute sharedRouter] route:userProfileRoute] execute];
}
```

### <a name="animations"></a> Animations

Simple and easy:

```
- (void)openUserProfileViewControllerWithUserId:(NSString *)userId
{
	NSString *userProfileRoute = [NSString stringWithFormat:@"user-profile/%@", userId];

	[[[[ARoute sharedRouter] route:userProfileRoute] animated:^BOOL{
        return NO;
    }] execute];
}
```

--

<br><br>
## <a name="advanced-usage"></a> 🚀 Advanced usage

### <a name="custom-separator"></a> Custom separator
If you have different route parameter separator in mind, you can customise it:

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *routes =
        @{
                @"home":[HomeViewController class],
                @"user-profile/:userId:": [UserViewController class]
        };
	[[[[ARoute sharedRouter] registerRoutes:routes] separator:^NSString *{
        return @":";
	}] execute];

}    
```

That means that route parameters should be wrapped in chosen separator.

If you would like to wrap route parameters in opening and closing characters, return such string in callback.

Examples:

Registration pattern           | Separator         | Execution pattern               | Parameter object
:----------------------------- | :---------------- | :------------------------------ | :------------------------------
`user/id-{userId}`             | `{}` (default)    | `user/id-123456`                | `@{@"userId": @"123456"}`
`user/id-!userId/profile`      | `!` or `!!`       | `user/id-123456/profile`        | `@{@"userId": @"123456"}`
`user/name-!userName/profile`  | `!` or `!!`       | `user/name-my-name/profile`     | `@{@"userName": @"my-name"}`
`user/:first:-:last:/profile`  | `:` or `::`       | `user/aron-balog/profile`       | `@{@"first": @"aron", @"last": @"balog"}`

### <a name="parameters"></a> Parameters

Passing parameters is possible using both registration end executing the route.

Route registration:

```
[[[[ARoute sharedRouter] registerRoutes:routes] parameters:^NSDictionary<id,id> *{
    return @{@"message":@"some default message"};
}] execute];
```
Route execution:

```
[[[[ARoute sharedRouter] route:route] parameters:^NSDictionary<id,id> *{
	return @{@"message2": @"Another message"};
}] execute];
```
Note: If you use same parameter keys in registration and execution, priority will be on execution parameter.<br>`ARouteResponse` will receive combined values of both parameters.
E.g. this example will return following dictionary (`routeResponse.parameters`):

```
@{
	@"message":@"some default message"
	@"message2": @"Another message"
}
```

### <a name="parameter-casting"></a> Parameter casting

ARoute supports parameter casting. Examples:

```
NSDictionary *routes = @{
  @"user-profile/{userId|number}": [UserViewController class]
};
    
[[[ARoute sharedRouter] registerRoutes:routes] execute];
```

You can also define a specific casting class:

```
NSDictionary *routes = @{
  @"user-profile/{userId|NSDecimalNumber}": [UserViewController class]
};
    
[[[ARoute sharedRouter] registerRoutes:routes] execute];
```

It works with your custom objects.

```
NSDictionary *routes = @{
  @"user-profile/{userId|MyObject}": [UserViewController class]
};
    
[[[ARoute sharedRouter] registerRoutes:routes] execute];
```
On your object you must implement method:
`+ (instancetype)objectWithRouteParameterValue:(NSString *)value;`
from `<ACastable>` protocol.

Casting pattern                 | Resolving class             | Route example
:------------------------------ | :-------------------------- | :-----------
| `undefined`                   | `NSString`                  | `@"user-profile/{userId}"`|
| `string` or `NSString`        | `NSString`                  | `@"user-profile/{userId|string}"`|
| `number` or `NSNumber`        | `NSNumber`                  | `@"user-profile/{userId|number}"`|
| `decimal` or `NSDecimalNumber`| `NSDecimalNumber`           | `@"user-profile/{userId|decimal}"`|
| `MyCustomClass`               | `MyCustomClass`             | `@"user-profile/{userId|MyCustomClass}"`|

#####There is more!

If parameters casting separator needs to be changed, you can do it this way:

```
NSDictionary *routes =
@{
  @"user-profile/{userId=number}": [UserViewController class]
};
    
[[[[ARoute sharedRouter] registerRoutes:routes] castingSeparator:^NSString*{
    return @"=";
}] execute];
```

### <a name="callbacks"></a> Callbacks

You can link a callback to a route:

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *routes =
    	@{
				@"home":[HomeViewController class],
				@"user-profile/{userId}": [UserViewController class],
				@"friends/{userId}/delete":^(ARouteResponse *routeResponse){
					NSLog(@"Deleting user with ID %@", routeResponse.routeParameters[@"userId"]);
					// e.g. call your deletion method here   
				}
		};
    
    [[[ARoute sharedRouter] registerRoutes:routes] execute];
    
    return YES;
}
```
... then call (execute) the route:

```
- (void)deleteFriendWithId:(NSString *)userId
{ 
	NSString *route = [NSString stringWithFormat:@"friends/%@/delete", userId];
	[[[ARoute sharedRouter] route:route] execute];
}
```

### <a name="custom-animations"></a> Custom animations

It is possible to forward `<UIViewControllerTransitioningDelegate>` to destination view controller. Just call `transitioningDelegate` block and return an object conformed to `<UIViewControllerTransitioningDelegate>` protocol.

```
- (void)openUserProfileViewControllerWithUserId:(NSString *)userId
{
 	NSString *userProfileRoute = [NSString stringWithFormat:@"user-profile/%@", userId];

	id <UIViewControllerTransitioningDelegate> animator = [Animator new];

	[[[[ARoute sharedRouter] route:userProfileRoute] transitioningDelegate:^id<UIViewControllerTransitioningDelegate>{
        return animator;
    }] execute];
}
```

### <a name="embedding"></a> Embedding

Embedding destination view controller in custom view controller is possible by returning an object conforming `<AEmbeddable>` protocol in `embedIn:` block.

```
- (void)openUserProfileViewControllerWithUserId:(NSString *)userId
{
    EmbeddingViewController <AEmbeddable> *embeddingViewController = [EmbeddingViewController new];

    NSString *userProfileRoute = [NSString stringWithFormat:@"user-profile/%@", userId];
    
    [[[[ARoute sharedRouter] route:userProfileRoute] embedIn:^__kindof UIViewController<AEmbeddable> *{
        return embeddingViewController;
    }] execute];
}
```

### <a name="custom-initiation"></a> Custom initiation

Custom initiation is a cool feature and pretty easy to accomplish:

```
- (void)openUserProfileViewControllerWithUserId:(NSString *)userId
{
    NSString *title = @"User profile";
        
    [[[[ARoute sharedRouter] route:route] initSelector:^SEL{
        return @selector(initWithTitle:);
    } objects:^NSArray *{
        return @[title];
    }] execute];
}
```

### <a name="catching-completion-failure"></a> Catching `completion` & `failure`

When destination view controller is presented, completion block will be executed.

- Catching completion

	```
	- (void)openUserProfileViewControllerWithUserId:(NSString *)userId
	{
	    NSString *userProfileRoute = [NSString stringWithFormat:@"user-profile/%@", userId];
	    
	    [[[[ARoute sharedRouter] route:userProfileRoute] completion:^(ARouteResponse *routeResonse) {
	        NSLog(@"View controller is presented!");
	    }] execute];
	}
	```
- Catching failure

	```
	Work in progress!
	```

--

<br><br>
## <a name="acl"></a> 👮 ACL (route protector)
You can protect your route.

You can globally protect your route upon registration:

```
[[[[ARoute sharedRouter] registerRoutes:routes] protect:^BOOL(ARouteResponse *routeResponse) {
 	// return YES if you don't want to handle the route       

	return YES;
}] execute];
```

... or you can  provide protection callback on route execution:

```  
[[[[ARoute sharedRouter] route:route] protect:^BOOL(ARouteResponse *routeResponse) {
   // return YES if you don't want to handle the route       
    
	return YES;
}] execute];
```

**BE AWARE!**<br>
**Protection callback on execution will override the callback called upon registration**

--

<br><br>
## <a name="ARouteResponse"></a> `ARouteResponse`

`ARouteResponse` object wraps various data you pass through route registrations and route executions.


--

<br><br>
## <a name="routes-separation"></a> ✂️ Routes separation

You are now already familiar with `[ARoute sharedRouter]`. This is `ARoute` global instance and in most cases it will be enough.

***But, sometimes you need to separate things!*** 😎

For example, your app has an admin and frontend parts. Ideally, you would separate routers:

```
[[[ARoute createRouterWithName:@"front"] registerRoutes:frontRoutes] execute];
```

or

```
[[[ARoute createRouterWithName:@"admin"] registerRoutes:adminRoutes] execute];

```

... then you would call a route:

```
[[[ARoute routerNamed:@"admin"] route:@"user-profile/12345"] execute];
```

or

```
[[[ARoute routerNamed:@"front"] route:@"user-profile/12345"] execute];
```

***Note:***
These routes maybe look the same, but they are in different namespaces so separation is satisfied.

--

<br><br>
## <a name="author"></a> Author

Aron Balog

## <a name="license"></a> License

ARoute is available under the MIT license. See the LICENSE file for more info.