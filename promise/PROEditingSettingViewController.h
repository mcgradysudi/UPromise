//
//  PROEditingSettingViewController.h
//  promise
//
//  Created by su di on 14-8-17.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "PROMessageData.h"
#import "PROAppDelegate.h"
@interface PROEditingSettingViewController : UIViewController<MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameLabel;

@property (weak, nonatomic)  UserInfo *loginUser;
@property (weak,nonatomic)PROMessageData *myMessageData;
@property (weak,nonatomic)PROAppDelegate *appDelegate;
@property (assign,nonatomic)NSInteger editorType;

@end
