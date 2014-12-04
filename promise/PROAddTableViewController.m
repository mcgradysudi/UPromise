//
//  PROAddTableViewController.m
//  promise
//
//  Created by su di on 14-7-19.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROAddTableViewController.h"
#import "RBCustomDatePickerView.h"  
#import "PRODatePickerView.h"
#import "PROTableViewCell.h"
#import "Promise.h"
#import "KGStatusBar.h"
#import "RootViewController.h"
#import "PageViewControllerData.h"
#import "MyPageViewController.h"
#import "ImageList.h"
#import "PROFriendListTableViewController.h"
#import "UIImageView+WebCache.h"
#import "FriendList.h"
@interface PROAddTableViewController ()
@property (strong,nonatomic) PRODatePickerView *pickerView;
@property (strong,nonatomic) NSDate *pro_creattime;
@property (strong,nonatomic) NSDate *pro_edntime;
@property (strong, nonatomic) IBOutlet UILabel *textViewLabel;
@property (strong, nonatomic) IBOutlet UILabel *textCountLabel;
@property (strong, nonatomic) IBOutlet UITextView *promiseInputView;
@property (strong, nonatomic) IBOutlet UILabel *seeRangeLabel;
@property (strong,nonatomic)Promise *addPromise;
@property (strong,nonatomic)UIImagePickerController *  imagePickerController;
@property (strong,nonatomic) NSArray *localImages;
@property (strong,nonatomic) NSArray *topicList;

@property (strong, nonatomic) IBOutlet UILabel *startdateLabel;
@property (strong, nonatomic) IBOutlet UILabel *enddateLabel;
@property (strong,nonatomic) FGalleryViewController *localGallery;
@property (strong, nonatomic) IBOutlet UILabel *punishLabel;
@property (strong, nonatomic) IBOutlet UIImageView *addImageView;
@property (strong, nonatomic) IBOutlet UIButton *punishButton;
@property (strong,nonatomic)NSArray *punishList;
//@property (strong, nonatomic) IBOutlet UILabel *friendLabel;
@property (strong, nonatomic) IBOutlet UIButton *topicButton;
@property (strong, nonatomic) IBOutlet UICollectionView *friendCollectionView;
@property (strong,nonatomic)NSMutableArray *selectedFriends;
@end

@implementation PROAddTableViewController

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
    
    //RBCustomDatePickerView *pickerView = [[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    //[self.view addSubview:pickerView];
    self.pickerView = [PRODatePickerView view];
    
    //  UIViewController *temp = [[UIViewController alloc]initWithNibName:@"datepickerview" bundle:nil];
    self.pickerView.frame =CGRectMake(0, 300, 320, 268);
    self.promiseInputView.delegate = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
//    
   tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
  [self.tableView addGestureRecognizer:tapRecognizer];
    
    self.appDelegate = (PROAppDelegate *)[[UIApplication sharedApplication]delegate];
    
   
    
    self.addPromise = [NSEntityDescription insertNewObjectForEntityForName:@"Promise" inManagedObjectContext:[self.appDelegate managedObjectContext]];
   
    self.imagePickerController = [[UIImagePickerController alloc]init];
   // self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    
    self.localImages = [[NSArray alloc] initWithObjects: @"bomb.png", @"local.png", nil];
    self.punishList = [[NSArray alloc] initWithObjects:@"请监督人吃饭",@"做50个俯卧撑", @"一周不吃肉", @"洗碗一个月", @"洗衣服一个月", @"不惩罚", nil];
    self.topicList = [[NSArray alloc]initWithObjects:@"减肥",@"健身", @"我戒",@"英语",@"旅行",@"交友",@"表白", nil];
    self.postButton.enabled = false;
    
    self.pro_creattime = [NSDate date];
    self.pro_edntime =[[NSDate date] dateByAddingTimeInterval:60*60*24*7];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.startdateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    self.enddateLabel.text = [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*7]];
    
    self.imgList = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                              action:@selector(handleImgTap:)];
    singleTap.delegate = self;
    [self.imgCollecitionView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.selectedFriends = [[NSMutableArray alloc]init];
}

