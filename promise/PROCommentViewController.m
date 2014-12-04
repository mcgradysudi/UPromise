//
//  PROCommentViewController.m
//  promise
//
//  Created by su di on 14-8-22.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROCommentViewController.h"

@interface PROCommentViewController ()
@property (strong, nonatomic) IBOutlet UILabel *inputPlaceHold;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation PROCommentViewController

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
    self.commentInputView.layer.borderWidth = 1.0;
    self.commentInputView.layer.borderColor = [[UIColor lightGrayColor] CGColor];;
    if (self.commentDetail) {
        self.replyUsername.text = [NSString stringWithFormat:@"@%@",self.commentDetail.username];
        
    }
    
      [self.commentInputView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
  
      self.commitButton.enabled = NO;
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
- (IBAction)commitComment:(id)sender {
    
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:  self.appDelegate.HUD];
    
    [self.commentInputView resignFirstResponder];
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在处理！";
    [ self.appDelegate.HUD showWhileExecuting:@selector(comment) onTarget:self withObject:nil animated:YES];

    
}

-(void)comment
{
    
  
    if([self.appDelegate.myMessageData postComment:self.commentInputView.text andState:self.viewPromise.promiseid andPid:self.commentid withUserid:self.appDelegate.loginUser.userid andReplyUserid:self.replyid])
    {
        
        NSArray *commentList =[self.appDelegate.myMessageData getComment:self.viewPromise.promiseid];
        if(commentList && [commentList count]>0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self.appDelegate initComment:commentList];
                 [self.navigationController popViewControllerAnimated:YES];
            });
        }
      
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        self.inputPlaceHold.hidden = NO;
        self.commitButton.enabled = NO;
    }
    
    if([textView.text length]<=30)
    {
        self.inputPlaceHold.hidden = YES;
        self.commitButton.enabled = YES;

       
    }
    
}

@end
