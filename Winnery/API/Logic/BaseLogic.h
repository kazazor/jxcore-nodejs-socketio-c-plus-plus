//
//  BaseLogic.h
//  Winery
//
//  Created by Nilit Rokah on 11/11/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseLogic : NSObject

- (NSArray *)serializeJSONRoot:(id)jsonRoot elementKey:(NSString *)elementKey classHandler:(Class)classHandler;

@end
