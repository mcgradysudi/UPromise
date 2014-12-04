//
//  PRODetailTableViewController.m
//  promise
//
//  Created by su di on 14-7-30.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PRODetailTableViewController.h"
#import "UserInfo.h"
//#import "UIImageView+OnlineImage.h"
#import "PROImageListView.h"
#import "ImageList.h"
#import "PageViewControllerData.h"
#import "MyPageViewController.h"
#import "RootViewController.h"
#import "UIImageView+WebCache.h"
#import "PROCommentViewController.h"
#import "Comment.h"
#import "MCTopAligningLabel.h"


@interface UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
@end

@implementation UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
   // CGSize titleSize = [title sizeWithFont:12.0f];
   // [self.imageView setContentMode:UIViewContentModeCenter];
   [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                              -25.0,
                                              0.0,
                                              25.0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
   // [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    //[self.titleLabel setFont:12.0f];
    //[self.titleLabel setTextColor:[UIColor redColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                              -20.0,
                                              0.0,
                                              20.0)];
    [self setTitle:title forState:stateType];
}

@end


@interface PRODetailTableViewController ()
@property (strong, nonatomic) IBOutlet UIButton *praiseButton;
@property (strong, nonatomic) IBOutlet UIButton *failButton;
@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *punishLabel;
@property (strong, nonatomic) IBOutlet UILabel *punishBackLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;

@property (strong, nonatomic) IBOutlet MCTopAligningLabel *promiseLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) NSArray *proveImgList;
@property (strong, nonatomic) NSArray *promiseImg;
@property (strong,nonatomic) NSArray *watchmanList;
@property (strong, nonatomic) NSMutableArray *promiseImgList;
@property (strong, nonatomic) IBOutlet UIButton *hadPraiseButton;
@property (strong, nonatomic) IBOutlet UIButton *hadEggButton;


@property (strong, nonatomic) UIButton *promisePraiseButton;
@property (strong, nonatomic) UIButton *promiseBombButton;
@property (strong, nonatomic) UIButton *promiseCommentButton;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
//@property (strong, nonatomic) UIView *footerCommentView;
@property (strong, nonatomic) IBOutlet UIView *detailtoolView;
@property (strong, nonatomic) IBOutlet UICollectionView *watchCollectionView;
@property (strong, nonatomic) UIView *footerView;
@property (strong,nonatomic)NSMutableDictionary *commentDisplayView;
@property (strong,nonatomic)UIImageView *logImage;
@end

@implementation PRODetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.promiseLabel.text = self.viewPromise.pro_content;
    
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
   
    
    self.praiseButton.layer.masksToBounds = YES;
    
    self.praiseButton.layer.cornerRadius = 3;
    
    self.failButton.layer.masksToBounds = YES;
    
    self.failButton.layer.cornerRadius = 3;
    
    self.dateFormatter  = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
   
    
    self.appDelegate = (PROAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //self.imageView =[[PROImageListView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    
    //[self.imageView addImagetoList:[UIImage imageNamed:@"bomb.png"]];
    
   
    
    [self initUserInfo];
    
    self.dueDateLabel.text = [self.dateFormatter stringFromDate:self.viewPromise.due_date] ;
    self.punishLabel.text = self.viewPromise.punish;
    
    self.punishBackLabel.layer.masksToBounds = YES;
    self.punishBackLabel.layer.cornerRadius = 3;
    if (self.viewPromise.pro_status.intValue == 1) {
//        [self.praiseButton removeFromSuperview];
        [self.praiseButton setSelected:YES];
   }
    
    if (self.viewPromise.pro_status.intValue == 2) {
        //        [self.praiseButton removeFromSuperview];
        [self.failButton setSelected:YES];
    }
    if (self.viewPromise.promiseid.integerValue != 99999) {
         self.promiseImg = self.viewPromise.imageUrl;
    }
    else
    {  self.promiseImgList = [[NSMutableArray alloc]init];
        
        for (ImageList *imgtmp in self.viewPromise.imagelist) {
            [self.promiseImgList addObject:[[UIImage alloc] initWithContentsOfFile:imgtmp.imagepath]];
            
        }
   
    self.promiseImg = self.promiseImgList;
    }
    
   // self.watchmanList = [self.viewPromise.watchman componentsSeparatedByString:@";"];
    
    
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    [self.tableView addSubview:  self.appDelegate.HUD];
    
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在处理！";
    
//    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self
//                                                                              action:@selector(handleImgTap:)];
//    singleTap.delegate = self;
   // [self.imgListCollection addGestureRecognizer:singleTap];
    
    //[self.proveImgListCollection addGestureRecognizer:singleTap];
    
    
    
    self.proveImgList = self.viewPromise.proveimageUrl;//[[NSMutableArray alloc]initWithArray:self.viewPromise.proveimageUrl];
    
    
    self.imagePickerController = [[UIImagePickerController alloc]init];
    // self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    
    
    self.commentDisplayView = [[NSMutableDictionary alloc]init];
    
    
    [self moveDetailView];
    
   
    
}

