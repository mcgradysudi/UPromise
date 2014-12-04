//
//  PROEditingSettingViewController.m
//  promise
//
//  Created by su di on 14-8-17.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROEditingSettingViewController.h"
#import "MBProgressHUD.h"
@interface PROEditingSettingViewController ()


@end

@implementation PROEditingSettingViewController

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
    
    self.usernameLabel.text = (self.editorType == 1?self.loginUser.explaininfo :self.loginUser.username);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = (self.editorType == 1?@"编辑简介":@"编辑昵称");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if ([[segue identifier] isEqualToString:@"showPhoto"]) {
//        
//        // hand off the assets of this album to our singleton data source
//        [PageViewControllerData sharedInstance].photoAssets = self.assets;
//        [PageViewControllerData sharedInstance].selectAssets = self.selectassets;
//        [PageViewControllerData sharedInstance].isFilter = NO;
//        [PageViewControllerData sharedInstance].isOrigin = NO;
//        [PageViewControllerData sharedInstance].isUrlPath = NO;
//        // start viewing the image at the appropriate cell index
//        MyPageViewController *pageViewController = [segue destinationViewController];
//        NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
//        pageViewController.startingIndex = selectedCell.row;
//        //pageViewController.
//        
//    }

    
}
- (IBAction)touchDown:(id)sender {
    
    [self.usernameLabel resignFirstResponder];
}

- (IBAction)saveButton:(id)sender {
    
    
    NSInteger length = [self.usernameLabel.text length];
    if (length==0) {
       UIAlertView* alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，请输入点什么！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [self.usernameLabel becomeFirstResponder];
        return;
    }
    
    if (length<4||length>30) {
        UIAlertView* alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，请输入长度不符合要求！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [self.usernameLabel becomeFirstResponder];
        return;
    }
    
    [self.usernameLabel resignFirstResponder];

    if (self.editorType == 1) {
        self.loginUser.explaininfo = self.usernameLabel.text;

    }
    else
    self.loginUser.username = self.usernameLabel.text;
    
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:  self.appDelegate.HUD];
    
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在保存！";
    [ self.appDelegate.HUD showWhileExecuting:@selector(saveInfo) onTarget:self withObject:nil animated:YES];

    
}


-(void)saveInfo
{
    
    [self.myMessageData postUserInfo:self.loginUser];
    
    
     NSError *error;
     if(![[self.appDelegate managedObjectContext] save:&error])
     {
       // NSLog(@"不能保存：%@",[error localizedDescription]);
        return;
     }
        
        
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
