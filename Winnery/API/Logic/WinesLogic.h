//
//  WinesLogic.h
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Wine.h"

@interface WinesLogic : NSObject

- (void)getAllWines:(void (^)(NSArray *winesArray))success failure:(void (^)(NSError *error))failure;
- (void)getWineById:(NSString *)wineId success:(void (^)(Wine *wine))success failure:(void (^)(NSError *error))failure;
- (void)addWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)updateWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)deleteWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure;

// Sockets
- (void)socketAddWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)socketWineSelected:(Wine *)wine success:(void (^)(NSString *message))success failure:(void (^)(NSError *error))failure;

@end
