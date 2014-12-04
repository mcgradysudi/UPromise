//
//  PROUserPromiseListTableViewCell.m
//  promise
//
//  Created by su di on 14-7-27.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROUserPromiseListTableViewCell.h"
#import "PROTestView.h"
#import "ImageList.h"
#import "UIImageView+WebCache.h"
#import "MCTopAligningLabel.h"
//#import "UIImageView+OnlineImage.h"
@interface PROUserPromiseListTableViewCell ()
@property (strong, nonatomic)  UIView *detailView;
@property (strong, nonatomic)  UIView *detailPraiseView;
@property (strong, nonatomic)  PROTestView *  timeLineView;
@property (strong, nonatomic)  PROTestView *labelLineView;

@property (strong, nonatomic)  UIImageView *dateImageView2;
@property (strong, nonatomic)  UIImageView *dotImageView;

@property (strong, nonatomic)  UIImageView *imageListView1;
@property (strong, nonatomic)  UIImageView *imageListView2;
@property (strong, nonatomic)  UIImageView *imageListView3;

@property (strong,nonatomic)  MCTopAligningLabel *promiseContentLabel;
@property (strong,nonatomic) UILabel *promiseYear;
@property (strong,nonatomic) UILabel *promiseMonth;
@property (strong,nonatomic) UILabel *promiseDay;

@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UILabel *commentLabel;
@property (strong,nonatomic) UILabel *heartLabel;
@property (strong,nonatomic) UILabel *bombLabel;

@property (strong,nonatomic) UIImageView *titleImage;
@property (strong,nonatomic) NSCalendar * calendar;

@property (strong,nonatomic) NSMutableArray * imageArray;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;
@end



@implementation PROUserPromiseListTableViewCell

- (void)awakeFromNib
{
    // Initialization code

   

}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}
-(void)initLayuot
{

    
    
    self.detailView = [[UIView alloc]initWithFrame:CGRectMake(62, 6, 253, self.frame.size.height - 5)];
    CGRect pp = self.frame;
    
    self.detailView.layer.cornerRadius = 4;//设置视图圆角
    self.detailView.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    self.detailView.layer.borderColor = cgColor;
    self.detailView.layer.borderWidth = 0.8;
    
   
    self.promiseContentLabel  = [[MCTopAligningLabel alloc]initWithFrame:CGRectMake(12, 2, 155, 27)];
    
    // if([self.promiseContentLabel.text compare:self.viewPromise.pro_content] !=NSOrderedSame)
    
    self.promiseContentLabel.font = [UIFont systemFontOfSize:17];
    self.promiseContentLabel.textColor = [UIColor grayColor];
 
    self.promiseContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   // self.promiseContentLabel.backgroundColor = [UIColor redColor];
    
  //  self.promiseContentLabel.numberOfLines  = 2;
  //  self.promiseContentLabel.minimumScaleFactor = 0.3;
  //  self.promiseContentLabel.adjustsFontSizeToFitWidth = YES;
    
    //self.promiseContentLabel.lin
    
  
//    self.labelLineView= [[PROTestView alloc]initWithFrame:CGRectMake(0, 28, self.detailView.frame.size.width, 2)];
//    
//    self.labelLineView.backgroundColor = [UIColor whiteColor];
//    self.labelLineView.viewType = LABEL_LINE_TYPE ;
    
    [self.contentView addSubview:self.detailView];
    
    [self.detailView addSubview:self.promiseContentLabel];
//    [self.detailView insertSubview:self.labelLineView aboveSubview:self.promiseContentLabel];

    
    
    
    
    if(!self.dateImageView2)
    {
        self.dateImageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"promiselistback.png"]];
    }
    self.dateImageView2.frame  = CGRectMake(3, 6, 40, 44);
    
    [self.contentView addSubview:self.dateImageView2];
    
    //年份
    if(!self.promiseYear)
    {
        self.promiseYear  = [[UILabel alloc]initWithFrame:CGRectMake(6, 0, 30, 13)];
    }
    self.promiseYear.text  = @"2014";
    self.promiseYear.font = [UIFont boldSystemFontOfSize:13];
    self.promiseYear.textColor = [UIColor whiteColor];
    
    //月份
    if(!self.promiseMonth)
    {
        self.promiseMonth  = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 25, 12)];
    }
    self.promiseMonth.text  = @"Jun";
    self.promiseMonth.font = [UIFont boldSystemFontOfSize:10];
    self.promiseMonth.textColor = [UIColor blackColor];
    
    //日
    if(!self.promiseDay)
    {
        self.promiseDay  = [[UILabel alloc]initWithFrame:CGRectMake(10, 24, 36, 18)];
    }
    self.promiseDay.text  = @"17";
    self.promiseDay.font = [UIFont boldSystemFontOfSize:18];
    self.promiseDay.textColor = [UIColor blackColor];
    
    
    [self.dateImageView2 addSubview:self.promiseYear];
    [self.dateImageView2 addSubview:self.promiseMonth];
    [self.dateImageView2 addSubview:self.promiseDay];
    
    if(!self.dotImageView)
    {
        self.dotImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot.png"]];
    }
    self.dotImageView.frame  = CGRectMake(46, 12, 12, 12);
    self.dotImageView.backgroundColor = [UIColor whiteColor];
    
 
    self.timeLineView= [[PROTestView alloc]initWithFrame:CGRectMake(43, 18, 19, self.frame.size.height-23+15)];
    
    self.timeLineView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview: self.timeLineView];
    [self.contentView insertSubview:self.dotImageView aboveSubview: self.timeLineView];
     [self layoutDetailPraiseView];
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
      self.dateFormatter = [[NSDateFormatter alloc]init];

}
-(void)layoutSubviews

