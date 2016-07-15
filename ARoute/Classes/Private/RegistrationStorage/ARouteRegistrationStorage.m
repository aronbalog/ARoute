//
//  ARouteRegistrationStorage.m
//  ARoute
//
//  Created by Aron Balog on 12/07/16.
//  Copyright © 2016 Aron Balog. All rights reserved.
//

#import "ARouteRegistrationStorage.h"

typedef NS_ENUM(NSInteger, ARouteCastingType) {
    ARouteCastingTypeString = 0,
    ARouteCastingTypeNumber
};

@interface ARouteRegistrationStorage ()

@property (strong, nonatomic, nonnull) NSMutableArray <ARouteRegistrationItem *> *routeRegistrationItems;

@end

@implementation ARouteRegistrationStorage

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    
    return instance;
}

- (void)storeRouteRegistration:(ARouteRegistration *)routeRegistration
{
#pragma mark TODO check if similar route already exist and override it
    [self.routeRegistrationItems addObjectsFromArray:routeRegistration.items];
}

- (ARouteRegistrationStorageResult *)routeRegistrationResultForRoute:(NSString *)route router:(ARoute *)router
{
    NSDictionary *routeParameters;
    
    ARouteRegistrationItem *item = [self routeRegistrationItemForCalledRoute:route routerName:router.name routeName:nil routeParameters:&routeParameters];
    
    ARouteRegistrationStorageResult *result = [ARouteRegistrationStorageResult new];
    
    result.routeRegistrationItem = item;
    result.routeParameters = routeParameters.count ? routeParameters : nil;
    
    return result;
}

- (ARouteRegistrationStorageResult *)routeRegistrationResultForRouteName:(NSString *)routeName router:(ARoute *)router
{
    NSDictionary *routeParameters;
    
    ARouteRegistrationItem *item = [self routeRegistrationItemForCalledRoute:nil routerName:router.name routeName:routeName routeParameters:&routeParameters];
    
    ARouteRegistrationStorageResult *result = [ARouteRegistrationStorageResult new];
    
    result.routeRegistrationItem = item;
    result.routeParameters = routeParameters.count ? routeParameters : nil;

    return result;
}

#pragma mark - Private

- (nullable ARouteRegistrationItem *)routeRegistrationItemForCalledRoute:(NSString *)calledRoute routerName:(NSString *)routerName routeName:(NSString *)routeName routeParameters:(NSDictionary * __autoreleasing *)routeParameters
{
    __block ARouteRegistrationItem *routeRegistrationItem;
    __block NSDictionary *routeParametersGlobalObject;
    [self.routeRegistrationItems enumerateObjectsUsingBlock:^(ARouteRegistrationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (routeRegistrationItem) {
            return;
        }
        
        NSString *definedRoute = obj.route;
        
        NSDictionary *routeParametersObject;
        BOOL routersAreEqual = [obj.router.name isEqualToString:routerName];
        
        BOOL proceed = [self definedRoute:definedRoute isEqualToRoute:calledRoute placeholder:obj.separator routeParameters:&routeParametersObject] && routersAreEqual;
        
        if (proceed) {
            routeRegistrationItem = obj;
            if (routeParameters) {
                routeParametersGlobalObject = routeParametersObject;
            }
        }
        
        *stop = proceed;
    }];
    
    if (routeParameters) {
        *routeParameters = routeParametersGlobalObject;
    }
    
    return routeRegistrationItem;
}

