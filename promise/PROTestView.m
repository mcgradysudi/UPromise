//
//  PROTestView.m
//  promise
//
//  Created by su di on 14-7-28.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROTestView.h"

@implementation PROTestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = TIME_LINE_TYPE;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor);
    if (self.viewType == TIME_LINE_TYPE)
    {
       
        
        CGContextMoveToPoint(context, 9.0 , 3.0);
        CGContextAddLineToPoint(context, 9.0, rect.size.height);
        CGContextStrokePath(context);
        CGContextSetLineWidth(context, 2.0);
        CGContextMoveToPoint(context, 0.0 , 0.0);
        CGContextAddLineToPoint(context, rect.size.width,0.0);
        
    }
   
    if(self.viewType == LABEL_LINE_TYPE)
    {
       // CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextMoveToPoint(context, 0.0 , 0.0);
        CGContextAddLineToPoint(context, rect.size.width, 0.0);
    }
    CGContextStrokePath(context);

    
}


@end
