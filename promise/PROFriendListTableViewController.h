//
//  PROFriendListTableViewController.h
//  promise
//
//  Created by su di on 14-8-20.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PROAppDelegate.h"
@interface PROFriendListTableViewController : UITableViewController<NSFetchedResultsControllerDelegate,UISearchBarDelegate>

@property (strong,nonatomic)NSFetchedResultsController *resultFetch;
@property(nonatomic,assign)BOOL isCheckView;
@property (weak,nonatomic)PROAppDelegate   *appdelgate;
@property (weak,nonatomic)NSMutableArray *selectFriends;
@end