#pragma keyboardshow
-(void)keyboardWillShow:(NSNotification*) aNotification
{
    if ([self.pickerView superview]) {
        [self.pickerView removeFromSuperview];
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    //NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    
    [self.promiseInputView resignFirstResponder];
    if ([self.pickerView superview]) {
        [self.pickerView removeFromSuperview];
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
    return 6;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.promiseInputView resignFirstResponder];
    
    switch (indexPath.section) {
        case 1:
        case 2:
            if(![self.pickerView superview])
                [self.view addSubview:self.pickerView];
            self.pickerView.delegate = self;

            return;
        case 3:break;
        case 4:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"公开程度"
                                              delegate:self
                                              cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"公开",@"保密", nil];
            
                [actionSheet showInView:self.tableView];
        }
            break;
        case 5:
        default:
            break;
    }
    
        
    if ([self.pickerView superview]) {
            [self.pickerView removeFromSuperview];
        }
    
    
            
        

    
}

-(void)selectRow:(NSDate *)selectDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:selectDate];
    //NSLog(@"%@", strDate);
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

   // PROTableViewCell *cell = (PROTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
   // cell.detailTime.text=    strDate;
    
    switch (indexPath.section) {
        case 1:self.startdateLabel.text = strDate;
            self.pro_creattime = selectDate;
            break;
        case 2:self.enddateLabel.text = strDate;
            self.pro_edntime = selectDate;
            break;
        default:break;
    }

    
}
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
   if ([[segue identifier] isEqualToString:@"chooseFirend"]) {

       PROFriendListTableViewController *viewController = [segue destinationViewController];
       viewController.selectFriends = self.selectedFriends;
       viewController.isCheckView = YES;
       
    }
}



