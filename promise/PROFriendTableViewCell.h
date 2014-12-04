//
//  PROFriendTableViewCell.h
//  promise
//
//  Created by su di on 14-8-21.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendList.h"
@interface PROFriendTableViewCell : UITableViewCell
@property(nonatomic,weak) FriendList *viewFriend;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *explainInfoLabel;
@property(nonatomic,assign)BOOL isCheckView;
@end
