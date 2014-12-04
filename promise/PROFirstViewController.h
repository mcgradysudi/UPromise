//
//  PROFirstViewController.h
//  promise
//
//  Created by su di on 14-7-18.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PROAppDelegate.h"
#import "FriendList.h"

@interface PROFirstViewController : UITableViewController<NSFetchedResultsControllerDelegate,UIGestureRecognizerDelegate>

@property (strong,nonatomic)NSFetchedResultsController *resultFetch;
@property (weak,nonatomic)PROAppDelegate *appdelgate;
@property (strong,nonatomic)FriendList *viewFriend;

@end
