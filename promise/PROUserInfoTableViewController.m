//
//  PROUserInfoTableViewController.m
//  promise
//
//  Created by su di on 14-8-16.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROUserInfoTableViewController.h"
#import "PROUserHeaderView.h"
#import "PROUserPromiseListTableViewCell.h"
#import "MJRefresh.h"
#import "Promise.h"
#import "PRODetailTableViewController.h"
#import "PROSettingUserEditTableViewController.h"

@interface PROUserInfoTableViewController ()
@property (weak,nonatomic)PROMessageData *myMessageData;
@property (weak,nonatomic) UserInfo *myLoginUser;
@property (strong,nonatomic)PROUserHeaderView *userHeaderView;
@property (strong,nonatomic)UIImageView *tipsView;
@property (assign,nonatomic)NSInteger selectTag;

@end
static NSString *detailUserTaskCellIndent = @"detailUserTaskCellIndent";
@implementation PROUserInfoTableViewController

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
    [self.tableView registerClass:[PROUserPromiseListTableViewCell class] forCellReuseIdentifier:detailUserTaskCellIndent];
    self.tipsView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_tips.png"]];
    
    self.selectTag = 0;
    
    
    self.appdelgate = (PROAppDelegate *)[[UIApplication sharedApplication] delegate];
    //self.tableView.sectionHeaderHeight = 2;
    //self.tableView.sectionFooterHeight = 2;
    //self.title = @"#!23";
    
    self.myLoginUser  = self.appdelgate.loginUser;
    self.myMessageData  = self.appdelgate.myMessageData;
    
    
    [self.myMessageData setUsername:self.myLoginUser.account];
    [self.myMessageData setPassword:self.myLoginUser.password];
    
    [self initTableResult];

    [self initUserHeadView];
    
    [self setupRefresh];
    
  
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
   // NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    if (touch.view.tag == 10) {
       // [self changeDefaultPic];
        return NO;
    }
    if(touch.view.tag ==  self.selectTag+1) return NO;
    
    switch (touch.view.tag) {
        case 1:
        case 2:
        case 3:
            self.selectTag = touch.view.tag - 1;
            [self initTableResult];
            [self.tableView reloadData];
            [self.tableView headerBeginRefreshing];
            [self.userHeaderView clickTag:touch.view.tag];
            
            break;
          case 4:
           // [self.tabBarController setSelectedIndex:3];
        {
            PROSettingUserEditTableViewController  *settingUserViewController
               =  [self.storyboard instantiateViewControllerWithIdentifier:@"settingUserViewController"];
            
            [self.navigationController pushViewController:settingUserViewController animated:YES];
        }
          //  [self performSegueWithIdentifier:@"userSetting" sender:self];
            break;
        default:
            break;
    }
    
    
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    
    // NSLog(@"%@", NSStringFromClass([recognizer.view class]));
    
    
}

-(void)changeDefaultPic
{
    UIView *pick = [[UIView alloc]initWithFrame:self.view.frame];
    
    pick.alpha = 0.9f;
    
    pick.backgroundColor = [UIColor lightGrayColor];
    pick.userInteractionEnabled= YES;
    [self.view addSubview:pick];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUserHeadView
{
    self.userHeaderView = [PROUserHeaderView view];
    self.userHeaderView.viewUser = self.myLoginUser;
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                              action:@selector(handleTap:)];
    singleTap.delegate = self;
    
    [self.userHeaderView addGestureRecognizer:singleTap];
    
    [self refreshPromiseSize];

    
}

