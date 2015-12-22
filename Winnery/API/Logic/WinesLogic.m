//
//  WinesLogic.m
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import "WinesLogic.h"

#import "AFHTTPSessionManager.h"
#import "JXcore.h"
#import "Winnery-Swift.h"
#import "Wine.h"

@implementation WinesLogic

- (void)getAllWines:(void (^)(NSArray *winesArray))success failure:(void (^)(NSError *))failure
{
    [[AFHTTPSessionManager manager] GET:[NSString stringWithFormat:@"%@/wines", [[LogicManager sharedInstance] baseURL]]
                             parameters:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {                                    
                                    
                                    NSMutableArray *winesArray = [NSMutableArray array];
                                    for (id obj in responseObject)
                                    {
                                        Wine *wine = [[Wine alloc] init];
                                        [wine fillWithJSONElement:obj];
                                        [winesArray addObject:wine];
                                    }
                                    success(winesArray);
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    failure(error);
                                    NSLog(@"%@", error.description);
                                }];
}

- (void)getWineById:(NSString *)wineId success:(void (^)(Wine *wine))success failure:(void (^)(NSError *error))failure
{
    
}

- (void)addWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure
{
    [[AFHTTPSessionManager manager] POST:[NSString stringWithFormat:@"%@/wines", [[LogicManager sharedInstance] baseURL]]
                              parameters:nil
               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
    {
        NSDictionary *jsonDictionary = [wine jsonDictionary];
        BOOL isValidJson = [NSJSONSerialization isValidJSONObject:jsonDictionary];
        if (isValidJson)
        {
           NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                              options:NSJSONWritingPrettyPrinted error:nil];
           [formData appendPartWithHeaders:@{@"Content-Type": @"application/json"}
                                      body:jsonData];
        }
        else
        {
           NSLog(@"Can not be converted to JSON data");
        }
    }
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     success();
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     failure(error);
                                 }];
}

- (void)updateWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure
{
    
}

- (void)deleteWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure
{
    [[AFHTTPSessionManager manager] DELETE:[NSString stringWithFormat:@"%@/wines/%@", [[LogicManager sharedInstance] baseURL], wine.itemId]
                                parameters:nil
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                   }
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                       
                                       failure(error);
                                   }];
}

#pragma mark - Sockets

- (void)socketAddWine:(Wine *)wine success:(void (^)())success failure:(void (^)(NSError *error))failure
{
    NSLog(@"Socket adding wine: %@", [wine json]);
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable)
    {
        //*** Using JXCore for local server ***//
        
        // Set the block for the "OnWineAdded" JS event
        [JXcore addNativeBlock:^(NSArray *params, NSString *callbackId) {
            success();
        } withName:@"OnWineAdded"];
        
        // Call the JS event "AddWine"
        [JXcore callEventCallback:@"AddWine" withJSON:[wine json]];
    }
    else
    {
        //*** Using SocketIOClient ***//
        
        SocketIOClient *socketIOClient = [[SocketIOClient alloc] initWithSocketURL:[[[LogicManager sharedInstance] baseURL] absoluteString] options:@{@"log": @YES, @"forcePolling": @YES}];
        [socketIOClient connect];
        
        // Listen to the connected event
        [socketIOClient on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"socket connected");
            
            // Set the block for the "OnWineAdded" JS event
            [socketIOClient on:@"OnWineAdded" callback:^(NSArray* data, SocketAckEmitter* ack) {
                // Close the socket
                [socketIOClient disconnect];
                
                success();
            }];
            
            // Call the JS event "AddWine"
            [socketIOClient emit:@"AddWine" withItems:@[[wine jsonDictionary]]];
        }];
    }
}

- (void)socketWineSelected:(Wine *)wine success:(void (^)(NSString *message))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"Socket selected wine: %@", [wine json]);
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable)
    {
        //*** Using JXCore for local server ***//
        
        // Set the block for the "OnWineSelected" JS event
        [JXcore addNativeBlock:^(NSArray *params, NSString *callbackId) {
            success(params[0]);
        } withName:@"OnWineSelected"];
        
        // Call the JS event "WineSelected"
        [JXcore callEventCallback:@"WineSelected" withJSON:[wine json]];
    }
    else
    {
        //*** Using SocketIOClient ***//
        
        SocketIOClient *socketIOClient = [[SocketIOClient alloc] initWithSocketURL:[[[LogicManager sharedInstance] baseURL] absoluteString] options:@{@"log": @YES, @"forcePolling": @YES}];
        [socketIOClient connect];
        
        // Listen to the connected event
        [socketIOClient on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"socket connected");
            
            // Set the block for the "OnWineSelected" JS event
            [socketIOClient on:@"OnWineSelected" callback:^(NSArray* data, SocketAckEmitter* ack) {
                // Close the socket
                [socketIOClient disconnect];
                
                success(data[0]);
            }];
            
            // Call the JS event "WineSelected"
            [socketIOClient emit:@"WineSelected" withItems:@[[wine jsonDictionary]]];
        }];
    }
}

@end
