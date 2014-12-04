//
//  PROAppDelegate.m
//  promise
//
//  Created by su di on 14-7-18.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROAppDelegate.h"
#import "FriendList.h"
#import "Comment.h"
@implementation PROAppDelegate


@synthesize managedObjectContext = _managedObjectContext;

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    [WXApi registerApp:weixinAppKey withDescription:@"2.0"];
   
    
    
    self.permissions = [NSMutableArray arrayWithObjects:
                         @"get_user_info", @"get_simple_userinfo", @"add_t",
                         nil];
    self.tencentOAuth.redirectURI = @"www.qq.com";
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"222222" andDelegate:self];
    
    self.myMessageData = [[PROMessageData alloc]init];
    self.myMessageData.appDelegate = self;

    [self findIsLogin];
    
        
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)insertTaskDetailCoreData
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    UserInfo *contactInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:context];
    contactInfo.username = @"name B";
 //   contactInfo.taskCreatTime = [NSDate date];
    // contactInfo.
    
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
}


-(BOOL)findIsLogin
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"isLogin==1"];
    
    [fetchRequest setPredicate:selectPredict];
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    if([result count]>0)
    {
        self.loginUser = (UserInfo *)result[0];
        //self.myMessageData.username
        return YES;
        
    }
    
    return NO;
    
    
}

-(Comment *)findCommentFromId:(NSInteger)commentid andpromiseid:(NSInteger) promiseid
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"co_id==%d AND promiseid==%d",commentid,promiseid];
    
    [fetchRequest setPredicate:selectPredict];
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    if([result count]>0)
    {
        
        return  (Comment *)result[0];
        
    }
    
    return nil;
    
    
}

-(FriendList *)findFriendId:(NSInteger)userid andfriendid:(NSInteger) ownFirendid
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FriendList" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"userid==%d AND ownFriendid==%d",userid,ownFirendid];
    
    [fetchRequest setPredicate:selectPredict];
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    if([result count]>0)
    {
       
        return  (FriendList *)result[0];
        
    }
    
    return nil;

    
}
-(BOOL)findUserId:(NSInteger)userid
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"userid==%d",userid];
    
   [fetchRequest setPredicate:selectPredict];
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    if([result count]>0)
    {
        self.loginUser = (UserInfo *)result[0];
        return YES;
        
    }
    
    return NO;

    
}

-(Promise *)findPromise:(NSInteger)promiseId
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Promise" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *selectPredict = [NSPredicate predicateWithFormat:@"promiseid==%d",promiseId];
    
    [fetchRequest setPredicate:selectPredict];
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    if([result count]>0)
    {
        return  (Promise *)result[0];
       // return YES;
        
    }
    
    return nil;
    
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      [self saveContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"userInfo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"userInfo.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


-(void)initUserInfo:(NSDictionary *)userJson
{
    if (!userJson)  return;
    
    NSNumber *userid= [userJson objectForKey:@"userId"];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(userid)
    {
        if(![self findUserId:[userid integerValue]])
        {
            self.loginUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:context];
        }
    }
    
    
    
   

        self.loginUser.username = [userJson objectForKey:@"username"];
        self.loginUser.userid = userid;
        self.loginUser.grade = [userJson objectForKey:@"grade"];
    self.loginUser.account =[(NSString *)[userJson objectForKey:@"account"] compare:@""]==NSOrderedSame?[userJson objectForKey:@"username"]:[userJson objectForKey:@"account"];
        self.loginUser.password = [userJson objectForKey:@"password"];
        NSString *number =[userJson objectForKey:@"sex"];
   
        self.loginUser.sex = [number compare:@"2"]==NSOrderedSame?[NSNumber numberWithInteger:2]:[NSNumber numberWithInteger:1];
        self.loginUser.isLogin = [[NSNumber alloc]initWithBool:YES];
        self.loginUser.headpicture =[NSString stringWithFormat:@"%@/Upromise/Image/%@",HOST,[userJson objectForKey:@"headPicture"]];
        self.loginUser.explaininfo = [userJson objectForKey:@"explainInfo"];
    
    
        [self.myMessageData setUsername:self.loginUser.account];
        [self.myMessageData setPassword:self.loginUser.password];
        
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }

    
    
}

