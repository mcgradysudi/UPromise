//
//  MCTopAligningLabel.m
//  MCTopAligningLabel
//
//  Created by Baglan on 11/29/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "MCTopAligningLabel.h"


#pragma mark VerticalAlign


// -- file: UILabel+VerticalAlign.m


@implementation MCTopAligningLabel

- (void)setText:(NSString *)text
{
   // CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(self.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGAffineTransform transform = self.transform;
    self.transform = CGAffineTransformIdentity;
    CGRect frame = self.frame;
    frame.size.height = size.height;
    self.frame = frame;
    self.transform = transform;
   // NSInteger line =size.height/self.font.lineHeight;
    self.numberOfLines = size.height/self.font.lineHeight;
    [super setText:text];
}

@end