-(void)initToolbar
{
    NSMutableArray *buttons=[[NSMutableArray  alloc]initWithCapacity:3];
    
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    

    
   // NSLog()
    //创建一个 UIBarButtonItem 系统刷新按钮  并且加入到Array中
    self.promisePraiseButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.promisePraiseButton.frame = CGRectMake(0, 0, 100, 30);
    [self.promisePraiseButton setImage:[UIImage imageNamed:@"praise_detail"] withTitle:[NSString stringWithFormat:@"赞(%@)",self.viewPromise.praise] forState:UIControlStateNormal];
    [self.promisePraiseButton setImage:[UIImage imageNamed:@"praise_orange"] withTitle:[NSString stringWithFormat:@"已赞(%@)",self.viewPromise.praise] forState:UIControlStateSelected];
    [self.promisePraiseButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
         [self.promisePraiseButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.promisePraiseButton setAdjustsImageWhenHighlighted:NO];
    [self.promisePraiseButton addTarget:self action:@selector(praiseComment:) forControlEvents:UIControlEventTouchUpInside];
   // self.promisePraiseButton.imageView.contentMode= UIViewContentModeScaleToFill;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView: self.promisePraiseButton];

    
    self.promiseBombButton= [UIButton buttonWithType:UIButtonTypeCustom];
     self.promiseBombButton.frame = CGRectMake(0, 0, 100, 35);
    [ self.promiseBombButton setImage:[UIImage imageNamed:@"bomb_detail"] withTitle:[NSString stringWithFormat:@"炸弹(%@)",self.viewPromise.egg] forState:UIControlStateNormal];
       [ self.promiseBombButton setImage:[UIImage imageNamed:@"bomb_orange"] withTitle:[NSString stringWithFormat:@"已炸(%@)",self.viewPromise.egg] forState:UIControlStateSelected];
    [ self.promiseBombButton setAdjustsImageWhenHighlighted:NO];
    [ self.promiseBombButton addTarget:self action:@selector(bombComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.promiseBombButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
     [self.promiseBombButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc]initWithCustomView: self.promiseBombButton];


    self.promiseCommentButton= [UIButton buttonWithType:UIButtonTypeCustom];
     self.promiseCommentButton.frame = CGRectMake(0, 0, 100, 35);
    [ self.promiseCommentButton setImage:[UIImage imageNamed:@"comment_detail"] withTitle:[NSString stringWithFormat:@"评论(%@)",self.viewPromise.comment] forState:UIControlStateNormal];
    [ self.promiseCommentButton setAdjustsImageWhenHighlighted:NO];
    [ self.promiseCommentButton addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [self.promiseCommentButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem3 = [[UIBarButtonItem alloc]initWithCustomView: self.promiseCommentButton];
    
    //buttonItem2 setTitle:;
    

    [buttons addObject:buttonItem];
    [buttons addObject:buttonItem2];
    [buttons addObject:buttonItem3];
    //最后，将array 设置给toolbar
    [ self.toolbar setItems:buttons animated:YES];

    
    
     //self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
   // [ self.toolbar setBackgroundColor:[UIColor darkGrayColor]];
    
     [self.view addSubview:self.toolbar];
    
   // [self. addSubview: self.toolbar];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        self.toolbar.center = CGPointMake(160, scrollView.contentOffset.y+self.view.bounds.size.height-20);
    }
    
    
    
}
-(void)initCommentList
{
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
   
    NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"promiseid==%@" ,self.viewPromise.promiseid];
    [fetchRequest setPredicate:selectPredict];
    
    
    NSError *error;

    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"create_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor1,nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // self.name = [context executeFetchRequest:fetchRequest error:&error];
    
    self.resultFetch =  [[NSFetchedResultsController alloc]
                         initWithFetchRequest:fetchRequest
                         managedObjectContext:context
                         sectionNameKeyPath:nil
                         cacheName:nil];
    [self.resultFetch performFetch:&error];
    //self.resultFetch.delegate = self;
    
        
    //[self initFootView];

    
}
-(void)initFootView
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];
    
    NSInteger count = [sectionInfo numberOfObjects];
    
   // NSInteger heigth =self.tableView.contentSize.height;
    
    if (!self.footerView ) {
       self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, count*44+10)];
    }
    else
        self.footerView.frame = CGRectMake(0, 0, 320, count*44+10);
    
    if (count>0) {
        
        NSInteger start = 0;
        
        for (NSInteger start =0; start<count; start++) {
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:start inSection:0];
            
            
            Comment *commentDetail = [self.resultFetch objectAtIndexPath:indexPath];
            
            if(![self.commentDisplayView objectForKey:commentDetail.co_id])
            {
              //  NSLog(@"initCommentView ");
                [self.footerView addSubview:[self getCommentListView:commentDetail andIndex:[self.commentDisplayView count]]];
                [self.commentDisplayView setObject:commentDetail.co_content forKey:commentDetail.co_id];
            }
            
        }
        
        
    }
    if(![self.footerView superview])
        [self.commentCell addSubview:self.footerView];
    

    //self.tableView.contentSize.height += count*44+10;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
 