-(void)updateUserInfo:(NSDictionary *)userJson
{
    if (!userJson)  return;
    
   // NSNumber *userid= [userJson objectForKey:@"userId"];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(self.loginUser)
    {
        self.loginUser.username = [userJson objectForKey:@"username"];
        //self.loginUser.userid = userid;
        self.loginUser.grade = [userJson objectForKey:@"grade"];
       // self.loginUser.account =[(NSString *)[userJson objectForKey:@"account"] compare:@""]==NSOrderedSame?[userJson objectForKey:@"username"]:[userJson objectForKey:@"account"];
       // self.loginUser.password = [userJson objectForKey:@"password"];
        NSString *number =[userJson objectForKey:@"sex"];
    
        self.loginUser.sex = [number compare:@"2"]==NSOrderedSame?[NSNumber numberWithInteger:2]:[NSNumber numberWithInteger:1];
        self.loginUser.isLogin = [[NSNumber alloc]initWithBool:YES];
        self.loginUser.headpicture =[NSString stringWithFormat:@"%@/Upromise/Image/%@",HOST,[userJson objectForKey:@"headPicture"]];
        self.loginUser.explaininfo = [userJson objectForKey:@"explainInfo"];
    
    
    
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    
    }
    
}

-(BOOL)initComment:(NSArray *)commentJson
{
    if (!commentJson || ![commentJson respondsToSelector:@selector(count)]) {
        return NO;
    }
    BOOL isNew = NO;
    for (NSDictionary *tmp_comment in commentJson) {
        
        NSNumber* commentid = (NSNumber *)[tmp_comment objectForKey:@"id"];
        NSNumber *promiseid = (NSNumber *)[tmp_comment objectForKey:@"promiseId"];
        Comment *addComment = [self findCommentFromId:commentid.integerValue andpromiseid:promiseid.integerValue];
        if (!addComment) {
            addComment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:[self managedObjectContext]];
            isNew = YES;
            
        }
        
        addComment.userid = [tmp_comment objectForKey:@"userId"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];

        
        addComment.promiseid = promiseid;
        addComment.co_id = commentid;
        addComment.co_content = [tmp_comment objectForKey:@"content"];
        addComment.create_time = [dateFormatter dateFromString:[tmp_comment objectForKey:@"createTime"]];
        addComment.headpicture = [NSString stringWithFormat:IMAGEURL,[tmp_comment objectForKey:@"headPicture"]];
        addComment.username = [tmp_comment objectForKey:@"userName"];
        addComment.replyname =[tmp_comment objectForKey:@"replyName"];
        addComment.replyuserid = [tmp_comment objectForKey:@"replyUserId"];
        addComment.co_pid = [tmp_comment objectForKey:@"pid"];
        // friend.account =[(NSString *)[userJson objectForKey:@"account"] compare:@""]==NSOrderedSame?[userJson objectForKey:@"username"]:[userJson objectForKey:@"account"];
        // self.loginUser.password = [userJson objectForKey:@"password"];
//        NSString *number =[tmp_promise objectForKey:@"sex"];
//        
//        friend.sex = [number compare:@"2"]==NSOrderedSame?[NSNumber numberWithInteger:2]:[NSNumber numberWithInteger:1];
//        //   self.loginUser.isLogin = [[NSNumber alloc]initWithBool:YES];
//        friend.headpicture =[NSString stringWithFormat:@"%@/Upromise/Image/%@",HOST,[tmp_promise objectForKey:@"headPicture"]];
//        friend.explaininfo = [tmp_promise objectForKey:@"explainInfo"];
//        
//        
//        friend.ownFriendid = self.loginUser.userid;
        NSError *error;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
            return  NO;
        }
        
    }
    
    return isNew;
    
}

