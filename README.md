# ARoute

[![CI Status](http://img.shields.io/travis/Aron Balog/ARoute.svg?style=flat)](https://travis-ci.org/Aron Balog/ARoute)
[![Version](https://img.shields.io/cocoapods/v/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)
[![License](https://img.shields.io/cocoapods/l/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)
[![Platform](https://img.shields.io/cocoapods/p/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)

## Table of contents

1. [Example](#example)
1. [Requirements](#requirements)
1. [Installation](#installation)
1. [Simple usage](#simple-usage)
	1. [Route registration](#route-registration)
	1. [Route execution](#route-execution)
	1. [Animations](#animations)
1. [Advanced usage](#advanced-usage)
	1. 	[Callbacks](#callbacks)
	1. [Custom animations](#custom-animations)
	1. [Embedding](#embedding)
	1. [Custom initiation](#custom-initiation)
	1. [Catching completion & failure](#catching-completion-failure) 
	1. [ACL](#acl)
1. [`ARouteResponse`](#ARouteResponse)
1. [Author](#author)
1. [License](#license)

<br><br>

## <a name="example"></a> Example

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
## <a name="simple-usage"></a> Simple usage

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
## <a name="advanced-usage"></a> Advanced usage

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

    NSString *userProfileRoute = [NSString stringWithFormat:@"user-profile/%@", userId];
    
    SEL initSelector = @selector(myCustomInitMethod:);
    
    [[[[ARoute sharedRouter] route:userProfileRoute] initSelector:^SEL{
        return initSelector;
    } objects:^NSDictionary *{
        return @{@"firstArgument":title};
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

### <a name="acl"></a> ACL
```
Work in progress!
```

--

<br><br>
## <a name="ARouteResponse"></a> `ARouteResponse`

`ARouteResponse` object wraps various data you pass through route registrations and route executions.

--

<br><br>
## <a name="author"></a> Author

Aron Balog

## <a name="license"></a> License

ARoute is available under the MIT license. See the LICENSE file for more info.