//    NSArray *commentList =[self.appDelegate.myMessageData getComment:self.viewPromise.promiseid];
//    if(commentList && [commentList count]>0)
//    {
//        [self.appDelegate initComment:commentList];
//        [self initCommentList];
//        [self.tableView reloadData];
//    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        if ([self.appDelegate.myMessageData getPromiseDetail:self.viewPromise.promiseid anduserid:self.appDelegate.loginUser.userid]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self refreshUser];
            });
            NSArray *commentList =[self.appDelegate.myMessageData getComment:self.viewPromise.promiseid];
           if(commentList && [commentList count]>0)
           {
               dispatch_async(dispatch_get_main_queue(), ^{
                   //回调或者说是通知主线程刷新，
                 [self.appDelegate initComment:commentList];
                  
                  // [self initFootView];
                  // NSLog(@"initCommentList");

                   [self initCommentList];
                 //  [self initFootView];
//                   [self.tableView beginUpdates];
//                   [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
//                    [self.tableView endUpdates];
                   
                 
                   
               });


              // [self refreshComment];
              // [self initFootView];
            
           }
            self.watchmanList = [self.appDelegate.myMessageData postWatch:self.viewPromise.promiseid];
            
            if(self.watchmanList&&[self.watchmanList count]!=0)
            {
                // [self refreshComment];
                // [self initFootView];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
//                    [self.tableView beginUpdates];
//                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
//                     [self.tableView endUpdates];
                     [self.watchCollectionView reloadData];
                });

                
               
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
                [self setPromisePraiseandEggState ];
            });
            
        };
        //通知主线程刷新
       
        
    });
    
}
//-(void)refreshComment:(NSArray *)commentArray
//{
//    
//}
-(void)refreshUser
{
    if (self.viewPromise.promiseid.integerValue == 99999) {
        
        return  ;
    }
    
    self.userNameLabel.text = self.viewPromise.username;
    
    self.dueDateLabel.text = [self.dateFormatter stringFromDate:self.viewPromise.due_date] ;
    self.punishLabel.text = self.viewPromise.punish;
    self.startDateLabel.text =[self.dateFormatter stringFromDate:self.viewPromise.create_date] ;
    
     [self.logImage sd_setImageWithURL:[NSURL URLWithString:self.viewPromise.headpicture] placeholderImage:[UIImage imageNamed:@"head.png"]];
    
  //  self.punishBackLabel.layer.masksToBounds = YES;
   // self.punishBackLabel.layer.cornerRadius = 3;
    if (self.viewPromise.pro_status.intValue == 1) {
        //        [self.praiseButton removeFromSuperview];
        [self.praiseButton setSelected:YES];
    }
    
    if (self.viewPromise.pro_status.intValue == 2) {
             [self.failButton setSelected:YES];
    }
    self.promiseImg = self.viewPromise.imageUrl;
    [self.viewPromise initProveImageUrl];
    self.proveImgList = self.viewPromise.proveimageUrl;
    
    [self setPromisePraiseandEggState];
    
    [self.proveImgListCollection reloadData];

}
-(void)initUserInfo
{
   // UserInfo *myUser = self.viewPromise.user;
    if(self.viewPromise)
    {
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 23, 65, 20)];
      
        //temp.text =myUser.username;
        self.userNameLabel.text = self.viewPromise.username;
        self.userNameLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:20.0/255.0 alpha:0.8];
        self.userNameLabel.font = [UIFont systemFontOfSize:20];
        
        self.userNameLabel.numberOfLines = 1;
        self.userNameLabel.adjustsFontSizeToFitWidth = YES;
        [self.userNameLabel setMinimumScaleFactor:10];
         self.logImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 49, 50)];
        
        //[logImage setOnlineImage:myUser.headpicture];
        [self.logImage sd_setImageWithURL:[NSURL URLWithString:self.viewPromise.headpicture] placeholderImage:[UIImage imageNamed:@"head.png"]];
        
        self.logImage.layer.masksToBounds = YES;
        self.logImage.layer.cornerRadius = 25;
        CGColorRef cgColor = [UIColor colorWithRed:78.0/255.0 green:126.0/255.0 blue:158.0/255.0 alpha:0.8].CGColor;
        self.logImage.layer.borderColor = cgColor;
        self.logImage.layer.borderWidth = 1.8;
       
        
        UIImageView *dateImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date.png"]];
        dateImage.frame = CGRectMake(170, 17, 24, 24);
        
        
        self.startDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(202, 25, 160, 14)];
     
        self.startDateLabel.text =[self.dateFormatter stringFromDate:self.viewPromise.create_date] ;
        self.startDateLabel.font = [UIFont systemFontOfSize:14];
        
        [self.headerView addSubview:self.startDateLabel];

        [self.headerView addSubview:dateImage];
        [self.headerView addSubview:self.logImage];
        
        [self.headerView addSubview:self.userNameLabel];
        
        
    
       // [self setPromisePraiseandEggState];
        //根据显示不同的
       // if(self.)
    }
}

