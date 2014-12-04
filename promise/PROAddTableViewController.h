//
//  PROAddTableViewController.h
//  promise
//
//  Created by su di on 14-7-19.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRODatePickerView.h"
#import "PROAppDelegate.h"
#import "FGalleryViewController.h"
#import "RootViewController.h"
@interface PROAddTableViewController : UITableViewController<UITextViewDelegate,UIGestureRecognizerDelegate,PRODatePickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,FGalleryViewControllerDelegate,AlbumcontentViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *imgCollecitionView;
@property (strong, nonatomic) IBOutlet UIButton *postButton;

@property (weak,nonatomic)PROAppDelegate *appDelegate;
@property  (strong,nonatomic)NSMutableArray *imgList;
//@property (strong, nonatomic) IBOutlet UIImageView *testImg;

@end