-(void)initTableResult
{
   
    
    //  self.delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [self.appdelgate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Promise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (self.selectTag == 0) {
         NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"user_id==%@" ,self.myLoginUser.userid,self.selectTag];
         [fetchRequest setPredicate:selectPredict];
    }
    else if(self.selectTag == 1)
    {
        NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"user_id==%@ AND pro_status==%d" ,self.myLoginUser.userid,self.selectTag];
        [fetchRequest setPredicate:selectPredict];
    }
    else if(self.selectTag == 2)
    {
        NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"watch_id==%@" ,self.myLoginUser.userid];
        [fetchRequest setPredicate:selectPredict];
    }
   
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"promiseid" ascending:NO];
       NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"create_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, sortDescriptor1,nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // self.name = [context executeFetchRequest:fetchRequest error:&error];
    
    self.resultFetch =  [[NSFetchedResultsController alloc]
                         initWithFetchRequest:fetchRequest
                         managedObjectContext:context
                         sectionNameKeyPath:nil
                         cacheName:nil];
    [self.resultFetch performFetch:&error];
    self.resultFetch.delegate = self;
    
   // NSLog(@"%d",[[self.resultFetch sections] count]);

    
    
   // [self.tableView reloadData];

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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.userHeaderView ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 172;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PROUserPromiseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailUserTaskCellIndent forIndexPath:indexPath];
    //    if (cell==nil) {
    //        cell=[[PROUserPromiseListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailTaskCellIndent];
    //    }
    //
    //cell.contentView.frame = CGRectMake(0, 0, 319, 188);
    //  if([self.myLoginUser.promise count])
    
    cell.viewPromise = [self.resultFetch objectAtIndexPath:indexPath];
    
    
    
    //NSArray *list = cell.viewPromise.imagelist.allObjects;
    //  NSLog(@"%@,row=%ld",cell.viewPromise.pro_content,(long)indexPath.row );
    
    //[cell setNeedsLayout];
    // [cell setNeedsDisplay];
    //cell.addTimeLable.text = cell.textLabel;
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     Promise *tempPromise =  [self.resultFetch objectAtIndexPath:indexPath];
    //NSLog(@"id = %@，%@",temp.promiseid,temp.imageUrl);
    CGFloat height = [tempPromise calcPromiseRowHeight];
    return [tempPromise calcPromiseRowHeight];
    
    
    if (tempPromise.promiseid.integerValue ==99999) {
         return [tempPromise.imagelist count]!=0?145:80;
    }
    //CGFloat height = [tempPromise calcFriendRowHeight];
    return [tempPromise.imageString compare:@""]!=NSOrderedSame?145:80;
   
    
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
    PRODetailTableViewController *detailPromise = [self.storyboard instantiateViewControllerWithIdentifier:@"prodetailtabelview"];
    detailPromise.appDelegate = self.appdelgate;
    detailPromise.viewPromise = [self.resultFetch objectAtIndexPath:indexPath];;
    [self.navigationController pushViewController:detailPromise animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefreshing) name:@"refresh_table" object:nil];
    
    
  
}