-(void)setPromisePraiseandEggState
{
    if (self.viewPromise.hadegg.integerValue) {
        //
        self.hadEggButton.titleLabel.text = @"已炸";
        [self.hadEggButton setSelected:YES];
        [self.promiseBombButton setSelected:YES];
        
          [ self.promiseBombButton setImage:[UIImage imageNamed:@"bomb_orange"] withTitle:[NSString stringWithFormat:@"已炸(%@)",self.viewPromise.egg] forState:UIControlStateSelected];
       // [self.hadEggButton setEnabled:NO];
    }
    
    if (self.viewPromise.hadpraise.integerValue) {
        //
      //  self.hadPraiseButton.titleLabel.text = @"已赞1";
        [self.hadPraiseButton setSelected:YES];
        
        [self.promisePraiseButton setImage:[UIImage imageNamed:@"praise_orange"] withTitle:[NSString stringWithFormat:@"已赞(%@)",self.viewPromise.praise] forState:UIControlStateSelected];
        
        [self.promisePraiseButton setSelected:YES];
        //self.promisePraiseButton setTitle:@"" forState:<#(UIControlState)#>
        //     [self.hadPraiseButton setEnabled:NO];
    }
    
    [self.promiseCommentButton setImage:[UIImage imageNamed:@"comment_detail"] withTitle:[NSString stringWithFormat:@"评论(%@)",self.viewPromise.comment] forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.toolbar removeFromSuperview];

}
-(void)viewWillAppear:(BOOL)animated
{
    [PageViewControllerData sharedInstance].photoAssets = nil;
    
    //[self initCommentList];
    //[self initCommentList];
    
    
//    [self.appDelegate.HUD showWhileExecuting:@selector(getComment:) onTarget:self withObject:[NSNumber numberWithInteger:1] animated:YES];
    
//    NSArray *commentList =[self.appDelegate.myMessageData getComment:self.viewPromise.promiseid];
//    if(commentList && [commentList count]>0)
//    {
//        [self.appDelegate initComment:commentList];
//        NSLog(@"initComment Appear");
//
        [self initCommentList];
//        NSLog(@"tableview reload");
        [self.tableView reloadData];
//    NSLog(@"tableview reload end");
//    }
   
   [self initToolbar];
    [self setPromisePraiseandEggState];
    
    UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sampleButton.frame = CGRectMake(160, 2, 50, 35);
    
    [sampleButton setBackgroundImage:[[UIImage imageNamed:@"share_open.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    
    [sampleButton setAdjustsImageWhenHighlighted:NO];
    [sampleButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:sampleButton];
    
    self.navigationItem.rightBarButtonItem = buttonItem;
    

    
}
-(void)moveDetailView
{
    CGRect frame = self.promiseLabel.frame;
    BOOL imageCollect = [self.viewPromise.imageUrl count]>0?YES:NO;
    self.imgListCollection.hidden = imageCollect?NO:YES;
        if (imageCollect) {
       
             CGRect imageCollectFrame = self.imgListCollection.frame;

        self.imgListCollection.frame = CGRectMake(imageCollectFrame.origin.x, frame.origin.y+frame.size.height +10, imageCollectFrame.size.width, imageCollectFrame.size.height);
        
    }
   CGRect oldFrame = self.detailtoolView.frame;
    
    CGRect newFrame = CGRectMake(oldFrame.origin.x, imageCollect? (self.imgListCollection.frame.origin.y+self.imgListCollection.frame.size.height+10):(frame.origin.y+frame.size.height +10), oldFrame.size.width, oldFrame.size.height);
    if ([self checkIsFriendPromiseView]) {
        self.praiseButton.userInteractionEnabled = NO;
        self.failButton.userInteractionEnabled = NO;
       // newFrame.size.height = newFrame.size.height - 35;
    }
    
    
    self.detailtoolView.frame = newFrame;
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1) {
//        [self moveDetailView];
//    }
    if (indexPath.section == 3) {
     //   NSLog(@"initFootView from cell");
        [self initFootView];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return [self.viewPromise calcDetailRowHeight];
            break;
        case 1:
            return [self checkIsFriendPromiseView]?([self.proveImgList count]?82.0:3.0):82.0;
            break;
        case 2:
            return [self.watchmanList count]?83.0:3.0;
            break;
        case 3:
        {
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];
            
            NSInteger count = [sectionInfo numberOfObjects];

           
            return count?count*44.0+5:3.0;
        }
            break;
        default:
            break;
    }
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ==0 ?65.0: 25.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   // id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];
    
   // NSInteger count = [sectionInfo numberOfObjects];

    return section ==3?35.0:4.0;
    //return section == 2?(count*44.0+5):4.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *hearderView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 190, 35)];
    if(section == 0)
    {
        //初始化头像
        return self.headerView;
    }
    
    
    if(section == 1)
    {
        
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic.png"]];
        img.frame = CGRectMake(10, 0, 20, 20);
        
        UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 62, 20)];
        temp.text = @"图证";
        
        [hearderView addSubview:img];
        [hearderView addSubview:temp];
        

    }
    
    if(section == 2)
    {
        
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"watchmen.png"]];
        img.frame = CGRectMake(10, 0, 20, 20);
        

        
        UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 262, 20)];
        temp.text = @"监督人";
        
