//
//  Wines.m
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import "Wine.h"

@implementation Wine

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.itemId = [aDecoder decodeObjectForKey:@"wineId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.year = [aDecoder decodeObjectForKey:@"year"];
        self.grapes = [aDecoder decodeObjectForKey:@"grapes"];
        self.region = [aDecoder decodeObjectForKey:@"region"];
        self.wineDescription = [aDecoder decodeObjectForKey:@"wineDescription"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemId forKey:@"wineId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.year forKey:@"year"];
    [aCoder encodeObject:self.grapes forKey:@"grapes"];
    [aCoder encodeObject:self.region forKey:@"region"];
    [aCoder encodeObject:self.wineDescription forKey:@"wineDescription"];
}

- (void)fillWithJSONElement:(id)element
{
    [super fillWithJSONElement:element];
    
    self.itemId = [self getStringFromKey:element key:@"id"];
    self.name = [self getStringFromKey:element key:@"name"];
    self.year = [self getStringFromKey:element key:@"year"];
    self.grapes = [self getStringFromKey:element key:@"grapes"];
    self.region = [self getStringFromKey:element key:@"region"];
    self.wineDescription = [self getStringFromKey:element key:@"description"];
}

- (NSDictionary *)jsonDictionary
{
    return @{@"id": [self validateObject:self.itemId],
             @"name": [self validateObject:self.name],
             @"year": [self validateObject:self.year],
             @"grapes": [self validateObject:self.grapes],
             @"region": [self validateObject:self.region],
             @"description": [self validateObject:self.wineDescription]};
}

- (NSString *)json
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self jsonDictionary] options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
