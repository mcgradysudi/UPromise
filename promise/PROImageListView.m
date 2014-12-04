//
//  PROImageListView.m
//  promise
//
//  Created by su di on 14-7-31.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROImageListView.h"

@implementation PROImageListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageList = [[NSMutableArray alloc]init];
        self.imageNumLimit = 3;
        [self layoutImageView];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.imageList = [[NSMutableArray alloc]init];
        self.imageNumLimit = 3;
       // [self layoutImageView];
    }
    return self;
}
-(void)layoutSubviews
{
//    self.imageList = [[NSMutableArray alloc]init];
//    self.imageNumLimit = 3;
//  [self layoutImageView];
   
}
-(void)awakeFromNib
{
    self.imageList = [[NSMutableArray alloc]init];
    self.imageNumLimit = 3;
    self.defaultImage = [UIImage imageNamed:@"AGIPC-Checkmark-iPhone.png"];
    
    [self addImagetoList:self.defaultImage];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    //
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
    
    [self layoutImageView];
}
-(void)layoutImageView
{
    CGFloat i = 0.0;
    for (UIImage*pp in self.imageList) {
        UIImageView *tempView = [[UIImageView alloc]initWithImage:pp];
        tempView.frame = CGRectMake(45.0*i, 0, 45, 45);
        tempView.userInteractionEnabled = true;
        [self addSubview:tempView];
        i++;
        
    }
    
}

-(BOOL)addImagetoList:(UIImage *)addimage
{
    if([self.imageList count] > [self imageNumLimit])
        return false;
    
    [self.imageList addObject:addimage];
   // [self layoutImageView];
    return true;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
   // NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIImageView"]) {
        return NO;
    }
    return  YES;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    

  //  NSLog(@"%@", NSStringFromClass([recognizer.view class]));

    
}


@end