//        if ([self.watchmanList count]==0) {
//            
//            temp.text = @"监督人(暂无)";
//
//        }
        [hearderView addSubview:img];
        [hearderView addSubview:temp];
        
       // return temp;
    }
    
    if(section == 3)
    {
        
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"watchmen.png"]];
        img.frame = CGRectMake(10, 0, 20, 20);
        
        
        
        UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 62, 20)];
        temp.text = @"评论";
        
        [hearderView addSubview:img];
        [hearderView addSubview:temp];
        
        // return temp;
    }
//
    
    return hearderView;
   // return nil;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
    if (section == 2) {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];
       
        NSInteger count = [sectionInfo numberOfObjects];
        
        
       self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, count*44+10)];
     
        if (count>0) {

            NSInteger start = 0;
            
            for (NSInteger start =0; start<count; start++) {
                
              
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:start inSection:0];
               
                
                Comment *commentDetail = [self.resultFetch objectAtIndexPath:indexPath];
               
                [self.footerView addSubview:[self getCommentListView:commentDetail andIndex:start]];
                
            }

       
        }
        
        return self.footerView;
    }
    return nil;
}

-(UIView *)getCommentListView:(Comment *)commentDetail andIndex:(NSInteger) index
{
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, index*44+1, 320, 44)];

     UIImageView *headImageView= [[UIImageView alloc]initWithFrame:CGRectMake(5 , 5, 33, 33)];
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:commentDetail.headpicture] placeholderImage:[UIImage imageNamed:@"head.png"]];
    
    [commentView addSubview:headImageView];
    
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(41, 20, 182, 20)];
    
    if (commentDetail.co_pid.integerValue == 0) {
         content.text = [NSString stringWithFormat:@"评论:%@",commentDetail.co_content];
    }
    else
    {
         content.text = [NSString stringWithFormat:@"回复%@:%@",commentDetail.replyname, commentDetail.co_content];
    }
   
    content.font = [UIFont systemFontOfSize:16];
    content.textColor =[UIColor lightGrayColor];
    [commentView addSubview:content];

    UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(41, 1, 182, 20)];
    username.text = commentDetail.username;
    
    username.font = [UIFont systemFontOfSize:15];
    username.textColor =[UIColor darkGrayColor];
    [commentView addSubview:username];
    
    
    UILabel *createtime = [[UILabel alloc]initWithFrame:CGRectMake(250, 3, 100, 20)];
    createtime.text = commentDetail.create_time.description;
    createtime.font = [UIFont systemFontOfSize:13];
    createtime.textColor =[UIColor darkGrayColor];
    [commentView addSubview:createtime];

    
    if (![commentDetail.userid isEqualToNumber:self.appDelegate.loginUser.userid]) {
//        UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        replyButton.frame = CGRectMake(245, 23, 100, 15);
//        
//        
//        [replyButton setTitle:@"回复" forState:UIControlStateNormal];
//        [replyButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal   ];
//        [replyButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
//
        
        UILabel *replyLabel = [[UILabel alloc]initWithFrame:CGRectMake(275, 23, 100, 15)];
        replyLabel.text = @"回复";
        replyLabel.font = [UIFont systemFontOfSize:13] ;
        
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickComment:)];
        
        
        
       // [replyButton addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
        //replyButton.tag= index;
        commentView.tag = index;
        //commentDetail.co
        // replyButton.titleLabel.text = @"回复";
        //  replyButton.backgroundColor = [UIColor redColor];
       // NSLog(@"addGestRecognizer");
        [commentView addSubview:replyLabel];
        [commentView addGestureRecognizer:tapGesture];
        commentView.userInteractionEnabled =   YES;
    }
    
    
    return commentView;
}
#pragma praise fail click
-(void)clickComment:(UITapGestureRecognizer *)tap
{
    //NSLog(@"comment click");
    
    
    PROCommentViewController *commentViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"commentVIewController"];
    
    commentViewController.viewPromise = self.viewPromise;
    commentViewController.appDelegate = self.appDelegate;
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tap.view.tag inSection:0];
    
   // tap.view.backgroundColor = [UIColor lightGrayColor];
    Comment *commentDetail = [self.resultFetch objectAtIndexPath:indexPath];
    
    commentViewController.commentid = commentDetail.co_id;
    
    commentViewController.replyid = commentDetail.userid;
    
    commentViewController.commentDetail = commentDetail;
    
    [self.navigationController pushViewController:commentViewController animated:YES];
}

