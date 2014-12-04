//
//  PROSettingUserEditTableViewController.m
//  promise
//
//  Created by su di on 14-7-27.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROSettingUserEditTableViewController.h"
#import "PROAppDelegate.h"
#import "UIImageView+WebCache.h"
#import "PROEditingSettingViewController.h"
@interface PROSettingUserEditTableViewController ()

@property (weak,nonatomic)PROAppDelegate *appDelegate;
@property (weak,nonatomic) UserInfo *myLoginUser;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logImageView;
@property (strong, nonatomic) IBOutlet UILabel *userSexLabel;
@property (weak,nonatomic)PROMessageData *myMessageData;
@property (strong, nonatomic) IBOutlet UILabel *explainInfo;

@property (strong,nonatomic)UIActionSheet *photoActionsheet ;
@property (strong,nonatomic)UIActionSheet *sexActionSheet ;
@property (strong,nonatomic)UIImage *imageSetting ;

@property (assign,nonatomic)BOOL isEditor;


@property (strong,nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation PROSettingUserEditTableViewController

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
    
    self.isEditor    = false;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.appDelegate = (PROAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.myLoginUser = self.appDelegate.loginUser;
    self.myMessageData  = self.appDelegate.myMessageData;
    
    // [self.myMessageData postLogImg:self.myLoginUser.userid andImageName:@"/Users/sudi/Desktop/1.jpeg"];
    
    
    self.imagePickerController = [[UIImagePickerController alloc]init];
    
    self.imagePickerController.delegate = self;
    
   
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //self.imageCamera.enabled =NO;
        
    }

    
    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initUserInfo];
    self.navigationItem.title = @"编辑个人资料";

}
-(void)viewDidAppear:(BOOL)animated
{
//    if (self.imageSetting) {
//        [self.myMessageData updateUserInfo:self.myLoginUser.account andPassword:self.myLoginUser.password];
//    }
    
}
-(BOOL)initUserInfo
{
    if(self.appDelegate && self.myLoginUser)
    {
        self.userNameLabel.text = self.myLoginUser.username;
        //  self.gradeLabel.text = self.myLoginUser.grade.description;
        
      //  [self.logImageView setOnlineImage:self.myLoginUser.headpicture];
        if (self.imageSetting) {
            [self.logImageView setImage:self.imageSetting];
        }
        else
        {
             NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"userhead.png"];
            
            UIImage *logoImage = [UIImage imageWithContentsOfFile:path];
            if (!logoImage) {
                logoImage = [UIImage imageNamed:@"head.png"];
                
            }
            
            
            [self.logImageView sd_setImageWithURL:[NSURL URLWithString:self.myLoginUser.headpicture] placeholderImage:logoImage];
        }
       // [self.logImageView sd_setImageWithURL:[NSURL URLWithString:self.myLoginUser.headpicture] placeholderImage:[UIImage imageNamed:@"userhead.png"]];
        
         self.userSexLabel.text = self.myLoginUser.sex.integerValue==1?@"男":@"女";
        self.explainInfo.text = self.myLoginUser.explaininfo;
        
        return true;
        
    }
    
    return false;
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //self.imageList.image
   self.imageSetting= info[UIImagePickerControllerOriginalImage];
    //self.imageList.hidden = NO;
//    UIImageView *imageView =info[UIImagePickerControllerOriginalImage];
//    
//    imageView.frame = CGRectMake(12, 12, 44, 44);
    
  //  NSString *imageName = @"userhead.png";
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"userhead.png"];
        UIImage *headImage = [self reSizeImage:self.imageSetting toSize:CGSizeMake(40, 40)];
    
    if (![UIImagePNGRepresentation(headImage) writeToFile:path atomically:YES]) {
        
        int b = 0;
       // continue;
    }
    

   // [self.logImageView setImage:  self.imageSetting];
   // [self.myMessageData postLogImg:self.myLoginUser.userid andImageName:path];
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:  self.appDelegate.HUD];
    
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在保存！";
    [ self.appDelegate.HUD showWhileExecuting:@selector(saveImg:) onTarget:self withObject:path animated:YES];
    
}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

-(void)saveImg:(NSString *)path
{
    
    self.myLoginUser.headpicture = @"";
    [self.myMessageData postLogImg:self.myLoginUser.userid andImageName:path];
    
    [self.myMessageData updateUserInfo:self.myLoginUser.account andPassword:self.myLoginUser.password];

    
 
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return section==0?1:3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {

        //弹出选择框
       self.photoActionsheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                    otherButtonTitles:@"相机拍摄",@"手机相册", nil];
        
        [self.photoActionsheet showInView:self.view];
        
        }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                self.sexActionSheet = [[UIActionSheet alloc]
                                       initWithTitle:nil
                                       delegate:self
                                       cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                       otherButtonTitles:@"男",@"女", nil];
                [self.sexActionSheet showInView:self.view];
                break;
                
            default:
                break;
        }
       

    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == self.photoActionsheet)
    {
        if (buttonIndex == 0) {
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
            }
            
        }
        else if(buttonIndex == 1)
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
            }
        }
    }
    
    if(actionSheet == self.sexActionSheet)
    {
        switch (buttonIndex) {
            case 0:
                self.userSexLabel.text = @"男";
                break;
            case 1:
                self.userSexLabel.text = @"女";
                break;
            default:
                break;
        }
        if ([self.myLoginUser.sex compare:[NSNumber numberWithInteger:(buttonIndex +1)]]!=NSOrderedSame) {
            self.myLoginUser.sex = [NSNumber numberWithInteger:(buttonIndex +1)];
            [self updateUser:nil];
        }
        
    }

    
}

//相机拍摄选取
-(void)photoSelectClick
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }

}






//相册选取


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

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if ([[segue identifier] isEqualToString:@"editUsername"]) {
            
            // hand off the assets of this album to our singleton data source
                      // start viewing the image at the appropriate cell index
            PROEditingSettingViewController *settingViewController = [segue destinationViewController];
          
            settingViewController.loginUser = self.myLoginUser;
             settingViewController.myMessageData = self.myMessageData;
            settingViewController.appDelegate = self.appDelegate;
            settingViewController.editorType = 0;

            self.navigationItem.title = @"";
            
            //pageViewController.
            
        }
    
    if ([[segue identifier] isEqualToString:@"editExplain"]) {
        
        // hand off the assets of this album to our singleton data source
        // start viewing the image at the appropriate cell index
        PROEditingSettingViewController *settingViewController = [segue destinationViewController];
        
        settingViewController.loginUser = self.myLoginUser;
        settingViewController.myMessageData = self.myMessageData;
        settingViewController.appDelegate = self.appDelegate;
        settingViewController.editorType = 1;
        self.navigationItem.title = @"";
        
        //pageViewController.
        
    }
    
    
    
}


- (void)updateUser:(id)sender {
    
    //self.myLoginUser.username = @"dfdfdf";
    
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:  self.appDelegate.HUD];
    
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在保存！";
    [ self.appDelegate.HUD showWhileExecuting:@selector(saveInfo) onTarget:self withObject:nil animated:YES];

    
   
    
}

-(void)saveInfo
{
     [self.myMessageData postUserInfo:self.myLoginUser];
    
    NSError *error;
    if(![[self.appDelegate managedObjectContext] save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
        return;
    }
   // [self.navigationController popViewControllerAnimated:YES];
}

@end
