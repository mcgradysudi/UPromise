//
//  PRORegisterTableViewController.m
//  promise
//
//  Created by su di on 14-7-21.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PRORegisterTableViewController.h"
#import "PROMessageData.h"
#import "../Classes/ASIFormDataRequest.h"
#import "AutoCompleteSuffixView.h"

@interface PRORegisterTableViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *passwordConfirmField;

@end

@implementation PRORegisterTableViewController

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
    
    NSArray *suffixs = @[@"163.com", @"qq.com", @"126.com"];
    
    AutoCompleteSuffixView *autoBindUrs = [[AutoCompleteSuffixView alloc] initWithInputField:self.userNameField suffixs:suffixs];
    
    [self.view addSubview:autoBindUrs];
    
    [self.userNameField becomeFirstResponder];
    
    self.appDelegate = (PROAppDelegate *)[[UIApplication sharedApplication] delegate];

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}


- (IBAction)finishTap:(id)sender {
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userNameField resignFirstResponder];
    [self.passwordField  resignFirstResponder];
    [self.passwordConfirmField  resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerClick:(id)sender {
    
    [self.userNameField resignFirstResponder];
    [self.passwordField  resignFirstResponder];
    [self.passwordConfirmField  resignFirstResponder];
    UIAlertView *alter ;
    NSString *username = [self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = self.passwordField.text;
    NSString *password_confirm = self.passwordConfirmField.text;
    if ([username compare:@""]==NSOrderedSame) {
        
        alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，请输入邮箱账号！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [self.userNameField becomeFirstResponder];
        return;
        
    }
    
    if ([password compare:@""]==NSOrderedSame) {
        
        alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，请输入密码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [self.passwordField becomeFirstResponder];
        return;
        
    }
    
    if ([password length]<6||[password length]>20) {
        
        alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，密码长度不符合要求！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [self.passwordField becomeFirstResponder];
        return;
        
    }
    if ([password compare:password_confirm]!=NSOrderedSame) {
        
        alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，2次输入的密码要一样啊！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [self.passwordField becomeFirstResponder];
        return;
        
    }
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:  self.HUD];
	
    self.HUD.delegate = self;
    self.HUD.labelText = @"正在注册中！";
	
	[ self.HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    

    
}

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
    
    NSString *username = [self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = self.passwordField.text;
    
  //  PROMessageData *myData = [[PROMessageData alloc]init];
    
    if(![self.appDelegate.myMessageData registerCount:username andPassword:password])
    {
        
        UIAlertView *alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:self.appDelegate.myMessageData.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        
        //        self.erroMessage.text = myData.message;
        //
        //        [self.erroMessage setHidden:NO];
    }
    else
    {
        //进入
        [self performSegueWithIdentifier:@"registerSuccess" sender:self];
        
    }
    
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
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
