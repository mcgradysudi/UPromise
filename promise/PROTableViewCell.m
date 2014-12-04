//
//  PROTableViewCell.m
//  promise
//
//  Created by su di on 14-7-19.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROTableViewCell.h"

@implementation PROTableViewCell

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
    self.detailTime = [[UILabel alloc]initWithFrame:CGRectMake(160, 12, 145, 13)];
    self.detailTime.font = [UIFont systemFontOfSize:12];
    self.detailTime.textColor = [UIColor grayColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    self.detailTime.text = strDate;
    [self.contentView addSubview:self.detailTime];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
