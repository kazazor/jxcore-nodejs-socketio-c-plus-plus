//
//  WinesLogic.h
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 Action-Item. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Wine.h"

@interface WinesLogic : NSObject

/**
 * Gets all the item with a Get Http Request, {baseURLString}/wines, baseURLString from the Logic Manager.
 *
 * @param success   A success callback method to be called upon the request success.
 * @param failure   A failure callback method to be called upon the request failure.
 */
- (void)getAllWines:(void (^)(NSArray *winesArray))success failure:(void (^)(NSError *error))failure;

/**
 * Adds an item with a Post Http Request, {baseURLString}/wines, baseURLString from the Logic Manager.
 *
 * @param wine      A Wine object to add.
 * @param success   A success callback method to be called upon the request success.
 * @param failure   A failure callback method to be called upon the request failure.
 */
- (void)addWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * Server not implemented yet!
 */
- (void)deleteWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * Adds an item with a Socket IO call.
 * When the networkReachabilityStatus is NotReachable or Unknown, JXCore is used, else, SocketIOClient is used.
 *
 * @param wine      A Wine object to add.
 * @param success   A success callback method to be called upon a success.
 * @param failure   A failure callback method to be called upon a failure.
 */
- (void)socketAddWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * Gets a message for a selected item with a Socket IO call using add-ons.
 * When the networkReachabilityStatus is NotReachable or Unknown, JXCore is used, else, SocketIOClient is used.
 *
 * @param wine      A Wine object to add.
 * @param success   A success callback method to be called upon a success.
 * @param failure   A failure callback method to be called upon a failure.
 */
- (void)socketWineSelected:(Wine *)wine success:(void (^)(NSString *message))success failure:(void (^)(NSError *error))failure;

@end