- (BOOL)definedRoute:(NSString *)definedRoute isEqualToRoute:(NSString *)route placeholder:(NSString *)placeholder routeParameters:(NSDictionary **)routeParameters
{
    NSArray *placeholderComponents = [self placeholderComponentsForPlaceholder:placeholder];
    
    NSArray *routeParameterNames = [self paramNamesForDefinedRoute:definedRoute placeholderComponents:placeholderComponents];
    
    NSString *routeCandidateRegexPattern = [definedRoute copy];
    NSString *allCharactersRegexPattern = @"([^/]*)";
    
    BOOL matches = NO;
    
    if (routeParameterNames.count) {
        for (NSString *paramName in routeParameterNames) {
            NSString *wrappedParam = [NSString stringWithFormat:@"%@%@%@", placeholderComponents.firstObject, paramName, placeholderComponents.lastObject];
            routeCandidateRegexPattern = [routeCandidateRegexPattern stringByReplacingOccurrencesOfString:wrappedParam withString:allCharactersRegexPattern];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", routeCandidateRegexPattern];
        matches = [predicate evaluateWithObject:route];
    } else {
        matches = [route.lowercaseString isEqualToString:definedRoute.lowercaseString];
    }
    
    if (!matches) {
        return matches;
    }
    
    NSDictionary *routeParametersObject = [self extractRouteParametersForRoute:route definedRoute:definedRoute withRouteParameterNames:routeParameterNames placeholderComponents:placeholderComponents routeCandidateRegexPattern:routeCandidateRegexPattern];
    
    if (routeParameters) {
        *routeParameters = routeParametersObject;
    }
    
    // end extracting route parameters
    
    return matches;
}

- (NSDictionary *)extractRouteParametersForRoute:(NSString *)route definedRoute:(NSString *)definedRoute withRouteParameterNames:(NSArray <NSString *> *)routeParameterNames placeholderComponents:(NSArray *)placeholderComponents routeCandidateRegexPattern:(NSString *)routeCandidateRegexPattern
{
    // begin extracting route parameters
    NSMutableArray <NSString *> *wrappedParameters = [NSMutableArray new];
    
    for (NSString *paramName in routeParameterNames) {
        NSString *wrappedParam = [NSString stringWithFormat:@"%@%@%@", placeholderComponents.firstObject, paramName, placeholderComponents.lastObject];
        [wrappedParameters addObject:wrappedParam];
    }
    
    NSArray <NSString *> *routeParameterValues = [self routeParameterValuesWithPlaceholders:wrappedParameters route:route definedRoute:definedRoute routeCandidateRegexPattern:routeCandidateRegexPattern];
    
    if (routeParameterValues.count != routeParameterNames.count) {
        // something is wrong
        return nil;
    }
    
    return [NSDictionary dictionaryWithObjects:routeParameterValues forKeys:routeParameterNames];
}

- (NSArray *)paramNamesForDefinedRoute:(NSString *)definedRoute placeholderComponents:(NSArray *)placeholderComponents
{
    if (!placeholderComponents) {
        return @[];
    }
    
    // find all params in defined route
    NSString *regexPattern = [NSString stringWithFormat:@"\\%@[^/]*\\%@", placeholderComponents.firstObject, placeholderComponents.lastObject];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray <NSTextCheckingResult*> *results = [regex matchesInString:definedRoute options:kNilOptions range:NSMakeRange(0, definedRoute.length)];
    NSMutableArray <NSString*> *params = [NSMutableArray new];
    
    for (NSTextCheckingResult *result in results) {
        NSRange range = result.range;
        range.length = range.length - 2;
        range.location = range.location + 1;
        
        [params addObject:[definedRoute substringWithRange:range]];
    }
    
    return [NSArray arrayWithArray:params];
}

- (NSArray *)placeholderComponentsForPlaceholder:(NSString *)placeholder
{
    if (placeholder.length == 1) {
        placeholder = [placeholder stringByAppendingString:placeholder];
    }
    
    if (placeholder.length > 2) {
        return nil;
    }
    
    NSInteger middle = placeholder.length / 2;
    NSRange openingRange = NSMakeRange(0, placeholder.length / 2);
    NSRange closingRange = NSMakeRange(middle, middle);
    NSString *openingPlaceholderCharacter = [placeholder substringWithRange:openingRange];
    NSString *closingPlaceholderCharacter = [placeholder substringWithRange:closingRange];
    
    if (!openingPlaceholderCharacter) {
        openingPlaceholderCharacter = @"";;
    }
    
    if (!closingPlaceholderCharacter) {
        closingPlaceholderCharacter = @"";
    }
    
    return @[openingPlaceholderCharacter, closingPlaceholderCharacter];
}

- (NSArray <NSString *> *)routeParameterValuesWithPlaceholders:(NSArray <NSString *> *)placeholders route:(NSString *)route definedRoute:(NSString *)definedRoute routeCandidateRegexPattern:(NSString *)routeCandidateRegexPattern
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:routeCandidateRegexPattern options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSMutableArray *values = [NSMutableArray new];
    
    NSTextCheckingResult *result = [regex firstMatchInString:route options:0 range:NSMakeRange(0, route.length)];
    for (int i = 1; i < result.numberOfRanges; i++)
    {
        NSRange range = [result rangeAtIndex:i];
        NSString *value = [route substringWithRange:range];
        [values addObject:value];
    }
    
    return values;
}

#pragma mark - Properties

- (NSMutableArray<ARouteRegistrationItem *> *)routeRegistrationItems
{
    if (!_routeRegistrationItems) {
        _routeRegistrationItems = [NSMutableArray new];
    }
    
    return _routeRegistrationItems;
}

@end
