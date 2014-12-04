//
//  UserInfo.h
//  promise
//
//  Created by su di on 14-8-5.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Promise;

@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * explaininfo;
@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSString * headpicture;
@property (nonatomic, retain) NSNumber * isLogin;
@property (nonatomic, retain) NSDate * openaccount;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSOrderedSet *promise;
@property (nonatomic, retain) NSNumber * successsize;
@property (nonatomic, retain) NSNumber * totalsize;
@property (nonatomic, retain) NSNumber * watchsize;

@end

@interface UserInfo (CoreDataGeneratedAccessors)

- (void)insertObject:(Promise *)value inPromiseAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPromiseAtIndex:(NSUInteger)idx;
- (void)insertPromise:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePromiseAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPromiseAtIndex:(NSUInteger)idx withObject:(Promise *)value;
- (void)replacePromiseAtIndexes:(NSIndexSet *)indexes withPromise:(NSArray *)values;
- (void)addPromiseObject:(Promise *)value;
- (void)removePromiseObject:(Promise *)value;
- (void)addPromise:(NSOrderedSet *)values;
- (void)removePromise:(NSOrderedSet *)values;
@end
