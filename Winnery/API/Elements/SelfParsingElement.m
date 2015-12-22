//
//  SelfParsingElement.m
//  Winery
//
//  Created by Nilit Rokah on 11/11/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import "SelfParsingElement.h"

@implementation SelfParsingElement

- (void)fillWithJSONElement:(id)element
{
}

- (NSString *)json
{
    return nil; // override this function where needed
}

- (NSDictionary *)jsonDictionary
{
    return nil;
}

- (NSObject *)getObjectFromKey:(id)element key:(NSString *)key defaultValue:(NSObject *)defaultValue
{
    NSObject* value = [element objectForKey:key];
    if (!value)
    {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNull class]])
    {
        return defaultValue;
    }
    return value;
}

- (NSObject *)getObjectFromKey:(id)element key:(NSString *)key
{
    if ([element isKindOfClass:[NSNull class]])
        return nil;
    return [self getObjectFromKey:element key:key defaultValue:nil];
}

- (NSString *)getStringFromKey:(id)element key:(NSString *)key
{
    if ([element isKindOfClass:[NSDictionary class]])
        return (NSString *)[self getObjectFromKey:element key:key defaultValue:nil];
    return nil;
}

- (NSObject *)validateObject:(NSObject *)val
{
    return val == nil ? @"null" : val;
}

@end
