//
//  PRODetailMessageTableViewController.m
//  promise
//
//  Created by su di on 14-8-31.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PRODetailMessageTableViewController.h"
#import "UIImageView+WebCache.h"
#import "PRODetailMessageTableViewCell.h"
#import "PRODetailTableViewController.h"

@interface PRODetailMessageTableViewController ()
@property (strong,nonatomic)NSArray *messageList;
@end

@implementation PRODetailMessageTableViewController

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
    self.appDelegate = (PROAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    [self.tableView addSubview:  self.appDelegate.HUD];
    
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在获取！";
    
   // self.messageType = [NSNumber numberWithInteger:0];
    self.messageList = [[NSArray alloc]init];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
   [self.appDelegate.HUD showWhileExecuting:@selector(getMessage:) onTarget:self withObject:self.messageType animated:YES];
    
}

-(void)getMessage:(NSNumber *)messageType
{
    self.messageList=  [self.appDelegate.myMessageData getMessage:self.messageType anduserid:self.appDelegate.loginUser.userid];
    if ( self.messageList && [self.messageList respondsToSelector:@selector(count)]) {
        [self.tableView reloadData];
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
    return [self.messageList count];;
}


- (PRODetailMessageTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRODetailMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailMessage" forIndexPath:indexPath];
    NSDictionary *messageDetail = self.messageList[indexPath.row];
    
    NSString *imageUrl = [NSString stringWithFormat:IMAGEURL, [messageDetail objectForKey:@"headPicture"]];

    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"head.png"]];
        
    
    cell.contentLabel.text = [NSString stringWithFormat:[self getFullString],[messageDetail objectForKey:@"content"]];
  
   
    cell.userNameLabel.text = [messageDetail objectForKey:@"friendName"];
    cell.promiseId = [messageDetail objectForKey:@"promiseId"];
    cell.creatTimeLabel.text = [messageDetail objectForKey:@"createTime"];
    if (self.messageImageList) {
        cell.messageTypeImage.image = [UIImage imageNamed:(NSString *)(self.messageImageList[self.messageType.integerValue])];
    }
    
    
    // Configure the cell...
    
    return cell;
}

-(NSString *)getFullString
{
    switch (self.messageType.integerValue) {
        case 0:
            return @":%@";
            break;
        case 1:
             return @"给你点赞%@";
            break;
        case 2:
             return @"给你发了个炸弹%@";
        
        default:
            break;
    }
    
    return @"评论了你:%@";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRODetailTableViewController *detailPromise = [self.storyboard instantiateViewControllerWithIdentifier:@"prodetailtabelview"];
     NSDictionary *messageDetail = self.messageList[indexPath.row];
    
    detailPromise.appDelegate = self.appDelegate;
    NSNumber *promiseId = [messageDetail objectForKey:@"promiseId"];
    detailPromise.viewPromise = [self.appDelegate findPromise:promiseId.integerValue];;
    if (detailPromise.viewPromise) {
          [self.navigationController pushViewController:detailPromise animated:YES];
    }
  
    
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

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if (segue.identifier isEqualToString:@"showDetailFromMessage") {
//        
//        
//    }
//}


@end
