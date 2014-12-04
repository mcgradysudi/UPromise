//
//  PROLogInViewController.m
//  promise
//
//  Created by su di on 14-7-21.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROLogInViewController.h"
#import "PROMessageData.h"
#import "../Classes/ASIFormDataRequest.h"
#import "AutoCompleteSuffixView.h"

@interface PROLogInViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation PROLogInViewController

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
    self.appDelegate = (PROAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(self.appDelegate.loginUser.isLogin.intValue)
    {
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];

    }
    
    self.title = @"";
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;

    NSArray *suffixs = @[@"163.com", @"qq.com", @"126.com"];
    
    AutoCompleteSuffixView *autoBindUrs = [[AutoCompleteSuffixView alloc] initWithInputField:self.userNameField suffixs:suffixs];
    
    [self.view addSubview:autoBindUrs];
    
    
    //注册监听
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performLoginSucc) name:@"Login_Success" object:nil];
    
    
    self.loginButton.layer.masksToBounds = YES;
    
    self.loginButton.layer.cornerRadius = 15;
    
    self.registerButton.layer.masksToBounds = YES;
    
    self.registerButton.layer.cornerRadius = 15;
    
//    
    
}

-(void)performLoginSucc
{
    [self performSegueWithIdentifier:@"loginSuccess" sender:self];

}
- (IBAction)userNameExit:(id)sender {
    [sender resignFirstResponder];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userNameField resignFirstResponder];
    [self.passwordField  resignFirstResponder];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.userNameField.text = nil;
    self.passwordField.text = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonLogin:(id)sender {
    
    //    ASIFormDataRequest *request;
    //    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://182.92.156.193:8080/Upromise/login!login.action"]];
    //    [request setPostValue:@"657886649@qq.com" forKey:@"account"];
    //    [request setPostValue:@"123456789" forKey:@"password"];
    //
    //    [request setResponseEncoding:NSUTF8StringEncoding];
    //    // [self.request setDelegate:self];
    //    [request startSynchronous];
    //    NSError *error = [request error];
    //    if (!error) {
    //     //   NSString *response = [request responseString];
    //      NSData *data = [request responseData];
    //
    //
    //      NSString *response = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    //
    //
    //        self.erroMessage.text = response;
    //    }

    
    [self.userNameField resignFirstResponder];
    [self.passwordField  resignFirstResponder];
    
    UIAlertView *alter ;
    NSString *username = [self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = self.passwordField.text;
    
    if ([username compare:@""]==NSOrderedSame) {
        
      alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，请输入用户名！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    
    
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:  self.appDelegate.HUD];
	
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在登陆！";
	
	[ self.appDelegate.HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];

    
   
}
- (void)myTask {
	// Do something usefull in here instead of sleeping ...
    
    NSString *username = [self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = self.passwordField.text;
    
    
    if(![self.appDelegate.myMessageData login:username andPassword:password])
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
       
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
        
    }

}
- (IBAction)weiboLogin:(id)sender {
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
    
}
- (IBAction)qqLogin:(id)sender {
    
    
    [self.appDelegate.tencentOAuth authorize:self.appDelegate.permissions inSafari:NO];
    
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


@end