- (IBAction)praiseClick:(id)sender {
    
    //确认是否提交
    if (self.viewPromise.pro_status.integerValue != 0) {
        return  ;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确定要完成？"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确定"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 10;
    
    [actionSheet showInView:self.view];
    
    
 //   UIButton *senderButton = (UIButton *)sender;
    
  //  senderButton.selected = !senderButton.selected;
   // self.failButton.selected =!senderButton.selected;
    
}
-(void)savePraise
{
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    [self.tableView addSubview:  self.appDelegate.HUD];
    
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在保存！";
    [ self.appDelegate.HUD showWhileExecuting:@selector(commitPromiseState) onTarget:self withObject:nil animated:YES];
    
}

-(void)commitPromiseState
{
    if ([self.appDelegate.myMessageData updatePromiseState:self.viewPromise.promiseid andState:self.viewPromise.pro_status]) {
        return;
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (actionSheet.tag == 10) {
        if (buttonIndex == 0) {
                self.praiseButton.selected = !self.praiseButton.selected;
                self.failButton.selected = !self.praiseButton.selected;
           
            self.viewPromise.pro_status = [NSNumber numberWithInt:1];
            
            [self savePraise];
            
        }
    
    }
    
    if (actionSheet.tag == 11) {
        if (buttonIndex == 0) {
            self.failButton.selected = !self.failButton.selected;
            self.praiseButton.selected = !self.failButton.selected;
            
            self.viewPromise.pro_status = [NSNumber numberWithInt:2];
            [self savePraise];

        }
        
    }
    
    if (actionSheet.tag == 12) {
        if (buttonIndex == 0) {
            [self photoSelectClick];
        }
        else if(buttonIndex == 1)
            [self photoLabraryClick];
        
    }
    
    if (buttonIndex == 0) {
       // [self.praiseButton removeFromSuperview];
       // [self.failButton removeFromSuperview];
        
        
         [self.appDelegate saveContext];
    }
    
    
    
}

- (IBAction)failClick:(id)sender {
    
    if (self.viewPromise.pro_status.integerValue != 0) {
        return  ;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确定要失败，将会被扣10个积分？"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确定"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 11;
    
    [actionSheet showInView:self.view];

    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"commentPromise"]) {
        
        // hand off the assets of this album to our singleton data source
//        [PageViewControllerData sharedInstance].photoAssets = self.assets;
//        [PageViewControllerData sharedInstance].selectAssets = self.selectassets;
//        [PageViewControllerData sharedInstance].isFilter = NO;
//        [PageViewControllerData sharedInstance].isOrigin = NO;
//        [PageViewControllerData sharedInstance].isUrlPath = NO;
//          // start viewing the image at the appropriate cell index
        PROCommentViewController *commentViewController = [segue destinationViewController];
        commentViewController.viewPromise = self.viewPromise;
        commentViewController.appDelegate = self.appDelegate;
        commentViewController.commentid = [NSNumber numberWithInteger:0];
        commentViewController.replyid = self.viewPromise.user_id;
        
//        NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
//        pageViewController.startingIndex = selectedCell.row;
        //pageViewController.
        
    }

    
}

-(void)commentClick
{
    [self performSegueWithIdentifier:@"commentPromise" sender:self];
}
-(BOOL)checkIsLoginUser
{
    return [self.viewPromise.user_id isEqualToNumber:self.appDelegate.loginUser.userid]?YES:NO;
    
}
-(BOOL)checkIsFriendPromiseView
{
    return (![self checkIsLoginUser])&&(self.viewPromise.friend_id.integerValue||self.viewPromise.topic.integerValue||self.viewPromise.watch_id.integerValue)?YES:NO;
    
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if (view.tag == 5) {
        return self.watchmanList?[self.watchmanList count]:0;
    }
    if ([self checkIsFriendPromiseView]&& view.tag ==4) {
        return [self.proveImgList count];
        
    }
    return view.tag ==4?([self.proveImgList count]>3?3:[self.proveImgList count]+1):[self.promiseImg count];
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    static NSString *ImgCellIdentifier = @"imageCell";
     static NSString *WatchCellIdentifier = @"watchlistCell";
    //   NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",[indexPath section], (long)[indexPath row]];
    
    UICollectionViewCell *cell =  [cv dequeueReusableCellWithReuseIdentifier:cv.tag ==4?CellIdentifier:(cv.tag == 5?WatchCellIdentifier:ImgCellIdentifier) forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];

    if (cv.tag ==3) {
        
       // ImageList *img =  self.promiseImg[indexPath.row];
       // NSArray *list = self.viewPromise.imagelist.allObjects;
       // [imageView setOnlineImage:self.promiseImg[indexPath.row]];
        if (self.viewPromise.promiseid.integerValue == 99999
            ) {
           // ImageList *img = self.promiseImg[indexPath.row];
            imageView.image = self.promiseImg[indexPath.row];
        }
        
        else
          [imageView sd_setImageWithURL:[NSURL URLWithString:self.promiseImg[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placehold.png"]];
        
       // imageView.image = (UIImage *)self.promiseImgList[indexPath.row]; //[[UIImage alloc] initWithContentsOfFile:img.imagepath];
        
    }
   
    if (cv.tag ==4) {
      //  UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        
        // ImageList *img =  self.promiseImg[indexPath.row];
        // NSArray *list = self.viewPromise.imagelist.allObjects;
        if (self.appDelegate && indexPath.row != [self.proveImgList count]) {
            //  imageView.image = (UIImage *)self.proveImgList[indexPath.row];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.proveImgList[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placehold.png"]];

        }
        else
        {
            imageView.image = [UIImage imageNamed:@"addImg.png"];
        }
       //[[UIImage alloc] initWithContentsOfFile:img.imagepath];
        
    }
    
    if (cv.tag == 5) {
        NSDictionary *watchListDic = self.watchmanList[indexPath.row];
        NSString *url  = [NSString stringWithFormat:IMAGEURL,[watchListDic objectForKey:@"headPicture"]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head.png"]];
        
        UILabel *usernameLabel = (UILabel *)[cell viewWithTag:2];
        usernameLabel.text = [watchListDic objectForKey:@"userName"];
        
    }
    // load the asset for this cell

    //
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 3) {
        
    if(indexPath.row <[self.promiseImg count])
    {
        [PageViewControllerData sharedInstance].isOrigin = (self.viewPromise.promiseid.integerValue == 99999?NO:YES);
        //  [PageViewControllerData sharedInstance].isf = YES;
        [PageViewControllerData sharedInstance].photoAssets = self.promiseImg;
        [PageViewControllerData sharedInstance].isUrlPath = (self.viewPromise.promiseid.integerValue == 99999?NO:YES);
        
        //[PageViewControllerData sharedInstance].selectAssets = self.selectassets;
        // start viewing the image at the appropriate cell index
        MyPageViewController *pageViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"MypageViewController"];
        //NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
        
        pageViewController.startingIndex = indexPath.row ;
        pageViewController.checkButton.hidden = YES;
        [self.navigationController pushViewController:pageViewController animated:YES];
    }
    }
    
    if (collectionView.tag == 4) {
        
        if(indexPath.row  == [self.proveImgList count])
        {
            [self picClick];

        }
        else
        {
            [PageViewControllerData sharedInstance].isOrigin = (self.viewPromise.promiseid.integerValue == 99999?NO:YES);
            //  [PageViewControllerData sharedInstance].isf = YES;
            [PageViewControllerData sharedInstance].photoAssets = self.proveImgList;
            [PageViewControllerData sharedInstance].isUrlPath = (self.viewPromise.promiseid.integerValue == 99999?NO:YES);
            
            //[PageViewControllerData sharedInstance].selectAssets = self.selectassets;
            // start viewing the image at the appropriate cell index
            MyPageViewController *pageViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"MypageViewController"];
            //NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
            
            pageViewController.startingIndex = indexPath.row ;
            pageViewController.checkButton.hidden = YES;
            [self.navigationController pushViewController:pageViewController animated:YES];
        }
    }
    

}

/*
- (void)handleImgTap:(UITapGestureRecognizer *)recognizer{
    
    
    
    
    NSIndexPath *selectPath =[self.imgListCollection indexPathForItemAtPoint:[recognizer locationInView:self.imgListCollection]];
    
    if (!selectPath) {
        return  ;
    }
    
    
//    if (selectPath.row == [self.viewPromise.imagelist count]) {
//       // [self picClick:nil];
//        
//    }
//    else
        if(selectPath.row <[self.promiseImg count])
    {
        [PageViewControllerData sharedInstance].isOrigin = YES;
      //  [PageViewControllerData sharedInstance].isf = YES;
        [PageViewControllerData sharedInstance].photoAssets = self.imageList;
         //[PageViewControllerData sharedInstance].isPath = YES;
        
        //[PageViewControllerData sharedInstance].selectAssets = self.selectassets;
        // start viewing the image at the appropriate cell index
        MyPageViewController *pageViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"MypageViewController"];
        //NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
        pageViewController.startingIndex = selectPath.row ;
        pageViewController.checkButton.hidden = YES;
        [self.navigationController pushViewController:pageViewController animated:YES];
    }
    
    
}
 */


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //self.imageList.image = info[UIImagePickerControllerOriginalImage];
    //self.imageList.hidden = NO;
    
    // UIImageView *imageView =[[UIImageView alloc]initWithImage:info[UIImagePickerControllerOriginalImage]];
    
    //    UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    sampleButton.frame = CGRectMake(12, 52, 68, 72);
    //
    //    [sampleButton setBackgroundImage:[info[UIImagePickerControllerOriginalImage]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    //
    //    [sampleButton setAdjustsImageWhenHighlighted:NO];
    //[sampleButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    //
    //imageView.frame = CGRectMake(12, 52, 68, 72);
    //  [self.promiseInputView addSubview:sampleButton];
    
   // [self.imgList addObject:info[UIImagePickerControllerOriginalImage]];
  //  [self.imgCollecitionView reloadData];
    UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)picClick {
    
//    [self resignResponder];
//    if ([self.imgList count]>=4) {
//        UIAlertView*  alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，最多添加4个相片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alter show];
//        return;
//    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"相片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相机拍摄",@"手机相册", nil];
    actionSheet.tag = 12;
    [actionSheet showInView:self.tableView];
    
}

-(void)photoSelectClick
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    
}

