//
//  PROFindFriendTableViewController.m
//  promise
//
//  Created by su di on 14-8-16.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROFindFriendTableViewController.h"
#import "UIImageView+WebCache.h"
#import "PROFindFriendTableViewCell.h"
@interface PROFindFriendTableViewController ()
@property (strong,nonatomic)NSArray *imgArrayList;
@property (strong,nonatomic)NSArray *stringArrayList;
@property (strong,nonatomic)NSArray *recommendUser;
@property (strong,nonatomic)NSMutableSet *addRecommendUser;
@end

@implementation PROFindFriendTableViewController

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
    self.imgArrayList = [[NSArray alloc]initWithObjects:@"local_new.png",@"weibo.png",@"QQ.png",@"renren.png", nil];
    self.stringArrayList = [[NSArray alloc]initWithObjects:@"查看附近的人",@"从新浪微博中添加好友",@"从QQ中添加好友",@"从人人网中添加好友", nil];
    
    self.recommendUser = nil;
    self.addRecommendUser = [[NSMutableSet alloc]init];
    self.appdelgate = (PROAppDelegate *)[[UIApplication sharedApplication] delegate];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.appdelgate) {
        self.appdelgate.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
        [self.tableView addSubview:  self.appdelgate.HUD];
        
        self.appdelgate.HUD.delegate = self;
        self.appdelgate.HUD.labelText = @"正在处理！";
        [ self.appdelgate.HUD showWhileExecuting:@selector(loadRecommendUser) onTarget:self withObject:nil animated:YES];
    }
  

}

-(void)loadRecommendUser
{
    if (self.appdelgate) {
       self.recommendUser =  [self.appdelgate.myMessageData getRecommendUser:1 andPageNum:30];
        if (self.recommendUser) {
            [self.tableView reloadData];
        }
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return section==0?[self.imgArrayList count]:[self.recommendUser count];
    return [self.recommendUser count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   // return section==0?@"":@"UP推荐";
    return @"UP推荐";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //return section == 0?0:25;
    return 25;
}
- (PROFindFriendTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PROFindFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendFriendCell" forIndexPath:indexPath];
    
//    if (indexPath.section == 0) {
//        
//        
//        // Configure the cell...
//       // CGRect imageFrame = cell.titleImage.frame;
//        // cell.titleImage.image = [UIImage imageNamed:self.imgArrayList[indexPath.row]];
//       // cell.imageView.hidden = NO;
//        //cell.imageView.image = [UIImage imageNamed:self.imgArrayList[indexPath.row]];
//        cell.titleImage.image = [UIImage imageNamed:self.imgArrayList[indexPath.row]];
//        cell.titleName.text =self.stringArrayList[indexPath.row];
//       
//        cell.addFriendButton.hidden = YES;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        //cell.textLabel.text = self.stringArrayList[indexPath.row];
//        //cell.imageView.frame = CGRectMake(imageFrame.origin.x, imageFrame.origin.y, 30, 30);
//        //cell.imageView.contentMode =
//        
//    }
//    if (indexPath.section == 1) {
        NSDictionary *recommendFriend = self.recommendUser[indexPath.row];
        if (recommendFriend) {
           // cell.textLabel.text = [recommendFriend objectForKey:@"username"];
            cell.titleName.text = [recommendFriend objectForKey:@"username"];
            cell.titleImage.hidden = NO;
            NSString *headPictureUrl = [recommendFriend objectForKey:@"headPicture"];
            
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,headPictureUrl]] placeholderImage:[UIImage imageNamed: @"head.png"]];
            cell.titleImage.contentMode = UIViewContentModeScaleAspectFit;
            
            cell.addFriendButton.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            if ([self.addRecommendUser member:recommendFriend]) {
              
            cell.addFriendButton.selected = [self.addRecommendUser member:recommendFriend]?YES:NO;
               
                cell.titleImage.layer.masksToBounds = YES;
                cell.titleImage.layer.cornerRadius = 17;
                CGColorRef cgColor = [UIColor colorWithRed:78.0/255.0 green:126.0/255.0 blue:158.0/255.0 alpha:0.8].CGColor;
                cell.titleImage.layer.borderColor = cgColor;
                cell.titleImage.layer.borderWidth = 1.8;
                
            }
           // cell.imageView.frame = cg
            //cell.textLabel.text = self.stringArrayList[indexPath.row];
        }
        
    //}
    
    return cell;

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      NSDictionary *recommendFriend = self.recommendUser[indexPath.row];
    if ([self.addRecommendUser member:recommendFriend] == nil) {
        [self.addRecommendUser addObject:recommendFriend];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        //处理添加好友
        self.appdelgate.HUD.labelText = @"正在添加好友！";
        [ self.appdelgate.HUD showWhileExecuting:@selector(addFriendRelation:) onTarget:self withObject:indexPath animated:YES];
    }
    
    
    //[self.tableView reloadData];
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addFriendRelation:(NSIndexPath *)indexPath
{
    NSDictionary *recommendFriend = self.recommendUser[indexPath.row];
    if (recommendFriend) {
       NSNumber *userId= [recommendFriend objectForKey:@"userId"];
        [self.appdelgate.myMessageData addFriendRelation:userId.description];
        
    }
}

@end
