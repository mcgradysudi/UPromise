//
//  FriendList.h
//  promise
//
//  Created by su di on 14-8-20.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FriendList : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * openaccount;
@property (nonatomic, retain) NSString * headpicture;
@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSString * explaininfo;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSNumber * ownFriendid;
@property (nonatomic, retain) NSNumber * successsize;
@property (nonatomic, retain) NSNumber * totalsize;
@property (nonatomic, retain) NSNumber * watchsize;

@property (nonatomic,assign)  BOOL isSelected;
@end
