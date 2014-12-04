//
//  PROMessageData.h
//  promise
//
//  Created by su di on 14-7-23.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "PROMessageDelegate.h"
#import "Promise.h"
@interface PROMessageData : NSObject

//公共参数
@property(strong,nonatomic) NSString* versionCode;
@property(strong,nonatomic) NSString* channel;
@property(strong,nonatomic) NSString* osVersion;
@property(strong,nonatomic) NSString* accessPoint;
@property(strong,nonatomic) NSString* imei;
@property(strong,nonatomic) NSString* screenResolution;
@property(strong,nonatomic) NSString* clientTimestamp;
@property(strong,nonatomic) NSString* macAddr;
@property(strong,nonatomic) NSString* paltform;


@property(strong,nonatomic) NSString* username;
@property(strong,nonatomic) NSString* password;


@property(strong,nonatomic) NSString* message;

-(BOOL)registerCount:(NSString *)userName andPassword:(NSString *)password;
-(BOOL)login:(NSString *)userName andPassword:(NSString *)password;
-(BOOL)postLogImg:(NSNumber *)userId andImageName:(NSString *)imageName;
-(BOOL)postUserInfo:(UserInfo *) postUser;
-(BOOL)postPromise:(Promise *)addpromise;
-(NSArray *)getUserPromise:(NSInteger) page andPageNum:(NSInteger) pageNum  andPromiseState:(NSInteger) proState;
-(BOOL)getFriendPromise:(NSInteger) page andPageNum:(NSInteger) pageNum;
-(NSArray *)getFriendPromiseFromId:(NSInteger) page andPageNum:(NSInteger) pageNum userID:(NSInteger)userId andPromiseState:(NSInteger)proState;

-(NSArray *)getRecommendUser:(NSInteger) page andPageNum:(NSInteger) pageNum;
-(BOOL)getFriendList:(NSInteger) page andPageNum:(NSInteger) pageNum;
-(BOOL)updateUserInfo:(NSString *)userName andPassword:(NSString *)password;
-(BOOL)postProveImg:(NSString *)imagePath andpromisId: (NSNumber *)promiseId;
-(BOOL)getPromiseDetail:(NSNumber *)promiseid anduserid:(NSNumber *)userid;
-(BOOL)updatePromiseState:(NSNumber *)promiseid andState:(NSNumber *)prostate;
-(BOOL)postComment:(NSString *)content andState:(NSNumber *)promiseid andPid:(NSNumber *)pid withUserid:(NSNumber *)userid andReplyUserid:(NSNumber *)replyUserid;
-(BOOL)postPraise:(NSNumber *)userid andPromiseid:(NSNumber *)promiseid andpraise:(NSNumber *)praise withCreateUser:(NSNumber *)createuserid;
-(NSArray *)getComment:(NSNumber *)promiseid;
-(NSArray *)getMessage:(NSNumber *)messageType anduserid:(NSNumber *)userId;
-(BOOL)addFriendRelation:(NSString *)friendId;
-(NSArray *)postWatch:(NSNumber *)promiseid;
-(NSArray *)getPromisebyTopic:(NSInteger) page andPageNum:(NSInteger) pageNum andTopicId:(NSNumber *)topicid;
-(BOOL)getPromiseSize:(NSNumber *)userId;
-(BOOL)loginFromThirdPart:(NSString *)userName andPassword:(NSString *)nickName;

//http请求
@property(strong,nonatomic) ASIFormDataRequest *request ;
@property (strong,nonatomic) id<PROMessageDelegate> appDelegate;
@end
