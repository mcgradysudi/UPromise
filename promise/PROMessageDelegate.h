//
//  PROMessageDelegate.h
//  promise
//
//  Created by su di on 14-7-23.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@protocol PROMessageDelegate <NSObject>
-(void)initUserInfo:(NSDictionary *)userJson;
-(void)initPromiseInfo:(NSArray *)userJson andWatchId:(NSNumber *)watchId andState:(NSInteger)proState;
-(void)initFriendPromiseInfo:(NSArray *)userJson;
-(void)initFriendInfo:(NSArray *)userJson;
-(void)initRecommendUserInfo:(NSArray *)userJson;
-(void)updateUserInfo:(NSDictionary *)userJson;
-(void)updatePromiseInfo:(NSDictionary *)userJson andpromiseId:(NSNumber *)promiseid;
-(BOOL)initComment:(NSArray *)commentJson;
-(void)initTopicPromise:(NSArray *)commentJson andtopicNum:(NSNumber *)topicNum;
-(BOOL)initPromiseSize:(NSDictionary *)promiseSize andUserId:(NSNumber *)userId;

@end
