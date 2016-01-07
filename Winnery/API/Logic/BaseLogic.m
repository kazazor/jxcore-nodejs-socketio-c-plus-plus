//
//  BaseLogic.m
//  Winery
//
//  Created by Nilit Rokah on 11/11/15.
//  Copyright © 2015 Action-Item. All rights reserved.
//

#import "BaseLogic.h"

#import "SelfParsingElement.h"

@implementation BaseLogic

- (NSArray *)serializeJSONRoot:(id)jsonRoot elementKey:(NSString *)elementKey classHandler:(Class)classHandler
{
    if (!jsonRoot)
    return nil;
    if ([jsonRoot isKindOfClass:[NSArray class]])
    {
        NSMutableArray *items = [NSMutableArray array];
        for (id element in jsonRoot)
        {
            if ([element isKindOfClass:[NSNull class]])
            continue;
            SelfParsingElement *newItem = [[classHandler alloc] init];
            [newItem fillWithJSONElement:element];
            
            [items addObject:newItem];
        }
        return items;
    }
    if ([jsonRoot isKindOfClass:[NSDictionary class]])
    {
        if (elementKey)
        return [self serializeJSONRoot:[jsonRoot objectForKey:elementKey] elementKey:nil classHandler:classHandler];
        else
        {
            NSMutableArray *items = [NSMutableArray array];
            SelfParsingElement *newItem = [[classHandler alloc] init];
            [newItem fillWithJSONElement:jsonRoot];
            
            [items addObject:newItem];
            return items;
        }
    }		
    
    return nil;
}

@end
