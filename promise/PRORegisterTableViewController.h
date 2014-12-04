//
//  PRORegisterTableViewController.h
//  promise
//
//  Created by su di on 14-7-21.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#import "PROAppDelegate.h"


@interface PRORegisterTableViewController : UITableViewController
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (strong,nonatomic) PROAppDelegate *appDelegate;
@end