{
    /*
    self.detailView.layer.cornerRadius = 4;//设置视图圆角
    self.detailView.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    self.detailView.layer.borderColor = cgColor;
    self.detailView.layer.borderWidth = 0.8;
    
    self.promiseContentLabel.text  = self.viewPromise.pro_content;
    self.promiseContentLabel.font = [UIFont systemFontOfSize:17];
    self.promiseContentLabel.textColor = [UIColor grayColor];
    
   // if (self.frame.size.height <100) {
        self.detailView.frame = CGRectMake(68, 6, 242, self.frame.size.height-5);
   // }
    
    self.timeLineView.frame = CGRectMake(48, 25, 19, self.frame.size.height-23+15);
    self.labelLineView.viewType = LABEL_LINE_TYPE ;
    
    
    self.detailPraiseView.frame = CGRectMake(0, self.detailView.frame.origin.y+self.detailView.frame.size.height-30, 253, 30);
    */
    
    //NSLog(@"display:%@,detailView:%@",self.viewPromise.pro_content,self.promiseContentLabel.text);
   
  
     self.promiseContentLabel.text  = self.viewPromise.pro_content;
    self.detailView.frame = CGRectMake(62, 6, 253, self.frame.size.height - 5);

   

    self.commentLabel.text = self.viewPromise.comment.description;
    self.bombLabel.text = self.viewPromise.egg.description;
    self.heartLabel.text = self.viewPromise.praise.description;
    
   // self.promiseContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
   // [self.promiseContentLabel verticalUpAlignmentWithText:self.viewPromise.pro_content maxHeight:47];
   // self.promiseContentLabel.numberOfLines = 2;
    //[self.promiseContentLabel sizeToFit];
    
    
    //[self.contentView addSubview:self.dotImageView];

    self.timeLineView.frame = CGRectMake(43, 18, 19, self.frame.size.height-23+15);
  
    
    self.detailPraiseView.frame =CGRectMake(0, self.detailView.frame.origin.y+self.detailView.frame.size.height-30, 253, 30);

    if(self.frame.size.height >100)
    {
        CGFloat height = self.promiseContentLabel.frame.size.height+8;
      //  NSLog(@"%@,height:%f",self.promiseContentLabel.text,height);
        
       if(!self.imageListView1)
           self.imageListView1 =[[UIImageView alloc]initWithFrame:CGRectMake(12, height, 68, 72)];
        else
            self.imageListView1.frame = CGRectMake(12, height,68, 72);
        
       if(!self.imageListView2)
           self.imageListView2 = [[UIImageView alloc]initWithFrame: CGRectMake(85, height, 68, 72)];
       else
           self.imageListView2.frame = CGRectMake(85, height,68, 72);
        if(!self.imageListView3)
            self.imageListView3 = [[UIImageView alloc]initWithFrame: CGRectMake(158, height, 68, 72)];
        else
            self.imageListView3.frame = CGRectMake(158, height,68, 72);
        
        
    
        
        if(self.viewPromise.promiseid.integerValue ==99999)
           [self initImageFromLocal];
            else
            [self initImageFromUrl];
//        for (ImageList *img in self.viewPromise.imagelist.allObjects) {
//            self.imageListView1.image = [[UIImage alloc] initWithContentsOfFile:img.imagepath];
//            self.imageListView1.contentMode = UIViewContentModeScaleAspectFit;
//        }
        
      
       
       
        // self.imageListView2.frame  = CGRectMake(82, 57, 68, 72);
    }
    else
    {
        [self.imageListView1 removeFromSuperview];
        [self.imageListView2 removeFromSuperview];
        [self.imageListView3 removeFromSuperview];
        
    }
    
    switch (self.viewPromise.pro_status.intValue) {
        case 0:
        {
             self.titleImage.image = [UIImage imageNamed:@"goingon.png"];
            NSUInteger interflag = NSDayCalendarUnit;
            NSDateComponents *components = [self.calendar components:interflag fromDate:[NSDate date] toDate:self.viewPromise.due_date options:0];
            int days = [components day] + 1;
            
            self.titleLabel.text  = [NSString stringWithFormat:@"还有%d天！",days];
        }
            break;
        case 1:
            self.titleImage.image = [UIImage imageNamed:@"over.png"];
            self.titleLabel.text  = @"已完成";
            break;
        case 2:
            self.titleImage.image = [UIImage imageNamed:@"fail.png"];

            self.titleLabel.text  = @"已失败";
            break;
        default:
            break;
    }
    
    [self.dateFormatter setDateFormat:@"yyyy"];
    self.promiseYear.text = [self.dateFormatter stringFromDate:self.viewPromise.create_date];
    [self.dateFormatter setDateFormat:@"MMM"];
    self.promiseMonth.text = [self.dateFormatter stringFromDate:self.viewPromise.create_date];
    [self.dateFormatter setDateFormat:@"dd"];
    self.promiseDay.text = [self.dateFormatter stringFromDate:self.viewPromise.create_date];
    
}