- (void)photoLabraryClick
{
    
    //  self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //  [self presentViewController:self.imagePickerController animated:YES completion:nil];
    RootViewController *myRootViewController =     [self.storyboard instantiateViewControllerWithIdentifier:@"photoRootView"];
    myRootViewController.popToViewController = self;
    [self.navigationController  pushViewController:myRootViewController animated:YES];
    
}

-(void)setImageList:(NSArray *)imageList
{
    
    
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
	[self.tableView addSubview:  self.appDelegate.HUD];
    
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在处理！";
    [ self.appDelegate.HUD showWhileExecuting:@selector(saveAllImage:) onTarget:self withObject:imageList animated:YES];

    //循环上传图证图片
      //  self.imgCollecitionView.hidden = false;
    
}

-(void)saveAllImage:(NSArray *)imageList
{
    for (UIImage *image in imageList) {
        
        
        NSString *imageName = [NSString stringWithFormat:@"%lld.jpg",(int64_t)([[NSDate date]timeIntervalSince1970]*1000.0)];
        NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:imageName];
        
     //   if (![UIImagePNGRepresentation(image) writeToFile:path atomically:YES]) {
          if (![UIImageJPEGRepresentation(image , 0.65) writeToFile:path atomically:YES]) {
            continue;
        }
        [self.appDelegate.myMessageData postProveImg:path andpromisId:self.viewPromise.promiseid];
        
    }
    
    if ([self.appDelegate.myMessageData getPromiseDetail:self.viewPromise.promiseid anduserid:self.appDelegate.loginUser.userid]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self refreshUser];
        });
    }
    
    
    // [self.proveImgList addObjectsFromArray:imageList];

   
}
- (IBAction)praiseComment:(id)sender {
  // -(BOOL)postPraise:(NSNumber *)userid andPromiseid:(NSNumber *)promiseid andpraise:(NSNumber *)praise withCreateUser:(NSNumber *)createuserid;
    if (self.hadPraiseButton.isSelected) {
        UIAlertView*  alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，已经点过赞了!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;

        return;
    }
    self.viewPromise.hadpraise = [NSNumber numberWithBool:YES];
    self.viewPromise.praise =[NSNumber numberWithInteger:self.viewPromise.praise.intValue + 1];
    
     [self setPromisePraiseandEggState];
    
 
    [ self.appDelegate.HUD showWhileExecuting:@selector(postPraise:) onTarget:self withObject:[NSNumber numberWithInteger:1] animated:YES];
    
   
    
   
    
}

