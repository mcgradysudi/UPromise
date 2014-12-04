//
//  ImageList.h
//  promise
//
//  Created by su di on 14-8-5.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Promise;

@interface ImageList : NSManagedObject

@property (nonatomic, retain) NSString * imagepath;
@property (nonatomic, retain) Promise *promise;

@end