-(void)initFriendInfo:(NSArray *)userJson
{
    if (!userJson || ![userJson respondsToSelector:@selector(count)]) {
        return;
    }
     for (NSDictionary *tmp_promise in userJson) {
         
         NSNumber* userId = (NSNumber *)[tmp_promise objectForKey:@"userId"];
         FriendList *friend = [self findFriendId:userId.integerValue  andfriendid:self.loginUser.userid.integerValue];
         if (!friend) {
             friend = [NSEntityDescription insertNewObjectForEntityForName:@"FriendList" inManagedObjectContext:[self managedObjectContext]];

         }
         
         friend.username = [tmp_promise objectForKey:@"username"];
         friend.userid = userId;
         friend.grade = [tmp_promise objectForKey:@"grade"];
        // friend.account =[(NSString *)[userJson objectForKey:@"account"] compare:@""]==NSOrderedSame?[userJson objectForKey:@"username"]:[userJson objectForKey:@"account"];
        // self.loginUser.password = [userJson objectForKey:@"password"];
         NSString *number =[tmp_promise objectForKey:@"sex"];
         
         friend.sex = [number compare:@"2"]==NSOrderedSame?[NSNumber numberWithInteger:2]:[NSNumber numberWithInteger:1];
      //   self.loginUser.isLogin = [[NSNumber alloc]initWithBool:YES];
         friend.headpicture =[NSString stringWithFormat:IMAGEURL,[tmp_promise objectForKey:@"headPicture"]];
         friend.explaininfo = [tmp_promise objectForKey:@"explainInfo"];
         
         
         friend.ownFriendid = self.loginUser.userid;
         NSError *error;
         if(![self.managedObjectContext save:&error])
         {
             NSLog(@"不能保存：%@",[error localizedDescription]);
         }
         
     }
    
}
-(BOOL)initPromiseSize:(NSDictionary *)promiseSize andUserId:(NSNumber *)userId
{
    if (!promiseSize) {
        return NO;
    }
    if ([userId compare:self.loginUser.userid]==NSOrderedSame) {
        self.loginUser.successsize = [promiseSize objectForKey:@"successSize"];
        
        self.loginUser.totalsize = [promiseSize objectForKey:@"totalSize"];
        self.loginUser.watchsize = [promiseSize objectForKey:@"watchSize"];
    }
    else{
        
        FriendList *friend = [self findFriendId:userId.integerValue  andfriendid:self.loginUser.userid.integerValue];
        if (friend) {
            
            friend.successsize = [promiseSize objectForKey:@"successSize"];
            
            friend.totalsize = [promiseSize objectForKey:@"totalSize"];
            friend.watchsize = [promiseSize objectForKey:@"watchSize"];
            
        }
        
    }
    
    NSError *error;
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }

    
   
    return YES;
}
-(void)initRecommendUserInfo:(NSArray *)userJson
{
    
}

