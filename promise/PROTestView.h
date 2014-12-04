//
//  PROTestView.h
//  promise
//
//  Created by su di on 14-7-28.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    TIME_LINE_TYPE,
    LABEL_LINE_TYPE,
    TIME_HEAD_TYPE
} TESTVIEW_TYPE;

@interface PROTestView : UIView

@property (assign,nonatomic) TESTVIEW_TYPE viewType;

@end
