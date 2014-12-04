//
//  PROFriendTableViewController.h
//  promise
//
//  Created by su di on 14-7-20.
//  Copyright (c) 2014年 su di. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PROAppDelegate.h"
@interface PROFriendTableViewController : UITableViewController<NSFetchedResultsControllerDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic)NSFetchedResultsController *resultFetch;
@property (strong,nonatomic)NSArray *friendCellHeightList;
@property (weak,nonatomic)PROAppDelegate   *appdelgate;
@property (strong,nonatomic) NSNumber *topicNum;
@end
