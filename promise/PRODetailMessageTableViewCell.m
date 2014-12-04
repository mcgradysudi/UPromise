//
//  PRODetailMessageTableViewCell.m
//  promise
//
//  Created by su di on 14-8-31.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PRODetailMessageTableViewCell.h"

@implementation PRODetailMessageTableViewCell

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
    self.headImageView.layer.cornerRadius = 20;
    CGColorRef cgColor = [UIColor colorWithRed:78.0/255.0 green:126.0/255.0 blue:158.0/255.0 alpha:0.8].CGColor;
     self.headImageView.layer.borderColor = cgColor;
     self.headImageView.layer.borderWidth = 1.8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
