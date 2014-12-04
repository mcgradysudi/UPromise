//
//  PRODetailMessageTableViewController.h
//  promise
//
//  Created by su di on 14-8-31.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PROAppDelegate.h"
@interface PRODetailMessageTableViewController : UITableViewController
@property (weak,nonatomic)PROAppDelegate  *appDelegate;
@property (strong,nonatomic)NSArray  *messageImageList;
@property (strong,nonatomic)NSNumber  *messageType;
@property (strong,nonatomic)NSNumber  *promiseId;
@end
