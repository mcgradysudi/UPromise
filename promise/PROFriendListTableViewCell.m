//
//  PROFriendListTableViewCell.m
//  promise
//
//  Created by su di on 14-8-12.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROFriendListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PageViewControllerData.h"
#import "MyPageViewController.h"
#import "RootViewController.h"

@interface PROFriendListTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *moreView;


@end
@implementation PROFriendListTableViewCell

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
    self.promiseUserImage.layer.masksToBounds = YES;
    self.promiseUserImage.layer.cornerRadius = 25;
    CGColorRef cgColor = [UIColor colorWithRed:78.0/255.0 green:126.0/255.0 blue:158.0/255.0 alpha:0.8].CGColor;
    self.promiseUserImage.layer.borderColor = cgColor;
    self.promiseUserImage.layer.borderWidth = 1.8;
    

    
    
}


-(void)layoutSubviews
{
  

      //  NSLog(@"size=%f",self.contentView.frame.size.height);
    // self.promiseContentLabel.text = self.friendPromise.pro_content;
    [super layoutSubviews];
    
    CGRect frame  = self.promiseContentLabel.frame;
    
    if ([self.friendPromise.imageString isEqual:@""]) {
       // [self.imageCollection removeFromSuperview];
        self.imageCollection.hidden = YES;
    }
    else
    {
        //  if (![self.imageCollection superview]) {
        //self.imageCollection.frame = CGRectMake(182, 0, 225, 89);
       // [self.contentView addSubview:self.imageCollection];
       // [self.imageCollection reloadData];
       // NSLog(@"imageSize = %f",self.imageCollection.frame.size.height);
        
          self.imageCollection.hidden = NO;
        [self.imageCollection reloadData];
        CGFloat collectionHeight =  frame.origin.y +frame.size.height +4;
        self.imageCollection.frame= CGRectMake(self.imageCollection.frame.origin.x, collectionHeight, self.imageCollection.frame.size.width, self.imageCollection.frame.size.height);
        
        
            //}
        
        
    }
    
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGFloat dateOriginY =  self.frame.size.height -20;
    self.promisePostDateLabel.frame= CGRectMake(self.promisePostDateLabel.frame.origin.x, dateOriginY, self.promisePostDateLabel.frame.size.width, self.promisePostDateLabel.frame.size.height);
    
    CGFloat moreOriginY =  self.frame.size.height -25;
    
    self.moreView.frame = CGRectMake(self.moreView.frame.origin.x, moreOriginY, self.moreView.frame.size.width, self.moreView.frame.size.height);
    
   // NSLog(@"%@",NSStringFromCGRect(self.promiseContentLabel.frame));
    
    
   // [self sizeToFit];
 //   self.promiseMoreButton.frame = CGRectMake(275, self.frame.size.height- 28, 38, 21);
    
   // self.imageCollection.delegate = self;
   // self.imageCollection.dataSource = self;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
   // NSLog(@"leng = %d",[self.friendPromise.imageUrl count]);
    return [self.friendPromise.imageString compare:@""]==NSOrderedSame?0:[self.friendPromise.imageUrl count];
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    //   NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",[indexPath section], (long)[indexPath row]];
    UICollectionViewCell *cell =  [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.friendPromise.imageUrl[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placehold.png"]];
    
    
    // load the asset for this cell
    
    //
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <[self.friendPromise.imageUrl count])
    {
        [PageViewControllerData sharedInstance].isOrigin = (self.friendPromise.promiseid.integerValue == 99999?NO:YES);
        //  [PageViewControllerData sharedInstance].isf = YES;
        [PageViewControllerData sharedInstance].photoAssets =self.friendPromise.imageUrl;
        [PageViewControllerData sharedInstance].isUrlPath = (self.friendPromise.promiseid.integerValue == 99999?NO:YES);
        
        //[PageViewControllerData sharedInstance].selectAssets = self.selectassets;
        // start viewing the image at the appropriate cell index
        MyPageViewController *pageViewController =  [self.parentController.storyboard instantiateViewControllerWithIdentifier:@"MypageViewController"];
        //NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
        
        pageViewController.startingIndex = indexPath.row ;
        pageViewController.checkButton.hidden = YES;
        [self.parentController.navigationController pushViewController:pageViewController animated:YES];
    }
}

- (IBAction)detailButtonClick:(id)sender {
}

@end
