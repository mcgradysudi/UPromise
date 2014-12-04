//
//  PROUserHeaderView.h
//  promise
//
//  Created by su di on 14-8-16.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "FriendList.h"

@interface PROUserHeaderView : UIView
@property (weak,nonatomic) UserInfo *viewUser;
@property (weak,nonatomic) FriendList *viewFriend;
@property (strong, nonatomic) IBOutlet UILabel *completeLabel;
@property (strong, nonatomic) IBOutlet UILabel *watchLabel;

@property (strong, nonatomic) IBOutlet UILabel *allLabel;
+ (id)view ;
-(void)refresh;
-(void)clickTag:(NSInteger)tagInt;

-(void)refreshFromFriend;
@end
