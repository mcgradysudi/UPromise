//
//  PROSettingTableViewController.m
//  promise
//
//  Created by su di on 14-7-19.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROSettingTableViewController.h"
#import "PROAppDelegate.h"
#import "UIImageView+WebCache.h"
#import "PROLogInViewController.h"
@interface PROSettingTableViewController ()
@property (weak,nonatomic)PROAppDelegate *appDelegate;
@property (weak,nonatomic) UserInfo *myLoginUser;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logImageView;
@property (weak,nonatomic)PROMessageData *myMessageData;
@end

@implementation PROSettingTableViewController

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
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    self.appDelegate = (PROAppDelegate *)[[UIApplication sharedApplication]delegate];

    self.myLoginUser = self.appDelegate.loginUser;
    self.myMessageData  = self.appDelegate.myMessageData;
    
    // [self.myMessageData postLogImg:self.myLoginUser.userid andImageName:@"/Users/sudi/Desktop/1.jpeg"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initUserInfo) name:@"refresh_user" object:nil];
    
   // if (ios_version>=7.0) {
            //}
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.tabBarItem.badgeValue = @"10";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
     self.tabBarController.navigationItem.title  = @"设  置";
    
    
    [self initUserInfo];

    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)initUserInfo
{
    if(self.appDelegate && self.myLoginUser)
    {
        self.userNameLabel.text = self.myLoginUser.username;
      //  self.gradeLabel.text = self.myLoginUser.grade.description;
        
      //  [self.logImageView setOnlineImage:self.myLoginUser.headpicture];
         NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"userhead.png"];
        
        UIImage *logoImage = [UIImage imageWithContentsOfFile:path];
        if (!logoImage) {
            logoImage = [UIImage imageNamed:@"head.png"];
            
        }
        [self.logImageView sd_setImageWithURL:[NSURL URLWithString:self.myLoginUser.headpicture] placeholderImage:logoImage];

        return true;
        
    }
    
    return false;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return section==0?1:3;
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ==0 ?15:5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
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
    if ([[segue identifier] isEqualToString:@"logout"]) {
        
        // hand off the assets of this album to our singleton data source
        self.myLoginUser.isLogin = [NSNumber numberWithInteger:0];
        [self.appDelegate saveContext];
        
        
        // start viewing the image at the appropriate cell index
     
        //pageViewController.
        
    }

}
- (IBAction)logoutClick:(id)sender {
    
    self.myLoginUser.isLogin = [NSNumber numberWithInteger:0];
    [self.appDelegate saveContext];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}


@end
