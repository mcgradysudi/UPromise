//
//  PROUserPromiseListTableViewCell.h
//  promise
//
//  Created by su di on 14-7-27.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Promise.h"
@interface PROUserPromiseListTableViewCell : UITableViewCell
@property (weak, nonatomic)  Promise *viewPromise;
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
@end
