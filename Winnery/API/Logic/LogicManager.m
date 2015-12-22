//
//  LogicManager.m
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import "LogicManager.h"

WinesLogic *winesLogic()
{
    return [LogicManager sharedInstance].winesLogic;
}

@implementation LogicManager

static LogicManager *sharedInstance = nil;

+ (LogicManager *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }  
    }
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        _winesLogic = [[WinesLogic alloc] init];
    }
    return self;
}

- (void)setBaseURL:(NSURL *)url
{
    _baseURL = url;
}

@end
