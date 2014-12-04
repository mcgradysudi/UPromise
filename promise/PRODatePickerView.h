//
//  PRODatePickerView.h
//  promise
//
//  Created by su di on 14-7-25.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBCustomDatePickerView.h"

@protocol PRODatePickerViewDelegate <NSObject>

-(void)selectRow:(NSDate *)selectDate;

-(void)closeView;

@end

@interface PRODatePickerView : UIView<RBCustomDatePickerDelegate>

@property (strong, nonatomic) IBOutlet UIView *pickerView;
+(id)view;
@property (weak, nonatomic) id<PRODatePickerViewDelegate>delegate;
@end
