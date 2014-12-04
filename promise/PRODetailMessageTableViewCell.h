//
//  PRODetailMessageTableViewCell.h
//  promise
//
//  Created by su di on 14-8-31.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRODetailMessageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *messageTypeImage;
@property (strong,nonatomic)NSNumber *promiseId;

@end