-(void)initImageFromUrl
{
    
    NSInteger imageCount = [self.viewPromise.imageUrl count];
   // NSLog(@"dispaly id=%@,urlcount=%ld",self.viewPromise.promiseid,(long)imageCount);

    if (imageCount>0) {
        NSString *fullUrl = self.viewPromise.imageUrl[0];
        
        // [self.imageListView1 setOnlineImage:fullUrl];
        [self.imageListView1 sd_setImageWithURL:[NSURL URLWithString:fullUrl] placeholderImage:[UIImage imageNamed:@"placehold.png"]];
        
        //  self.imageListView1.image = self.imageArray[0];
        [self.detailView addSubview:self.imageListView1];
    }
    else [self.imageListView1 removeFromSuperview];
    
    if (imageCount >1) {
        [self.imageListView2 sd_setImageWithURL:[NSURL URLWithString:self.viewPromise.imageUrl[1]] placeholderImage:[UIImage imageNamed:@"placehold.png"]];
        
        [self.detailView addSubview:self.imageListView2];
    }
    else [self.imageListView2 removeFromSuperview];
    
    if (imageCount >2) {
        [self.imageListView3 sd_setImageWithURL:[NSURL URLWithString:self.viewPromise.imageUrl[2]] placeholderImage:[UIImage imageNamed:@"placehold.png"]];
        
        [self.detailView addSubview:self.imageListView3];
    }
    else [self.imageListView3 removeFromSuperview];
//    self.imageListView1.contentMode = UIViewContentModeScaleAspectFit;
 //   self.imageListView2.contentMode = UIViewContentModeScaleAspectFit;
  //  self.imageListView3.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)initImageFromLocal
{
    
    NSArray *imageList = self.viewPromise.imagelist.allObjects;
    
    self.imageArray = [[NSMutableArray alloc]init];
    
    for (ImageList *img in imageList) {
        UIImage *localimage = [[UIImage alloc] initWithContentsOfFile:img.imagepath];
        [self.imageArray addObject:[[UIImage alloc] initWithContentsOfFile:img.imagepath]];
    }
    
    NSInteger imageCount = [self.imageArray count];
    
    if (imageCount>0) {
       // NSString *fullUrl = self.v[0];
        
        // [self.imageListView1 setOnlineImage:fullUrl];
       // [self.imageListView1 sd_setImageWithURL:[NSURL URLWithString:fullUrl] placeholderImage:[UIImage imageNamed:@"placehold.png"]];
        self.imageListView1.image = self.imageArray[0];
        //  self.imageListView1.image = self.imageArray[0];
        [self.detailView addSubview:self.imageListView1];
    }
    else [self.imageListView1 removeFromSuperview];
    
    if (imageCount >1) {
        self.imageListView2.image = self.imageArray[1];

        
        [self.detailView addSubview:self.imageListView2];
    }
    else [self.imageListView2 removeFromSuperview];
    
    if (imageCount >2) {
        self.imageListView3.image = self.imageArray[2];
        
        [self.detailView addSubview:self.imageListView3];
    }
    else [self.imageListView3 removeFromSuperview];
   // self.imageListView1.contentMode = UIViewContentModeScaleAspectFit;
   // self.imageListView2.contentMode = UIViewContentModeScaleAspectFit;
    //self.imageListView3.contentMode = UIViewContentModeScaleAspectFit;

}
-(void)layoutDetailPraiseView
{
    
    //添加praiseView
    if(!self.detailPraiseView)
    self.detailPraiseView =[[UIView alloc]initWithFrame:CGRectMake(0, self.detailView.frame.origin.y+self.detailView.frame.size.height-30, 253, 30)];
    self.detailPraiseView.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    
    
    [self.detailView addSubview:self.detailPraiseView];
    
   
    self.titleImage =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goingon.png"]];
    self.titleImage.frame  = CGRectMake(165, 1, 26 , 26);
    self.titleImage.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel =  [[UILabel alloc]initWithFrame:CGRectMake(193, 6, 142, 13)];
    //titleLabel.text  = @"已完成";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    self.titleLabel.textColor = [UIColor redColor];
    
    [self.detailView addSubview:self.titleImage];
    [self.detailView addSubview:self.titleLabel];
    
    
    UIImageView *commentImage =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comment.png"]];
    commentImage.frame  = CGRectMake(145, 0, 24, 24);
    self.commentLabel =  [[UILabel alloc]initWithFrame:CGRectMake(170, 6, 40, 12)];
    self.commentLabel.text  = @"0";
    self.commentLabel.font = [UIFont systemFontOfSize:13];
    self.commentLabel.textColor = [UIColor grayColor];
    [self.detailPraiseView addSubview:self.commentLabel];
    
    [self.detailPraiseView addSubview:commentImage ];
    
    UIImageView *heartImage =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"heart.png"]];
    heartImage.frame  = CGRectMake(14, 0, 24, 24);
    
   self.heartLabel =  [[UILabel alloc]initWithFrame:CGRectMake(40, 6, 40, 12)];
    self.heartLabel.text  = @"0";
    self.heartLabel.font = [UIFont systemFontOfSize:13];
    self.heartLabel.textColor = [UIColor grayColor];
    [self.detailPraiseView addSubview:self.heartLabel];
    
    
    [self.detailPraiseView addSubview:heartImage ];
    
    UIImageView *bombImage =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bomb.png"]];
    bombImage.frame  = CGRectMake(78, 0, 22, 22);
    self.bombLabel =  [[UILabel alloc]initWithFrame:CGRectMake(102, 6, 40, 12)];
    self.bombLabel.text  = @"0";
    self.bombLabel.font = [UIFont systemFontOfSize:13];
    self.bombLabel.textColor = [UIColor grayColor];
    [self.detailPraiseView addSubview:self.bombLabel];
    
    [self.detailPraiseView addSubview:bombImage ];
    
   
    
    
}

