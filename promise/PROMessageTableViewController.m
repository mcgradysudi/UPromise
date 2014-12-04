//
//  PROMessageTableViewController.m
//  promise
//
//  Created by su di on 14-8-31.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROMessageTableViewController.h"

@interface PROMessageTableViewController ()
@property (nonatomic,strong)NSArray *messageList;
@property (nonatomic,strong)NSArray *messageImage;
@property (nonatomic,strong)NSString *selectTitle;
@property (nonatomic,strong)NSNumber *selectIndex;
@end

@implementation PROMessageTableViewController

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
    //self.messageList = [[NSArray alloc]initWithObjects:@"系统", nil];
    self.selectTitle = @"系统消息";
    self.selectIndex = [NSNumber numberWithInteger:0];
    self.messageList = [[NSArray alloc]initWithObjects:@"系统消息",@"赞",@"炸我的",@"评论",@"我的监督", nil];
    self.messageImage = [[NSArray alloc]initWithObjects:@"systemNews.png", @"praiseMe.png",@"bombNews-44.png",@"commentMe.png",@"inspect-44.png",nil];
    
    
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
    return [self.messageList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.messageList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.messageImage[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    // Configure the cell...
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectTitle = self.messageList[indexPath.row];
    self.selectIndex = [NSNumber numberWithInteger: indexPath.row];
    [self performSegueWithIdentifier:@"showDetailMessage" sender:self];
}
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
    if ([[segue identifier] isEqualToString:@"showDetailMessage"]) {
        
        // hand off the assets of this album to our singleton data source
     
                // start viewing the image at the appropriate cell index
        PRODetailMessageTableViewController *pageViewController = [segue destinationViewController];
        pageViewController.title = self.selectTitle;
        pageViewController.messageType = self.selectIndex;
        pageViewController.messageImageList = self.messageImage;
               //pageViewController.
        
    }

}


@end
