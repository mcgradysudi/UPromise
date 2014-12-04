//
//  PROUserInfoTableViewController.h
//  promise
//
//  Created by su di on 14-8-16.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PROAppDelegate.h"
@interface PROUserInfoTableViewController : UITableViewController<NSFetchedResultsControllerDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic)NSFetchedResultsController *resultFetch;
@property (weak,nonatomic)PROAppDelegate *appdelgate;
@end
