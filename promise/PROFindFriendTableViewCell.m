//
//  PROFindFriendTableViewCell.m
//  promise
//
//  Created by su di on 14-8-28.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROFindFriendTableViewCell.h"

@implementation PROFindFriendTableViewCell

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
 
//    self.titleImage.layer.masksToBounds = YES;
//    self.titleImage.layer.cornerRadius = 17;
//    CGColorRef cgColor = [UIColor colorWithRed:78.0/255.0 green:126.0/255.0 blue:158.0/255.0 alpha:0.8].CGColor;
//    self.titleImage.layer.borderColor = cgColor;
//    self.titleImage.layer.borderWidth = 1.8;
    
    
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
 
   // NSLog(@"reuse:%p,select:%d",self.addFriendButton,self.addFriendButton.isSelected);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
   // [self.addFriendButton setSelected:!self.addFriendButton.isSelected];
    // Configure the view for the selected state
}
- (IBAction)friendClick:(id)sender {
    
  //  [self.addFriendButton setSelected:!self.addFriendButton.isSelected];
    //NSLog(@"select：%p,state:%d",self.addFriendButton,self.addFriendButton.isSelected);
    
  //  NSLog(<#NSString *format, ...#>)
   // [self.addFriendButton setEnabled:NO];
}

@end