- (void)textViewDidChange:(UITextView *)textView
{
    
    if([textView.text length] == 0)
    {
        self.textViewLabel.hidden = NO;
        self.postButton.enabled = false;
    }
  
    if([textView.text length]<=30)
    {
        self.textViewLabel.hidden = YES;
        self.textCountLabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)[textView.text length]];
        self.postButton.enabled = true;
    }
  
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text compare:@""]!=NSOrderedSame &&[textView.text length]>29)
        return NO;
    return YES;
}
- (IBAction)postButtonClick:(id)sender {
    
    //判断时间
     [self.promiseInputView resignFirstResponder];
    if (self.pro_edntime == [self.pro_edntime earlierDate:self.pro_creattime]) {
        UIAlertView*  alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，结束时间不能早于开始时间!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    
 
 
    self.addPromise.pro_content = self.promiseInputView.text;
    
    if (self.addPromise.topic.integerValue >0 ) {
     
        NSString *topicValue = [NSString stringWithFormat:@"#%@#",self.topicList[self.addPromise.topic.integerValue -1]];
        
        self.addPromise.pro_content = [self.addPromise.pro_content stringByAppendingString:topicValue];
        
    }
    
    self.addPromise.user = self.appDelegate.loginUser;
    
    self.addPromise.create_date = [NSDate date];
    self.addPromise.end_date = self.pro_edntime;
    self.addPromise.due_date = self.pro_edntime;;
    self.addPromise.start_date = self.pro_creattime;
    self.addPromise.user_id = self.appDelegate.loginUser.userid;
    
    self.addPromise.username = self.appDelegate.loginUser.username;
    self.addPromise.headpicture = self.appDelegate.loginUser.headpicture;

    self.addPromise.promiseid = [NSNumber numberWithInteger:99999];
    
    self.addPromise.user = self.appDelegate.loginUser;
    if ([self.selectedFriends count]>0) {
        NSMutableString *watchman=[[NSMutableString alloc]init];
        for (FriendList *friend in self.selectedFriends) {
            [watchman appendString:friend.userid.description];
            [watchman appendString:@";"];
            friend.isSelected = NO;
        }
        self.addPromise.watchman = watchman;
    }
    else
        self.addPromise.watchman = @"";
    
   
    if ([self.imgList count]>0) {
        for (UIImage *tempImg in self.imgList) {
            
            ImageList *imgList = [NSEntityDescription insertNewObjectForEntityForName:@"ImageList" inManagedObjectContext:[self.appDelegate managedObjectContext]];
            
            NSString *imageName = [NSString stringWithFormat:@"%lld.jpg",(int64_t)([[NSDate date]timeIntervalSince1970]*1000.0)];
            NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:imageName];
           // NSLog(@"save %f path=%@",[[NSDate date]timeIntervalSince1970]*1000.0,path);
            imgList.promise = self.addPromise;
            imgList.imagepath = path;
            
            //NSLog(@"save2 %@",path);
            //UIImage *resizeImg = [self reSizeImage:tempImg toSize:CGSizeMake(50, 55)];
            
            
         //   NSData *imageData = UIImageJPEGRepresentation(tempImg , 0.75);
            
            if (![UIImageJPEGRepresentation(tempImg , 0.65) writeToFile:path atomically:YES]) {
                
                continue;
            }
            
            
            
            
        }
        
        //        NSError *error;
        //        if(![[self.appDelegate managedObjectContext] save:&error])
        //        {
        //            NSLog(@"不能保存：%@",[error localizedDescription]);
        //            return;
        //        }
        
        
    }
    
    
   // [self saveImgList];
    
    //提交网络
   
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self saveImgList];
//        [self.appDelegate.myMessageData postPromise:self.addPromise];
//    });
    // [KGStatusBar showSuccessWithStatus:@"正在提交！"];
    
    
  
    
    self.appDelegate.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
	[self.tableView addSubview:  self.appDelegate.HUD];
    
    self.appDelegate.HUD.delegate = self;
    self.appDelegate.HUD.labelText = @"正在处理！";
    [ self.appDelegate.HUD showWhileExecuting:@selector(saveImgList) onTarget:self withObject:nil animated:YES];
    
  
    
    return;
    
   
    
}
-(void)initActionSheet:(NSArray *)arrayTitle
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"惩罚措施"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    for (NSString *title in arrayTitle) {
        [actionSheet addButtonWithTitle:title];

    }
   // actionSheet cancelButtonIndex
     [actionSheet showInView:self.tableView];
}
- (IBAction)bombClick:(id)sender {
    
    [self initActionSheet:self.punishList];
    
    
}
- (IBAction)topicClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"主题"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"减肥",@"健身", @"我戒",@"英语",@"旅行",@"交友",@"表白",nil];
    
    [actionSheet showInView:self.tableView];

}
- (IBAction)picClick:(id)sender {
    
    [self resignResponder];
    if ([self.imgList count]>=4) {
        UIAlertView*  alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，最多添加4个相片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"相片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相机拍摄",@"手机相册", nil];
    
    [actionSheet showInView:self.tableView];
    
}
-(void)resignResponder
{
    [self.promiseInputView resignFirstResponder];
    [self.pickerView resignFirstResponder];
}
- (IBAction)emotionClick:(id)sender {
    
 //   self.localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
  //  [self.navigationController pushViewController:self.localGallery animated:YES];
    RootViewController *myRootViewController =     [self.storyboard instantiateViewControllerWithIdentifier:@"photoRootView"];;
    [self.navigationController  pushViewController:myRootViewController animated:YES];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [PageViewControllerData sharedInstance].photoAssets = nil;
    if ([self.selectedFriends count]>0) {
                 //  self.friendLabel.text = userName;
        [self.friendCollectionView reloadData];
        
    }
    
   
}