-(void)layoutImageListView
{
    if(self.frame.size.height >100)
    {
        NSArray *imageList = self.viewPromise.imagelist.allObjects;
        
        //NSInteger i = 1;
       // for (ImageList *image in self.viewPromise.imagelist.allObjects) {
         if(!self.imageListView1 && imageList.count >0)
         { // self.imageListView1 = [[UIImageView alloc]initWithImage: [[UIImage alloc] initWithContentsOfFile:((ImageList *)imageList[0]).imagepath]];
                self.imageListView1 =[[UIImageView alloc]initWithFrame:CGRectMake(12, 57, 68, 72)];
             //[self.imageListView1 sizeToFit];
            self.imageListView1 .frame  = CGRectMake(12, 57, 68, 72);
            [self.detailView addSubview:self.imageListView1];
        

        }
        if(!self.imageListView2 && imageList.count >1)
        {
            self.imageListView2 = [[UIImageView alloc]initWithImage: [[UIImage alloc] initWithContentsOfFile:((ImageList *)imageList[1]).imagepath]];
            self.imageListView2.frame  = CGRectMake(82, 57, 68, 72);
           // [self.imageListView2 sizeToFit];
            
            [self.detailView addSubview:self.imageListView2];
        }
        if(!self.imageListView3 && imageList.count >2)
        {
         //  UIImage *tempimage = [[UIImage alloc] initWithContentsOfFile:((ImageList *)imageList[2]).imagepath];
//            
           //self.imageListView3 = [[UIImageView alloc]initWithImage: [PROUserPromiseListTableViewCell thumbnailWithImage:tempimage size:self.imageListView.size];
//            self.imageListView3.frame  = CGRectMake(152, 57, 68, 72);
//            [self.detailView addSubview:self.imageListView3];


        }
//       UIImageView *imageView2 =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test.png"]];
  
//    UIImageView *imageView3 =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test.png"]];
      }
    else
    {
        [self.imageListView1 removeFromSuperview];
        [self.imageListView2 removeFromSuperview];
        [self.imageListView3 removeFromSuperview];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setViewPromise:(Promise *)viewPromise
{
    _viewPromise = viewPromise;
    [self.viewPromise initImageUrl:self.viewPromise.imageString];
   // NSLog(@"initPromise %@",self.viewPromise.promiseid);
    
    [self.viewPromise initProveImageUrl];
    

    if (self.viewPromise.pro_status.integerValue == 0) {
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* now = [NSDate date];
                NSString *pp = [self.dateFormatter stringFromDate:now];
        NSDate *nowtest = [self.dateFormatter dateFromString:pp];
        
        if (nowtest != [nowtest earlierDate:self.viewPromise.due_date]) {
            //确定为失败
            self.viewPromise.pro_status = [NSNumber numberWithInt:2];
        }

    }
    
    
    // [self layoutImageListView];
}


+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        UIGraphicsBeginImageContext(asize);
        
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}


@end
