//
//  Promise.h
//  promise
//
//  Created by su di on 14-8-5.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo;

@interface Promise : NSManagedObject

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSDate * due_date;
@property (nonatomic, retain) NSNumber * egg;
@property (nonatomic, retain) NSDate * end_date;
@property (nonatomic, retain) NSNumber * praise;
@property (nonatomic, retain) NSString * pro_content;
@property (nonatomic, retain) NSNumber * pro_status;
@property (nonatomic, retain) NSNumber * promiseid;
@property (nonatomic, retain) NSString * punish;
@property (nonatomic, retain) NSDate * start_date;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * visiable_scope;
@property (nonatomic, retain) UserInfo *user;
@property (nonatomic, retain) NSSet *imagelist;
@property (nonatomic, retain) NSNumber * comment;
@property (nonatomic, retain) NSNumber * hadpraise;
@property (nonatomic, retain) NSNumber * hadegg;
@property (nonatomic, retain) NSString * imageString;
@property (nonatomic, retain) NSString * proveimageString;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * headpicture;
@property (nonatomic, retain) NSString * watchman;
@property (nonatomic, retain) NSNumber * friend_id;
@property (nonatomic, retain) NSNumber * displayall;
@property (nonatomic, strong) NSMutableArray * imageUrl;
@property (nonatomic, strong) NSMutableArray * proveimageUrl;
@property (nonatomic, strong) NSNumber * topic;
@property (nonatomic, strong) NSNumber * watch_id;
@property (nonatomic, assign) BOOL textDisplayAll;
-(NSString *)returnJsonData;
-(void)initImageUrl:(NSString *)imageString;
-(void)initProveImageUrl;

@end

@interface Promise (CoreDataGeneratedAccessors)

- (void)addImagelistObject:(NSManagedObject *)value;
- (void)removeImagelistObject:(NSManagedObject *)value;
- (void)addImagelist:(NSSet *)values;
- (void)removeImagelist:(NSSet *)values;
-(CGFloat)calcFriendRowHeight;
-(CGFloat)calcPromiseRowHeight;
-(CGFloat)calcDetailRowHeight;
@end
