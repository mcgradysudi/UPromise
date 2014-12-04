//
//  PROFriendListTableViewCell.h
//  promise
//
//  Created by su di on 14-8-12.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Promise.h"
#import "MCTopAligningLabel.h"

@interface PROFriendListTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet MCTopAligningLabel *promiseContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *promiseUsername;
@property (strong, nonatomic) IBOutlet UIImageView *promiseUserImage;
@property (strong, nonatomic) IBOutlet UIButton *promiseMoreButton;
@property (strong, nonatomic) IBOutlet UILabel *promisePostDateLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *imageCollection;
@property  (weak,nonatomic)UIViewController *parentController;
@property (weak,nonatomic) Promise *friendPromise;
@end
