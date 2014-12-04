//
//  PROCommentViewController.h
//  promise
//
//  Created by su di on 14-8-22.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Promise.h"
#import "PROAppDelegate.h"
#import "Comment.h"
@interface PROCommentViewController : UIViewController<UITextViewDelegate>
@property(weak,nonatomic) Promise *viewPromise;
@property (strong, nonatomic) IBOutlet UITextView *commentInputView;
@property(weak,nonatomic) PROAppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UILabel *replyUsername;

@property(weak,nonatomic) NSNumber *commentid;

@property(weak,nonatomic) NSNumber *replyid;
@property(weak,nonatomic) Comment *commentDetail;
@end