-(void)postPraise:(NSNumber *)praiseNum
{
    [self.appDelegate.myMessageData postPraise:self.appDelegate.loginUser.userid andPromiseid:self.viewPromise.promiseid andpraise:praiseNum withCreateUser:self.viewPromise.user_id];
}
- (IBAction)bombComment:(id)sender {
    
    if (self.hadEggButton.isSelected) {
        UIAlertView*  alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，已经点过炸弹了!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
        
        return;
    }
     self.viewPromise.hadegg = [NSNumber numberWithBool:YES];
    self.viewPromise.egg =[NSNumber numberWithInteger:self.viewPromise.egg.intValue + 1];
        [ self.appDelegate.HUD showWhileExecuting:@selector(postPraise:) onTarget:self withObject:[NSNumber numberWithInteger:2] animated:YES];
    
       [self setPromisePraiseandEggState];
    
}


#pragma mark - nsfetched
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
           // NSLog(@"section insert");
            
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
        //   [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                        //    withRowAnimation:UITableViewRowAnimationFade];
//[tableView reloadData];
           
           [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
            
           // NSLog(@"comment insert");

            break;
            
        case NSFetchedResultsChangeDelete:
           // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                           //  withRowAnimation:UITableViewRowAnimationFade];
            break;
            //
        case NSFetchedResultsChangeUpdate:
         //   [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    //atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
          //  [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                           //  withRowAnimation:UITableViewRowAnimationFade];
          //  [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                            // withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



- (IBAction)shareClick:(id)sender {
    
    NSArray *shareButtonTitleArray = @[@"新浪微博",@"QQ空间",@"微信",@"微信朋友圈"];
    NSArray *shareButtonImageNameArray = @[@"sns_icon_1",@"sns_icon_24",@"sns_icon_22",@"sns_icon_23"];
    
    
    LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:@"分享到社交平台" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
    
    
    return;
    
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    NSLog(@"%d",(int)imageIndex);
    
    switch ((int)imageIndex) {
        case 0:
            [self weiboShare];
            break;
        case 1:
            [self qqShare];
            break;
        case 2:
            [self weixinShare];
            break;
        case 3:
            [self weixinFriendShare];
            break;
        default:
            break;
    }
    
}

-(void)weiboShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"关注#UPROMISE＃:" ;
    
    [message.text stringByAppendingString:self.viewPromise.pro_content];
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": @"UPROMISE"};
    
    [WeiboSDK sendRequest:request];
    
}
-(void)weixinShare
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"关注#UPROMISE＃:";
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}
-(void)weixinFriendShare
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"关注#UPROMISE＃:";
    req.bText = YES;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}
-(void)qqShare
{
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"关注#UPROMISE＃:" ];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
}
- (void)didClickOnCancelButton
{
    NSLog(@"didClickOnCancelButton");
}




@end
