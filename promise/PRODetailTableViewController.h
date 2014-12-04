//
//  PRODetailTableViewController.h
//  promise
//
//  Created by su di on 14-7-30.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Promise.h"
#import "PROAppDelegate.h"
#import "AlbumContentsViewController.h"
#import "LXActivity.h"

@interface PRODetailTableViewController : UITableViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,AlbumcontentViewDelegate,NSFetchedResultsControllerDelegate,LXActivityDelegate>
@property(weak,nonatomic) Promise *viewPromise;
@property (strong, nonatomic) IBOutlet UICollectionView *imgListCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *proveImgListCollection;
@property (strong,nonatomic) PROAppDelegate* appDelegate;
@property (strong,nonatomic)UIImagePickerController *  imagePickerController;
@property (assign,nonatomic)BOOL isFriendDetail;
@property (strong, nonatomic) IBOutlet UITableViewCell *commentCell;

@property (strong,nonatomic)NSFetchedResultsController *resultFetch;

@end
