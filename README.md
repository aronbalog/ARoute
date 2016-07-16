# ARoute

[![Build Status](https://travis-ci.org/aronbalog/ARoute.svg?branch=master)](https://travis-ci.org/aronbalog/ARoute)
[![Version](https://img.shields.io/cocoapods/v/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)
[![License](https://img.shields.io/cocoapods/l/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)
[![Platform](https://img.shields.io/cocoapods/p/ARoute.svg?style=flat)](http://cocoapods.org/pods/ARoute)

## Table of contents

1. [Demo](#demo)
1. [Requirements](#requirements)
1. [Installation](#installation)
1. [Usage](#usage)
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

## Swift

Full route configuration example:

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

### [Swift docs](SWIFT.md)

## Objective-C

### [Objective-C docs](OBJECTIVE-C.md)

<br><br>
## <a name="author"></a> Author

Aron Balog

## <a name="license"></a> License

ARoute is available under the MIT license. See the LICENSE file for more info.