-(void)viewDidAppear:(BOOL)animated
{
     //[self.promiseInputView becomeFirstResponder];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //self.imageList.image = info[UIImagePickerControllerOriginalImage];
    //self.imageList.hidden = NO;
    
   // UIImageView *imageView =[[UIImageView alloc]initWithImage:info[UIImagePickerControllerOriginalImage]];
    
//    UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    sampleButton.frame = CGRectMake(12, 52, 68, 72);
//    
//    [sampleButton setBackgroundImage:[info[UIImagePickerControllerOriginalImage]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
//    
//    [sampleButton setAdjustsImageWhenHighlighted:NO];
    //[sampleButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    //
    //imageView.frame = CGRectMake(12, 52, 68, 72);
  //  [self.promiseInputView addSubview:sampleButton];
    
    [self.imgList addObject:info[UIImagePickerControllerOriginalImage]];
    [self.imgCollecitionView reloadData];
    UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([actionSheet.title compare:@"相片来源"]==NSOrderedSame)
    {
        if (buttonIndex == 0) {
            
            [self photoSelectClick];
            
        }
        else if (buttonIndex == 1)
        {
            [self photoLabraryClick];
        }
    }
    
    if([actionSheet.title compare:@"惩罚措施"]==NSOrderedSame)
    {
        if (buttonIndex == -1) {
            
        }
        else if(buttonIndex<[self.punishList count])
        {
            self.punishLabel.text = self.punishList[buttonIndex];
            self.addPromise.punish = self.punishLabel.text;
            [self.punishButton setTitle:@"" forState:UIControlStateNormal] ;
            
        }
        
    }
    
    if([actionSheet.title compare:@"公开程度"]==NSOrderedSame)
    {

        if (buttonIndex == 0) {
            self.seeRangeLabel.text = @"公开";

        }
        else
        {
            self.seeRangeLabel.text = @"保密";

        }
        
        self.addPromise.visiable_scope = [NSNumber numberWithInteger:buttonIndex];
        
        
        
    }
    
    
    if([actionSheet.title compare:@"主题"]==NSOrderedSame)
    {
        
        if (buttonIndex == -1) {
            
        }
        else if(buttonIndex<[self.punishList count])
        {
           // self.punishLabel.text = self.topicList[buttonIndex];
            [self.topicButton setTitle:self.topicList[buttonIndex] forState:UIControlStateNormal ];
            self.addPromise.topic = [NSNumber numberWithInteger:buttonIndex+1];
            //self.promiseInputView.text = self.promiseInputView.
        }
        
        
        
        
        
    }
    
    
    if ([actionSheet.title compare:@"确定放弃此次编辑？"]==NSOrderedSame) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];

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

- (void)photoLabraryClick
{
    
  //  self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
  //  [self presentViewController:self.imagePickerController animated:YES completion:nil];
    RootViewController *myRootViewController =     [self.storyboard instantiateViewControllerWithIdentifier:@"photoRootView"];
    myRootViewController.popToViewController = self;
    [self.navigationController  pushViewController:myRootViewController animated:YES];

}

//uiactiondelegate


#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    if( gallery == self.localGallery ) {
        num = [self.localImages count];
    }
//    else if( gallery == networkGallery ) {
//        num = [networkImages count];
   // }
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	if( gallery == self.localGallery ) {
		return FGalleryPhotoSourceTypeLocal;
	}
	else return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == self.localGallery ) {
        caption = @"erwe";
    }
//    else if( gallery == networkGallery ) {
//        caption = [networkCaptions objectAtIndex:index];
//    }
	return caption;
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [self.localImages objectAtIndex:index];
}

//- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
//    return [networkImages objectAtIndex:index];
//}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}

-(void)setImageList:(NSArray *)imageList
{
    
    [self.imgList addObjectsFromArray:imageList];
    [self.imgCollecitionView reloadData];
    self.imgCollecitionView.hidden = false;
    
//    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"image.png"];
//
//    [UIImagePNGRepresentation(self.imgList[0]) writeToFile:path atomically:YES];
//    
//    self.testImg.image = [[UIImage alloc] initWithContentsOfFile:path];

//    ALAsset *photoAsset =  imageList[0];
//   // ALAsset *asset = self.assets[indexPath.row];
//    CGImageRef thumbnailImageRef = [photoAsset thumbnail];
//    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
//    //  ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
//    //
//   //  UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
//    //                                                           scale:[assetRepresentation scale]
//    //                                                    orientation:ALAssetOrientationUp];
//    self.addImageView.image = thumbnail;
}

//collectiondelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (view.tag == 1) {
        return [self.selectedFriends count];
    }
    return [self.imgList count]>=4?4:[self.imgList count]+1;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    static NSString *FriendCellIdentifier = @"friendCell";
    UICollectionViewCell *cell;
    
    //   NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",[indexPath section], (long)[indexPath row]];
    if (cv.tag == 1) {
        cell =  [cv dequeueReusableCellWithReuseIdentifier:FriendCellIdentifier forIndexPath:indexPath];
        
        UIImageView *firendImageView =(UILabel *)[cell viewWithTag:kImageViewTag];
        FriendList *friend = self.selectedFriends[indexPath.row];

      //  friendLabel.text = friend.username;
//        UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
//        
        //NSString *url = self.selectedFriends[indexPath.row];
        [firendImageView sd_setImageWithURL:[NSURL URLWithString:friend.headpicture] placeholderImage:[UIImage imageNamed:@"head.png"]];
//        
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = 20;
//        CGColorRef cgColor = [UIColor lightGrayColor].CGColor;
//        imageView.layer.borderColor = cgColor;
//        imageView.layer.borderWidth = 1.8;
        
    }
    else
    {
        cell =  [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
        if (indexPath.row == [self.imgList count]) {
            imageView.image = [UIImage imageNamed:@"addImg.png"];
        }
        else if(indexPath.row <[self.imgList count])
        {
//        ALAsset *asset = self.imgList[indexPath.row];
//        CGImageRef thumbnailImageRef = [asset thumbnail];
//        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
//        
//        imageView.image = thumbnail;
        
        imageView.image = [self reSizeImage:self.imgList[indexPath.row] toSize:imageView.frame.size ];
        }
    // load the asset for this cell
    }
    //
    return cell;
}
- (IBAction)backButtonClick:(id)sender {
    
    [self.promiseInputView resignFirstResponder];
    if ([self.imgList count]>0
        ||[self.promiseInputView.text length]>0
        ) {
      
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定放弃此次编辑？"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确定",nil
                                      ];
        [actionSheet showInView:self.tableView];
       
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)handleImgTap:(UITapGestureRecognizer *)recognizer{
    
    
   
    
    NSIndexPath *selectPath =[self.imgCollecitionView indexPathForItemAtPoint:[recognizer locationInView:self.imgCollecitionView]];
    
    if (!selectPath) {
        return  ;
    }
   
    
    if (selectPath.row == [self.imgList count]) {
        [self picClick:nil];
        
    }
    else if(selectPath.row <[self.imgList count])
    {
        [PageViewControllerData sharedInstance].isOrigin = YES;
        [PageViewControllerData sharedInstance].photoAssets = self.imgList;
         [PageViewControllerData sharedInstance].isUrlPath = NO;
        //[PageViewControllerData sharedInstance].selectAssets = self.selectassets;
        // start viewing the image at the appropriate cell index
        MyPageViewController *pageViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"MypageViewController"];
        //NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
        pageViewController.startingIndex = selectPath.row ;
        pageViewController.checkButton.hidden = YES;
        [self.navigationController pushViewController:pageViewController animated:YES];
    }
    
    
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}




-(void)saveImgList
{
   
   
    if ([self.appDelegate.myMessageData postPromise:self.addPromise]) {
        
        [self.appDelegate.myMessageData getPromiseDetail:self.addPromise.promiseid anduserid:self.addPromise.user_id];

    }
    
    NSError *error;
    if(![[self.appDelegate managedObjectContext] save:&error])
    {
       // NSLog(@"不能保存：%@",[error localizedDescription]);
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
