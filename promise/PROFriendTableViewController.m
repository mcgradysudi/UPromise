//
//  PROFriendTableViewController.m
//  promise
//
//  Created by su di on 14-7-20.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROFriendTableViewController.h"
#import "MJRefresh.h"
#import "UserInfo.h"
#import "PROMessageData.h"
#import "PROFriendListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PRODetailTableViewController.h"


@interface PROFriendTableViewController()
@property (weak,nonatomic)UserInfo *loginUser;
@property (weak,nonatomic)PROMessageData *myMessageData;
@property (strong,nonatomic)NSDateFormatter *dateFormatter;
@property (strong,nonatomic)  UIView *moreView ;
@property (strong,nonatomic)  UIView *tipsNoView ;
@property (strong,nonatomic)  UIImageView *tipsView ;
@property (strong,nonatomic)  UIImageView *friendImageView ;


@end

static NSString *detailFriendCellIndent = @"friendCell";
@implementation PROFriendTableViewController

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
    self.friendCellHeightList = [[NSArray alloc]initWithObjects:@212,@254,@234,@244,@212, nil];
    self.dateFormatter  = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.tipsNoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 230)];
    
   
   // self.testLabel.text  = @"rer";
    [self initTableResult];
    [self setupRefresh];;
    [self initMoreView];
    if (![self checkIsTopic]) {
        [self initNotipsView];
    }
    
    
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                              action:@selector(handleTap:)];
    singleTap.delegate = self;

    [self.tableView addGestureRecognizer:singleTap];
  }

