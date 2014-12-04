//
//  PRODatePickerView.m
//  promise
//
//  Created by su di on 14-7-25.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PRODatePickerView.h"
#import "RBCustomDatePickerView.h"

@implementation PRODatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
  
    }
    return self;
}
+ (id)view {
    static UINib *nib;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    });
    
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    for (id object in nibObjects) {
        if ([object isKindOfClass:[self class]]) {
            return object;
        }
    }
    
    return nil;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    RBCustomDatePickerView *pickerView = [[RBCustomDatePickerView alloc]initWithFrame:CGRectMake(0,0, 320, 520)];
    pickerView.delegate = self;
    
    [self.pickerView addSubview:pickerView];
    
    
}
- (IBAction)okButtonClick:(id)sender {
    
    if([self superview])
    {
        [self removeFromSuperview];
    }
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
        
        
    CGContextMoveToPoint(context, 0.0 , 31.0);
    CGContextAddLineToPoint(context, rect.size.width, 31.0);
    CGContextStrokePath(context);
   
 
    CGContextStrokePath(context);
}

-(void)selectDate:(NSDate *)clickDate
{
    if(self.delegate)
       [self.delegate selectRow:clickDate];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
