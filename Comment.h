//
//  Comment.h
//  promise
//
//  Created by su di on 14-8-27.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * co_content;
@property (nonatomic, retain) NSNumber * co_id;
@property (nonatomic, retain) NSDate * create_time;
@property (nonatomic, retain) NSString * headpicture;
@property (nonatomic, retain) NSNumber * promiseid;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSNumber * replyuserid;
@property (nonatomic, retain) NSString * replyname;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * co_pid;

@end
