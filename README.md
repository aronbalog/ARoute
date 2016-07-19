# ARoute

[![Build Status](https://travis-ci.org/aronbalog/ARoute.svg?branch=master)](https://travis-ci.org/aronbalog/ARoute)
[![Version](https://img.shields.io/cocoapods/v/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)
[![License](https://img.shields.io/cocoapods/l/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)
[![Platform](https://img.shields.io/cocoapods/p/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)

## Table of contents

1. [Demo](#demo)
1. [Requirements](#requirements)
1. [Installation](#installation)
1.	[Swift](#swift)
	1. [Example](#swift-example)
	1. [Documentation](#swift-docs)
1.	[Objective-C](#objective-c)
	1. [Example](#objective-c-example)
	1. [Documentation](#objective-c-docs)

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

## <a name="swift"></a> Swift

### <a name="swift-example"></a> Swift example

Full route registration example:

```swift
ARoute.sharedRouter()
	.registerRoutes(["user/{userId=number}" : UserViewController.self as AnyObject])
	.separator({ () -> String in
	    return "{}"
	})
	.parameters({ () -> [NSObject : AnyObject]? in
	    return ["Key3":"Value3"]
	})
	.castingSeparator({ () -> String in
	    return "="
	})
	.execute()
```

Full route execution example:

```swift
ARoute.sharedRouter()
	.route("user/12345")
	.protect({ (routeResponse:ARouteResponse) -> Bool in
		 // return true if you don't want to handle the route
	    return false
	})
	.parameters({ () -> [NSObject : AnyObject]? in
	    return [
	        "Key1": "Value1",
	        "Key2": "Value2"
	    ]
	})
	.transitioningDelegate({ () -> UIViewControllerTransitioningDelegate? in
		 // return object conforming <UIViewControllerTransitioningDelegate>
	    return nil
	})
	.animated({ () -> Bool in
	    return true
	})
	.completion({ (routeResponse:ARouteResponse) in
	    
	})
	.execute()
```

### <a name="swift-docs"></a> [Swift documentation](SWIFT.md)

## <a name="objective-c"></a> Objective-C

### <a name="objective-c-example"></a> Objective-C example

Full route registration example:

```objective-c
NSDictionary *routes = @{
	@"user/{userId=number}": [UserViewController class]
};
    
[[[[[[ARoute sharedRouter]
    registerRoutes:routes] separator:^NSString *{
    return @"{}";
}] parameters:^NSDictionary*{
    return @{@"Key3":@"Value3"};
}] castingSeparator:^NSString*{
    return @"=";
}] execute];
```

Full route execution example:

```objective-c
[[[[[[[[ARoute sharedRouter] route:@"user/12345"] protect:^BOOL(ARouteResponse *routeResponse) {
    // return YES if you don't want to handle the route
    return NO;
}] parameters:^NSDictionary{
    return @{
             @"Key1": @"Value1",
             @"Key2": @"Value2"
             };
}] transitioningDelegate:^id<UIViewControllerTransitioningDelegate>{
    // return object conforming <UIViewControllerTransitioningDelegate>
    return nil;
}] animated:^BOOL{
    return YES;
}] completion:^(ARouteResponse *routeResponse) {
    
}] execute];

```

### <a name="objective-c-docs"></a> [Objective-C documentation](OBJECTIVE-C.md)

<br><br>
## <a name="author"></a> Author

Aron Balog

## <a name="license"></a> License

ARoute is available under the MIT license. See the LICENSE file for more info.
