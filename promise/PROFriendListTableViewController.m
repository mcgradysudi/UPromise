//
//  PROFriendListTableViewController.m
//  promise
//
//  Created by su di on 14-8-20.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROFriendListTableViewController.h"
#import "FriendList.h"

#import "PROMessageData.h"
#import "PROFriendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PROFirstViewController.h"

@interface PROFriendListTableViewController ()
@property (weak,nonatomic)PROMessageData *myMessageData;
@property (weak,nonatomic)UserInfo *loginUser;


@end

@implementation PROFriendListTableViewController

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
    
    
    //self.appdelgate = (PROAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //self.loginUser  = self.appdelgate.loginUser;
    //self.myMessageData  = self.appdelgate.myMessageData;
   
    
    //self.myMessageData postlo
    

 }

-(void)viewWillAppear:(BOOL)animated
{
     [self initTableResult];
    
    self.appdelgate.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
	[self.tableView addSubview:  self.appdelgate.HUD];
    
    self.appdelgate.HUD.delegate = self;
    self.appdelgate.HUD.labelText = @"正在处理！";
    [ self.appdelgate.HUD showWhileExecuting:@selector(loadFriendList) onTarget:self withObject:nil animated:YES];
    
  
    
    
    
}

-(void)loadFriendList
{
    static NSInteger i = 1;
    
    [self.myMessageData getFriendList:i++ andPageNum:100];
    
}
-(void)initTableResult
{
    self.appdelgate = (PROAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.loginUser  = self.appdelgate.loginUser;
    self.myMessageData  = self.appdelgate.myMessageData;
    
    //  self.delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [self.appdelgate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FriendList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"ownFriendid==%@",self.loginUser.userid];
    
    
    [fetchRequest setPredicate:selectPredict];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userid" ascending:YES];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
     return [[self.resultFetch sections] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:section];
    return sectionInfo.name;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section:(NSInteger)section
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultFetch sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PROFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendList" forIndexPath:indexPath];
     FriendList *friend =  [self.resultFetch objectAtIndexPath:indexPath];
    // Configure the cell...
    //cell.textLabel.text = friend.username;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:friend.headpicture] placeholderImage:[UIImage imageNamed:@"head.png"]];
    cell.userNameLabel.text = friend.username;
    cell.explainInfoLabel.text = friend.explaininfo;
    cell.viewFriend = friend;
    cell.isCheckView = self.isCheckView;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendList *friend =  [self.resultFetch objectAtIndexPath:indexPath];
    if ([self.selectFriends containsObject:friend]) {
        [self.selectFriends removeObject:friend];
        friend.isSelected = NO;
    }
    else
    {
        [self.selectFriends addObject:friend];
        friend.isSelected = YES;
        
    }
     [self.tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
     [self.tableView endUpdates];
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
    
    if ([segue.identifier isEqualToString:@"userDetailIdentifier"]) {
        PROFirstViewController *friendDetail  = [segue destinationViewController];
        //self.tableView
        friendDetail.viewFriend = [self.resultFetch objectAtIndexPath:[self.tableView indexPathForSelectedRow]];;
        
        
    }
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


-(void)configureCell:(UITableViewCell  *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //Task *pp = [self.resultFetch objectAtIndexPath:indexPath];
    // cell.name = pp.taskName.description;
    //[cell getCompletNum];
    
  //  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(searchText);
    
}

@end
