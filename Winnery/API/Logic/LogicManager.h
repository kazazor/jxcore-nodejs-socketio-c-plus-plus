//
//  LogicManager.h
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 Action-Item. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WinesLogic.h"

WinesLogic *winesLogic();

@interface LogicManager : NSObject

+ (LogicManager *)sharedInstance;

@property (nonatomic, strong) NSString *baseURLString;
@property (nonatomic, readonly) WinesLogic *winesLogic;

@end
