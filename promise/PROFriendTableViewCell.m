//
//  PROFriendTableViewCell.m
//  promise
//
//  Created by su di on 14-8-21.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROFriendTableViewCell.h"
#import "SSCheckBoxView.h"
@interface PROFriendTableViewCell()
@property (strong,nonatomic)SSCheckBoxView *checkBoxView;
@end
@implementation PROFriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
  
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 23;
    CGColorRef cgColor = [UIColor colorWithRed:78.0/255.0 green:126.0/255.0 blue:158.0/255.0 alpha:0.8].CGColor;
    self.headImageView.layer.borderColor = cgColor;
    self.headImageView.layer.borderWidth = 1.8;
  //  if (!self.checkBoxView) {
        self.checkBoxView = [[SSCheckBoxView alloc]initWithFrame:CGRectMake(270, 0, 5, 35) style:kSSCheckBoxViewStyleMono checked:NO];
    self.isCheckView = false;
      //  [self.contentView addSubview:self.checkBoxView];
   // }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
   
    
   
    //if (self.viewFriend.isSelected) {
    
    if (self.isCheckView) {
         [self.contentView addSubview:self.checkBoxView];
          [self.checkBoxView setChecked:self.viewFriend.isSelected];
    }
  
   
   
    
   // [self.checkBoxView setText:@"同步到微博"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
  //  [self.checkBoxView setChecked:!self.checkBoxView.checked];
    
    // Configure the view for the selected state
}



@end
