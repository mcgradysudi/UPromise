//
//  PROActiveViewController.h
//  promise
//
//  Created by su di on 14-7-20.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PROAppDelegate.h"

@interface PROActiveViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic)NSInteger selectNum;
@end