-(void)initNotipsView
{
    self.tipsView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"txt.png"]];
    self.friendImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ques.png"]];
    UIButton *findButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 320, 40)];
    
    [findButton setBackgroundImage:[[UIImage imageNamed:@"find.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [findButton setImage:[UIImage imageNamed:@"find_icon.png"] forState:UIControlStateNormal];
   
    
    [findButton setAdjustsImageWhenHighlighted:NO];
    [findButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
     [findButton setTitle:@"  查找好友" forState:UIControlStateNormal];
    //findButton.tintColor
    [self.tipsNoView addSubview:findButton];

    self.tipsView.frame = CGRectMake(0,90, 320, 100);
    self.friendImageView.frame = CGRectMake(0,20, 320, 70);
    [self.tipsNoView addSubview:self.friendImageView];
    [self.tipsNoView addSubview:self.tipsView];

    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
     //   NSLog(@"%@",NSStringFromClass([touch.view class]) );
   
    if (touch.view.tag == 6) {
        NSIndexPath *selectIndexPath = [self.tableView indexPathForRowAtPoint:[touch locationInView:self.tableView]];
        
         Promise *tempPromise =  [self.resultFetch objectAtIndexPath:selectIndexPath];
        tempPromise.displayall = tempPromise.displayall.integerValue?[NSNumber numberWithBool:NO]:[NSNumber numberWithBool:YES];
        
       // [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
    
    if (touch.view.superview.tag == 20) {
        return YES;
        
    }
    if (self.moreView.superview) {
        [self.moreView removeFromSuperview];
        return NO;
    }
    if (touch.view.tag == 5) {
        //弹出view
        if (!self.moreView.superview) {
            CGPoint childPoint =  [touch locationInView:touch.view];
            CGPoint superPoint = [touch locationInView:gestureRecognizer.view];
          //  NSLog(@"%@", NSStringFromCGRect(touch.view.frame));
            CGRect ttframe =  CGRectMake(superPoint.x - childPoint.x-61*3-5, superPoint.y-childPoint.y-10, 51*3, 32);
            
            self.moreView.frame = ttframe;
             [self.tableView addSubview:self.moreView];
        }
       
       
        
        return YES;
        
        
        
    }
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
    return  NO;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    
   //  NSLog(@"%@", NSStringFromCGPoint([recognizer locationInView:recognizer.view]));
    
    
}

-(BOOL)checkIsTopic
{
    return self.topicNum&&(self.topicNum.integerValue>0);
}
-(void)initTableResult
{
    self.appdelgate = (PROAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.loginUser  = self.appdelgate.loginUser;
    self.myMessageData  = self.appdelgate.myMessageData;
    
    //  self.delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [self.appdelgate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Promise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *selectPredict = [self checkIsTopic]?[NSPredicate predicateWithFormat:@"topic==%@",self.topicNum]:[NSPredicate predicateWithFormat:@"friend_id==%@",self.loginUser.userid];
    
    
    [fetchRequest setPredicate:selectPredict];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"create_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // self.name = [context executeFetchRequest:fetchRequest error:&error];
    
    self.resultFetch =  [[NSFetchedResultsController alloc]
                         initWithFetchRequest:fetchRequest
                         managedObjectContext:context
                         sectionNameKeyPath:nil
                         cacheName:nil];
    [self.resultFetch performFetch:&error];
    self.resultFetch.delegate = self;


    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshTipsNoView
{
    if (![self checkIsTopic]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];
        if([sectionInfo numberOfObjects] == 0)
        {
            
            [self.tableView addSubview:self.tipsNoView];
            //[self.tableView addSubview:self.tipsView];
        }
        else
        {
            [self.tipsNoView removeFromSuperview];
            //[self.friendImageView removeFromSuperview];
        }

    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    //self.tabBarController.navigationItem.rightBarButtonItem = nil;
    //self.tabBarController.navigationItem.rightBarButtonItem = nil;
}
-(void)viewDidAppear:(BOOL)animated
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];
    if (!([sectionInfo numberOfObjects]>0)) {
        [self.tableView headerBeginRefreshing];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    NSArray *topicList = [[NSArray alloc]initWithObjects:@"减肥",@"健身", @"我戒",@"英语",@"旅行",@"交友",@"表白", nil];
   
    
    self.tabBarController.navigationItem.title  = @"我的好友";
    
    if ([self checkIsTopic]) {
        self.title = topicList[self.topicNum.integerValue -1];
        

    }
 //   self.tabBarController.navigationItem.rightBarButtonItem.hd
//
    

    
//    UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    sampleButton.frame = CGRectMake(140, 2, 60, 44);
//    
//    [sampleButton setBackgroundImage:[[UIImage imageNamed:@"add_list.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
//    
//    // [sampleButton setBackgroundImage:[[UIImage imageNamed:@"sms_click.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
//    
//    [sampleButton setAdjustsImageWhenHighlighted:NO];
//    [sampleButton addTarget:self action:@selector(getFriendList) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:sampleButton];
//    
//    
//    self.tabBarController.navigationItem.rightBarButtonItem = buttonItem;

    
    
    UIBarButtonItem *buttonItem= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemBookmarks) target:self action:@selector(getFriendList)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = buttonItem;
    

    
    [self refreshTipsNoView];
    
    

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [[self.resultFetch sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
  //  return  15;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//    return indexPath.row !=1?121:212;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return ((NSNumber *)self.friendCellHeightList[indexPath.row]).intValue;
  
    
    //return indexPath.row !=1?121:212;
    Promise *tempPromise =  [self.resultFetch objectAtIndexPath:indexPath];
//    if (!tempPromise.imageUrl) {
//        [tempPromise initImageUrl:tempPromise.imageString];
//        
//    }
    
   
//    if (tempPromise.textDisplayAll) {
//        NSLog(@"444");
//        
//    }
    
    //CGFloat height = [tempPromise calcFriendRowHeight];
    return [tempPromise calcFriendRowHeight];
    return [tempPromise.imageString compare:@""]!=NSOrderedSame?176:(tempPromise.displayall.integerValue?145:101);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:detailFriendCellIndent forIndexPath:indexPath];
    
    PROFriendListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:detailFriendCellIndent forIndexPath:indexPath];
    
   // cell.textLabel.text = @"rerer";
    Promise *tempPromise =  [self.resultFetch objectAtIndexPath:indexPath];
    cell.promiseContentLabel.text = tempPromise.pro_content;
    cell.promiseUsername.text = tempPromise.username;
    
    [cell.promiseUserImage sd_setImageWithURL:[NSURL URLWithString: tempPromise.headpicture] placeholderImage:[UIImage imageNamed:@"head.png"]];
    cell.promisePostDateLabel.text = [self.dateFormatter stringFromDate:tempPromise.create_date] ;
    
    cell.friendPromise = tempPromise;
    [cell.friendPromise  initImageUrl:cell.friendPromise.imageString];
    
    cell.parentController = self;
    // NSLog(@"cell1:%@:%@",tempPromise.pro_content,NSStringFromCGRect(cell.promiseContentLabel.frame));
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"friendSelect"]) {
        
        // hand off the assets of this album to our singleton data source
        // start viewing the image at the appropriate cell index
        PRODetailTableViewController *detailViewContorller = [segue destinationViewController];
        NSIndexPath *selectedCell = [self.tableView indexPathForSelectedRow];
    //detailPromise.appDelegate = self.appdelgate;

        
        detailViewContorller.viewPromise =  [self.resultFetch objectAtIndexPath:selectedCell];
        //pageViewController.
        
    }

    
}


- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    //[self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefreshing) name:@"refresh_friend_table" object:nil];
    
    
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    //    for (int i = 0; i<5; i++) {
    //        [self.fakeData insertObject:MJRandomData atIndex:0];
    //    }
    
    // 2.2秒后刷新表格UI
    if (self.topicNum && self.topicNum.integerValue >0) {
       
        [self.myMessageData getPromisebyTopic:1 andPageNum:10 andTopicId:self.topicNum];
        
    }
    else
        [self.myMessageData getFriendPromise:1 andPageNum:10];
    // dispatch_get_main_queue()
    
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    //        // 刷新表格
//    //      //  [self.tableView reloadData];
//    //
//    //        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [self.tableView headerEndRefreshing];
//        });
}

-(void)endRefreshing
{
   // [self initPromiseInfo:self.selectTag];
    
   // [self.tableView reloadData];
    //[self initTableResult];
    [self refreshTipsNoView];

    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}
- (void)footerRereshing
{
    // 1.添加假数据
   // static NSInteger page = 2;
     id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];
    
    NSInteger page = [sectionInfo numberOfObjects]/10;
    
    
    if (self.topicNum && self.topicNum.integerValue >0) {
        
        [self.myMessageData getPromisebyTopic:++page andPageNum:10 andTopicId:self.topicNum];
        
    }
    else
        [self.myMessageData getFriendPromise: ++page andPageNum:10];
    
    
    // 2.2秒后刷新表格UI
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        // 刷新表格
    //      //  [self.tableView reloadData];
    //
    //        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    //        [self.tableView footerEndRefreshing];
    //    });
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
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            //
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


-(void)configureCell:(PROFriendListTableViewCell  *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //Task *pp = [self.resultFetch objectAtIndexPath:indexPath];
    // cell.name = pp.taskName.description;
    //[cell getCompletNum];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
-(void)getFriendList
{
    [self performSegueWithIdentifier:@"friendList" sender:self];
}
-(void)clickButton
{
    [self performSegueWithIdentifier:@"showFindFirend" sender:self];
}
-(void)testButton
{
    NSLog(@"buttonClick");
    
}
-(void)initMoreView
{
    //UIView *moreView = [[UIView alloc]init];
    self.moreView = [[UIView alloc]init];
    self.moreView.backgroundColor = [UIColor lightGrayColor];
    self.moreView.tag = 20;
    UIButton *praiseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 51, 32)];
    [praiseButton setBackgroundImage:[[UIImage imageNamed:@"praise_more.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [praiseButton setAdjustsImageWhenHighlighted:NO];
    
    [praiseButton addTarget:self action:@selector(testButton) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    UIButton *bombButton = [[UIButton alloc]initWithFrame:CGRectMake(51, 0, 59, 32)];
    [bombButton setBackgroundImage:[[UIImage imageNamed:@"bomb_more.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [bombButton setAdjustsImageWhenHighlighted:NO];
    
   
    
    UIButton *commentButton = [[UIButton alloc]initWithFrame:CGRectMake(110, 0, 71, 32)];
    [commentButton setBackgroundImage:[[UIImage imageNamed:@"comment_more.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [commentButton setAdjustsImageWhenHighlighted:NO];
    
    
    [self.moreView addSubview:praiseButton];
    [self.moreView addSubview:bombButton];
    [self.moreView addSubview:commentButton];
    
}
@end
