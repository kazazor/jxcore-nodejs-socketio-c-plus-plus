//
//  LogicManager.h
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WinesLogic.h"

WinesLogic *winesLogic();

@interface LogicManager : NSObject

+ (LogicManager *)sharedInstance;

- (void)setBaseURL:(NSURL *)url;

@property (nonatomic, readonly) NSURL *baseURL;
@property (nonatomic, readonly) WinesLogic *winesLogic;

@end
