//
//  PROAppDelegate.h
//  promise
//
//  Created by su di on 14-7-18.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PROMessageData.h"
#import "PROMessageDelegate.h"
#import "MBProgressHUD.h"
#import "UserInfo.h"

//#import "UIImageView+OnlineImage.h"


@interface PROAppDelegate : UIResponder <UIApplicationDelegate,PROMessageDelegate,TencentSessionDelegate,WeiboSDKDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

//coredata
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic)PROMessageData *myMessageData;
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (strong,nonatomic) UserInfo *loginUser;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) TencentOAuth* tencentOAuth;
@property (strong, nonatomic) NSMutableArray* permissions;
- (void)saveContext;

-(Promise *)findPromise:(NSInteger)promiseId;
@end
