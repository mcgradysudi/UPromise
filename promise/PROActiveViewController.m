//
//  PROActiveViewController.m
//  promise
//
//  Created by su di on 14-7-20.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROActiveViewController.h"
#import "PROFriendTableViewController.h"
@interface PROActiveViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property  (strong,nonatomic)NSArray *topicArray;
@property   (strong,nonatomic)NSArray *hotArray;

@property (strong,nonatomic)NSNumber *topicNum;
@property (strong, nonatomic) IBOutlet UIButton *topicButton;
@property (strong, nonatomic) IBOutlet UIButton *hotButton;

@end

@implementation PROActiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topicArray = [[NSArray alloc]initWithObjects:@"theme1.png", @"theme2.png",@"theme3.png",@"theme4.png",@"theme5.png",@"theme6.png",@"theme7.png",nil];
    self.hotArray = [[NSArray alloc]initWithObjects:@"banner-01.png",@"banner-02.png",@"banner-03.png", nil];
    
    self.topicNum = [NSNumber numberWithInteger:0];
    
    self.selectNum = 0;
    self.hotButton.selected = YES;
    [self.hotButton setAdjustsImageWhenHighlighted:NO];
    [self.topicButton setAdjustsImageWhenHighlighted:NO];
   // [self.topicButton showsTouchWhenHighlighted]=NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
     self.tabBarController.navigationItem.title  =@"活  动";

    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.showTopicList
    
    if ([[segue identifier] isEqualToString:@"showTopicList"]) {
        
        if (self.selectNum) {
            PROFriendTableViewController *friendTableControl = [segue destinationViewController];
            //self.tableView sele
            friendTableControl.topicNum = [NSNumber numberWithInteger:[self.tableView indexPathForSelectedRow].row+1];
        }
      
        
    }
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
    return  self.selectNum?[self.topicArray count]:[self.hotArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.selectNum?80.0:120.0;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.selectNum?@"topicCell":@"hotCell" forIndexPath:indexPath];
 
     UIImageView *displayImage = (UIImageView *)[cell viewWithTag:1];
     
     displayImage.image = [UIImage imageNamed:self.selectNum?self.topicArray[indexPath.row]:self.hotArray[indexPath.row]];
     
 // Configure the cell...
 
     return cell;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.topicNum = [NSNumber numberWithInteger: indexPath.row+1];
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
- (IBAction)buttonClick:(id)sender {
    
    NSInteger old_select = self.selectNum;
    if (sender == self.hotButton) {
        self.hotButton.selected = YES;
        self.topicButton.selected = NO;
        self.selectNum = 0;
    }
    else
    {
        self.hotButton.selected = NO;
        self.topicButton.selected = YES;
        self.selectNum = 1;
        
    }
    if (old_select != self.selectNum) {
        [self.tableView reloadData];
    }
   // self.selectNum =
}


@end