-(void)updatePromiseInfo:(NSDictionary *)userJson andpromiseId:(NSNumber *)promiseid
{
    if (!userJson) {
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    {
       // NSNumber* promiseId = (NSNumber *)[tmp_promise objectForKey:@"promiseId"];
        Promise *addPromise = [self findPromise:promiseid.integerValue];
        
        if (!addPromise)
        {
            return;
        }
      //  addPromise.promiseid = promiseId;
        addPromise.pro_content = [userJson objectForKey:@"proContent"];
        addPromise.pro_status = [userJson objectForKey:@"proStatus"];
        //   addPromise.im
        addPromise.praise = [userJson objectForKey:@"praise"];
        addPromise.egg = [userJson objectForKey:@"egg"];
        addPromise.comment = [userJson objectForKey:@"comment"];
        addPromise.due_date = [dateFormatter dateFromString:[userJson objectForKey:@"dueDate"]];
        addPromise.create_date = [dateFormatter dateFromString:[userJson objectForKey:@"createDate"]];
        //  addPromise.pro_content = [tmp_promise objectForKey:@"proStatus"];
        addPromise.start_date = [dateFormatter dateFromString:[userJson objectForKey:@"startDate"]];
        addPromise.user_id = [userJson objectForKey:@"userId"];
        addPromise.username =[userJson objectForKey:@"username"];
        //处理图片
        addPromise.imageString =[userJson objectForKey:@"promiseImgs"];
      
        addPromise.hadpraise= [userJson objectForKey:@"hadPraise"];
         addPromise.hadegg= [userJson objectForKey:@"hadEgg"];
        //addPromise.hadegg =
        //addPromise.watchman =[userJson objectForKey:@"watchman"];

        
        NSString *pp = [userJson objectForKey:@"proveImgs"];
        if ([pp length]>0) {
            addPromise.proveimageString = [userJson objectForKey:@"proveImgs"];
        }
        //addPromise.friend_id = self.loginUser.userid;
        addPromise.headpicture = [NSString stringWithFormat:@"%@/Upromise/Image/%@",HOST,[userJson objectForKey:@"headPicture"]];
        // addPromise.pro_content = [tmp_promise objectForKey:@"startDate"];
        //addPromise.user = self.loginUser;
//        
//        NSError *error;
//        if(![[self managedObjectContext] save:&error])
//        {
//            NSLog(@"不能保存：%@",[error localizedDescription]);
//        }
//        
        
    }

}
-(void)initFriendPromiseInfo:(NSArray *)userJson
{
    if (!userJson || ![userJson respondsToSelector:@selector(count)]) {
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    for (NSDictionary *tmp_promise in userJson) {
        NSNumber* promiseId = (NSNumber *)[tmp_promise objectForKey:@"promiseId"];
        Promise *addPromise = [self findPromise:promiseId.integerValue];
        
        if (!addPromise)
        {
            addPromise = [NSEntityDescription insertNewObjectForEntityForName:@"Promise" inManagedObjectContext:[self managedObjectContext]];
        }
        addPromise.promiseid = promiseId;
        addPromise.pro_content = [tmp_promise objectForKey:@"proContent"];
        addPromise.pro_status = [tmp_promise objectForKey:@"proStatus"];
        //   addPromise.im
        addPromise.praise = [tmp_promise objectForKey:@"praise"];
        addPromise.egg = [tmp_promise objectForKey:@"egg"];
        addPromise.comment = [tmp_promise objectForKey:@"comment"];
        addPromise.due_date = [dateFormatter dateFromString:[tmp_promise objectForKey:@"dueDate"]];
        addPromise.create_date = [dateFormatter dateFromString:[tmp_promise objectForKey:@"createDate"]];
        //  addPromise.pro_content = [tmp_promise objectForKey:@"proStatus"];
        addPromise.start_date = [dateFormatter dateFromString:[tmp_promise objectForKey:@"startDate"]];
        addPromise.user_id = [tmp_promise objectForKey:@"userId"];
        addPromise.username =[tmp_promise objectForKey:@"username"];
        //处理图片
        addPromise.imageString =[tmp_promise objectForKey:@"promiseImgs"];
        addPromise.friend_id = self.loginUser.userid;
        addPromise.headpicture = [NSString stringWithFormat:@"%@/Upromise/Image/%@",HOST,[tmp_promise objectForKey:@"headPicture"]];
        
         addPromise.watchman =[tmp_promise objectForKey:@"watchman"];
        
        NSString *pp = [tmp_promise objectForKey:@"proveImgs"];
        if ([pp length]>0) {
            addPromise.proveimageString = [tmp_promise objectForKey:@"proveImgs"];
        }
        
        //addPromise.proveimageString = [tmp_promise objectForKey:@"proveImgs"];
        // addPromise.pro_content = [tmp_promise objectForKey:@"startDate"];
        //addPromise.user = self.loginUser;
        
        NSError *error;
        if(![[self managedObjectContext] save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
        
        
    }

    
}
-(void)initPromiseInfo:(NSArray *)userJson andWatchId:(NSNumber *)watchId andState:(NSInteger)proState
{
    //NSLog(@"%@",userJson.description);
    if (!userJson || ![userJson respondsToSelector:@selector(count)]) {
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    for (NSDictionary *tmp_promise in userJson) {
        NSNumber* promiseId = (NSNumber *)[tmp_promise objectForKey:@"promiseId"];
        Promise *addPromise = [self findPromise:promiseId.integerValue];
        
        if (!addPromise)
        {
            addPromise = [NSEntityDescription insertNewObjectForEntityForName:@"Promise" inManagedObjectContext:[self managedObjectContext]];
        }
        addPromise.promiseid = promiseId;
        addPromise.pro_content = [tmp_promise objectForKey:@"proContent"];
        addPromise.pro_status = [tmp_promise objectForKey:@"proStatus"];
     //   addPromise.im
        addPromise.praise = [tmp_promise objectForKey:@"praise"];
        addPromise.egg = [tmp_promise objectForKey:@"egg"];
        addPromise.comment = [tmp_promise objectForKey:@"comment"];
        if (addPromise.due_date == nil) {
            addPromise.due_date = [dateFormatter dateFromString:[tmp_promise objectForKey:@"dueDate"]];

            
        }
        
        
        if (addPromise.create_date == nil) {
            addPromise.create_date = [dateFormatter dateFromString:[tmp_promise objectForKey:@"createDate"]];
        }
        
      //  addPromise.pro_content = [tmp_promise objectForKey:@"proStatus"];
        if (addPromise.start_date == nil) {
            addPromise.start_date = [dateFormatter dateFromString:[tmp_promise objectForKey:@"startDate"]];

        }
        addPromise.user_id = [tmp_promise objectForKey:@"userId"];
        
        if (proState==3) {
            addPromise.watch_id = watchId;
            
        }
       
        
        //处理图片
        addPromise.imageString =[tmp_promise objectForKey:@"promiseImgs"];
        
         NSString *pp = [tmp_promise objectForKey:@"proveImgs"];
        if ([pp length]>0) {
             addPromise.proveimageString = [tmp_promise objectForKey:@"proveImgs"];
        }
       
        
        
       // addPromise.pro_content = [tmp_promise objectForKey:@"startDate"];
        if ([addPromise.user_id isEqualToNumber:self.loginUser.userid]) {
                addPromise.user = self.loginUser;
                addPromise.headpicture = self.loginUser.headpicture;
                addPromise.username = self.loginUser.username;
        }
        addPromise.watchman =[tmp_promise objectForKey:@"watchman"];
       // addPromise.u
        NSError *error;
        if(![[self managedObjectContext] save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }

        
    }
    
   // self.loginUser.promise
   
}


-(void)initTopicPromise:(NSArray *)userJson andtopicNum:(NSNumber *)topicNum
{
    //NSLog(@"%@",userJson.description);
    if (!userJson || ![userJson respondsToSelector:@selector(count)]) {
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    for (NSDictionary *tmp_promise in userJson) {
        NSNumber* promiseId = (NSNumber *)[tmp_promise objectForKey:@"promiseId"];
        Promise *addPromise = [self findPromise:promiseId.integerValue];
        
        if (!addPromise)
        {
            addPromise = [NSEntityDescription insertNewObjectForEntityForName:@"Promise" inManagedObjectContext:[self managedObjectContext]];
        }
        addPromise.promiseid = promiseId;
        addPromise.pro_content = [tmp_promise objectForKey:@"proContent"];
        addPromise.pro_status = [tmp_promise objectForKey:@"proStatus"];
        //   addPromise.im
        addPromise.praise = [tmp_promise objectForKey:@"praise"];
        addPromise.egg = [tmp_promise objectForKey:@"egg"];
        addPromise.comment = [tmp_promise objectForKey:@"comment"];
        addPromise.due_date = [dateFormatter dateFromString:[tmp_promise objectForKey:@"dueDate"]];
        addPromise.create_date = [dateFormatter dateFromString:[tmp_promise objectForKey:@"createDate"]];
        //  addPromise.pro_content = [tmp_promise objectForKey:@"proStatus"];
        addPromise.start_date = [dateFormatter dateFromString:[tmp_promise objectForKey:@"startDate"]];
        addPromise.user_id = [tmp_promise objectForKey:@"userId"];
        addPromise.username =[tmp_promise objectForKey:@"username"];
        //处理图片
        addPromise.imageString =[tmp_promise objectForKey:@"promiseImgs"];
        addPromise.topic = topicNum;
        addPromise.headpicture = [NSString stringWithFormat:@"%@/Upromise/Image/%@",HOST,[tmp_promise objectForKey:@"headPicture"]];
        
        addPromise.watchman =[tmp_promise objectForKey:@"watchman"];
        
        NSString *pp = [tmp_promise objectForKey:@"proveImgs"];
        if ([pp length]>0) {
            addPromise.proveimageString = [tmp_promise objectForKey:@"proveImgs"];
        }
        
        //addPromise.proveimageString = [tmp_promise objectForKey:@"proveImgs"];
        // addPromise.pro_content = [tmp_promise objectForKey:@"startDate"];
        //addPromise.user = self.loginUser;
        
        NSError *error;
        if(![[self managedObjectContext] save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
        
        
    }
    
    // self.loginUser.promise
    
}

-(void)processImg:(NSString *)imgstring withType:(NSInteger) img_type toPromise:(Promise *)tmp_promise
{
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlstring = [url absoluteString];
    NSRange findTencet =  [urlstring rangeOfString:@"tencent"];
    if (findTencet.length>0) {
        return [TencentOAuth HandleOpenURL:url];
    }
    findTencet = [urlstring rangeOfString:@"webchat"];
    if (findTencet.length>0) {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return [WeiboSDK handleOpenURL:url delegate:self];
}


- (void)tencentDidLogin
{
    NSLog(@"登录完成");
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(self.tencentOAuth.accessToken);
        //self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        if(![_tencentOAuth getUserInfo]){
          //  [self showInvalidTokenOrOpenIDMessage];
        }
        
//        if([self.myMessageData loginFromThirdPart:self.tencentOAuth.openId andPassword:@""])
//        {
//            // [self performSegueWithIdentifier:@"loginSuccess" sender:self];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_Success" object:self userInfo:nil];
//            
//            
//        }
//        else
//        {
//            UIAlertView *alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:self.myMessageData.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alter show];
//            
//        }

        
    }
   
}

-(void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED)
    {
     //   NSMutableString *str=[NSMutableString stringWithFormat:@""];
        NSString *nickName = [response.jsonResponse objectForKey:@"nickname"];
        if([self.myMessageData loginFromThirdPart:nickName andPassword:@""])
        {
            // [self performSegueWithIdentifier:@"loginSuccess" sender:self];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_Success" object:self userInfo:nil];
            
            
        }

        
//        for (id key in response.jsonResponse) {
//            [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
//        }
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
//                              
//                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//        [alert show];
       
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
                              
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
        
    }

    
    
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        if((int)response.statusCode == 0)
        {
            
            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
            if([self.myMessageData loginFromThirdPart:[(WBAuthorizeResponse *)response userID] andPassword:@""])
            {
               // [self performSegueWithIdentifier:@"loginSuccess" sender:self];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_Success" object:self userInfo:nil];
                
                
            }
            else
            {
                UIAlertView *alter     =[[UIAlertView alloc]initWithTitle:@"提示" message:self.myMessageData.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                
            }
            
            
            //
            
            //获取用户信息
            
        }
        
        //        NSString *title = @"认证结果";
        //        NSString *message = [NSString stringWithFormat:@"UserInfo数据: %@\n原请求UserInfo数据: %@", response.userInfo, response.requestUserInfo];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
        //                                                        message:message
        //                                                       delegate:nil
        //                                              cancelButtonTitle:@"确定"
        //                                              otherButtonTitles:nil];
        //        
        //        [alert show];
        
        
    }
}


/*
 * 推荐实现上面的方法，两个方法二选一实现即可
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
 {
 return [ WeiboSDK handleOpenURL:url delegate:self ];
 }
 */

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
       // [alert release];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
       // [alert release];
    }
}

@end