-(void)refreshPromiseSize
{
    self.userHeaderView.allLabel.text = [NSString stringWithFormat:@"所有 %@",self.myLoginUser.totalsize];
    
    self.userHeaderView.completeLabel.text = [NSString stringWithFormat:@"完成  %@",self.myLoginUser.successsize];
    
    self.userHeaderView.watchLabel.text = [NSString stringWithFormat:@"监督  %@",self.myLoginUser.watchsize
                                           ];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    //    for (int i = 0; i<5; i++) {
    //        [self.fakeData insertObject:MJRandomData atIndex:0];
    //    }
    
    // 2.2秒后刷新表格UI
    
   
    // dispatch_get_main_queue()
 
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // something
        
        NSArray * promiseInfo = [self.myMessageData getUserPromise:1 andPageNum:30 andPromiseState:self.selectTag?(self.selectTag==2?3:self.selectTag-1):-1];
        if (promiseInfo&&[promiseInfo count]>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self.appdelgate initPromiseInfo:promiseInfo andWatchId:self.myLoginUser.userid andState:self.selectTag?(self.selectTag==2?3:self.selectTag-1):-1];
               // [self initTableResult];
            });
        }
        
        if ([self.myMessageData getPromiseSize:self.myLoginUser.userid]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //回调或者说是通知主线程刷新，
                
                [self refreshPromiseSize];
                
                
                
                // [self initTableResult];
            });
            
        }
      
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
             [self.tableView headerEndRefreshing];
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];
            if([sectionInfo numberOfObjects] == 0 && self.selectTag == 0)
            {
                //NSLog(@"%@",NSStringFromCGRect(self.tabBarController.tabBar.frame));
                self.tipsView.frame = CGRectMake(0,self.tabBarController.tabBar.frame.origin.y-100, 320, 100);
                
                [self.tableView addSubview:self.tipsView];
            }
            else [self.tipsView removeFromSuperview];
            
            

            
        });

        
    });
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        // 刷新表格
    //      //  [self.tableView reloadData];
    //
    //        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    //        [self.tableView headerEndRefreshing];
    //    });
}
-(void)viewWillDisappear:(BOOL)animated
{
   // self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

-(void)viewDidAppear:(BOOL)animated

{

   id<NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];

   if ([sectionInfo numberOfObjects]<=0 ) {
   //     [self.tableView headerBeginRefreshing];
   }

}
-(void)viewWillAppear:(BOOL)animated
{
    //  self.navigationController.navigationBarHidden = NO;
    UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sampleButton.frame = CGRectMake(140, 2, 60, 50);
    
    [sampleButton setBackgroundImage:[[UIImage imageNamed:@"sms.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    // [sampleButton setBackgroundImage:[[UIImage imageNamed:@"sms_click.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [sampleButton setAdjustsImageWhenHighlighted:NO];
    [sampleButton addTarget:self action:@selector(getMessage) forControlEvents:UIControlEventTouchUpInside];

    
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:sampleButton];
    
    
    
    //;
    
   // UIBarButtonItem *buttonItem= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemBookmarks) target:self action:@selector(getMessage)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = buttonItem;
    
    
    self.tabBarController.navigationItem.title =@"YOU PROMISE";
    

   // [self initPromiseInfo:self.selectTag];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // something
        
        if ([self.appdelgate.myMessageData updateUserInfo:self.myLoginUser.account andPassword:self.myLoginUser.password]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                //[self initTableResult];
                 [self.userHeaderView refresh];
            });
            
            
            
        } ;
    });
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if ([self.appdelgate.myMessageData updateUserInfo:self.myLoginUser.account andPassword:self.myLoginUser.password]) {
//            [self.userHeaderView refresh];
//        }
//    });
//    
   
    
    
   // [self initTableResult];
    
        // self.tabBarItem.image = [UIImage imageNamed:@"bomb.png"];
    
    
}
-(void)endRefreshing
{
   // [self initPromiseInfo:self.selectTag];
    
   // [self initTableResult];
    
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}
- (void)footerRereshing
{
    // 1.添加假数据
   // static NSInteger page = 2;
    
       //return [sectionInfo numberOfObjects];
    
    
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:0];
        NSInteger page = [sectionInfo numberOfObjects]/10;

        NSArray * promiseInfo =  [self.myMessageData getUserPromise:++page andPageNum:30 andPromiseState:self.selectTag] ;
        if (promiseInfo&&[promiseInfo count]>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self.appdelgate initPromiseInfo:promiseInfo andWatchId:self.myLoginUser.userid andState:self.selectTag];
                // [self initTableResult];
            });
        }
        
        [self.tableView footerEndRefreshing];
        
    });
    
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
           // NSLog(@"insertNew");

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


-(void)configureCell:(PROUserPromiseListTableViewCell  *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //Task *pp = [self.resultFetch objectAtIndexPath:indexPath];
    // cell.name = pp.taskName.description;
    //[cell getCompletNum];
   // NSLog(@"changeUpdate");
    cell.viewPromise = [self.resultFetch objectAtIndexPath:indexPath];
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

-(void)getMessage
{
    [self performSegueWithIdentifier:@"showMessage" sender:self];
    
}
@end
