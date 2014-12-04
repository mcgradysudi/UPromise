//
//  PROLogInViewController.h
//  promise
//
//  Created by su di on 14-7-21.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PROAppDelegate.h"

@interface PROLogInViewController : UIViewController<WeiboSDKDelegate>

@property (strong, nonatomic) IBOutlet UILabel *erroMessage;

@property (strong,nonatomic) PROAppDelegate *appDelegate;

@end
