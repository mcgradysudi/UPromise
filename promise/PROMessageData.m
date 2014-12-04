//
//  PROMessageData.m
//  promise
//
//  Created by su di on 14-7-23.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROMessageData.h"
#import "UserInfo.h"
#import "Promise.h"
#import "ImageList.h"

#import "KGStatusBar.h"
@interface PROMessageData ()

@property (strong,nonatomic)NSNumber  *topicNum;
@end

@implementation PROMessageData


-(void)initParam:(NSURL *)url
{
   @synchronized(self) {
        self.request = [ASIFormDataRequest requestWithURL:url];
        self.versionCode = @"V1.0";
        self.paltform = @"ios";
        self.channel = @"";
        self.osVersion = @"7.1";
        self.accessPoint = @"1";
        self.imei =@"";
        self.macAddr = @"";
        self.screenResolution=@"640*1024";
        self.clientTimestamp=@"";
   }
}

-(BOOL)registerCount:(NSString *)userName andPassword:(NSString *)password
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/regist.action"]]];
    
   // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/regist.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    self.username = userName;
    self.password = password;
    
    [request setPostValue:userName forKey:@"account"];
    [request setPostValue:password forKey:@"password"];
    
    
    
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                self.message = [backResult objectForKey:@"msg"];
                
                return NO;
            }
            else
            {
                NSDictionary *userJson = [backResult objectForKey:@"data"];
                [self.appDelegate initUserInfo:userJson];
                return YES;
            }
            
            
        }
    }
    
    //self.message =  @"网络异常，注册失败！";
    
    return NO;

}
-(BOOL)login:(NSString *)userName andPassword:(NSString *)password
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/login.action"]]];
    
    
   // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/login.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    self.username = userName;
    self.password = password;
    
    [request setPostValue:userName forKey:@"account"];
    [request setPostValue:password forKey:@"password"];
    
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                self.message = [backResult objectForKey:@"msg"];
                return NO;
            }
            else
            {
                NSDictionary *userJson = [backResult objectForKey:@"data"];
                [self.appDelegate initUserInfo:userJson];

                return YES;
            }
            
            
        }
    }
    
   // self.message =  @"网络异常，登录失败！";
    
    return NO;
}

-(BOOL)loginFromThirdPart:(NSString *)userName andPassword:(NSString *)nickName
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/login!OtherAccountLogin.action"]]];
    
    
    // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/login.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    
    [request setPostValue:userName forKey:@"account"];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:[NSNumber numberWithInteger:3] forKey:@"loginType"];
    [request setPostValue:@"m" forKey:@"sex"];
    
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {
                
                self.message = [backResult objectForKey:@"msg"];
                return NO;
            }
            else
            {
                NSDictionary *userJson = [backResult objectForKey:@"data"];
                [self.appDelegate initUserInfo:userJson];
                
                return YES;
            }
            
            
        }
    }
    
    // self.message =  @"网络异常，登录失败！";
    
    return NO;
}


-(BOOL)getPromiseSize:(NSNumber *)userId
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/promiseSize.action"]]];
    
    
    // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/login.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
        [request setPostValue:userId forKey:@"userId"];
    
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            
            
             return [self.appDelegate  initPromiseSize:backResult andUserId:userId];
            
            
            
        }
    }
    
    // self.message =  @"网络异常，登录失败！";
    
    return NO;
}

-(BOOL)postLogImg:(NSNumber *)userId andImageName:(NSString *)imageName
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/servlet/uploadServlet"]]];
    
    
    //[self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/servlet/uploadServlet"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:userId forKey:@"userId"];
 //   [self.request setPostValue:imageName forKey:@"filename"];
//    self.username = userName;
//    self.password = password;
    
    [request setFile:imageName forKey:@"filename"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                return NO;
            }
            else
            {
               // NSDictionary *userJson = [backResult objectForKey:@"data"];
               // [self.appDelegate initUserInfo:userJson];
                
                
                return YES;
            }
            
            
        }
    }
    
    //self.message =  @"网络异常，失败！";
    
    return NO;
}

//更新用户信息
-(BOOL)postUserInfo:(UserInfo *) postUser
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/updateUser.action"]]];
    
    
    //[self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/updateUser.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:postUser.account forKey:@"account"];
    [request setPostValue:postUser.password forKey:@"password"];
    [request setPostValue:postUser.username  forKey:@"username"];
    

    [request setPostValue:postUser.sex  forKey:@"sex"];
    [request setPostValue:postUser.birthday.description forKey:@"birthday"];
    [request setPostValue:postUser.explaininfo forKey:@"selfbrief"];

    //   [self.request setPostValue:imageName forKey:@"filename"];
    //    self.username = userName;
    //    self.password = password;

    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                return NO;
            }
            else
            {
                
                return YES;
            }
            
            
        }
    }
    
    //self.message =  @"网络异常，登录失败！";
    
    return NO;
}

//获取推荐用户

-(NSArray *)getRecommendUser:(NSInteger) page andPageNum:(NSInteger) pageNum
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getTalents.action"]]];
    
    
   // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getTalents.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [request setPostValue:self.username forKey:@"account"];
    [request setPostValue:self.password forKey:@"password"];
    
    
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    [request setPostValue:[NSNumber numberWithInteger:pageNum]forKey:@"pageSize"];
    //[self.request setPostValue:postUser.explaininfo forKey:@"selfbrief"];
    
    //   [self.request setPostValue:imageName forKey:@"filename"];
    //    self.username = userName;
    //    self.password = password;
    
   // [self.request setDelegate:self];
   // self.request.tag = 4;
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                return nil;
            }
            else
            {
                
                NSArray *recommendJson =[backResult objectForKey:@"data"];
                //传送image
                
                //获取promiseinfo
                //[self.appDelegate updatePromiseInfo:promiseJson andpromiseId:promiseid];
                return  recommendJson;
                //[KGStatusBar showSuccessWithStatus:@"提交成功！"];
                
                //return YES;
            }
            
            
        }
    }
    
    //self.message =  @"网络异常，传送失败！";
    return nil;
    
  //  return NO;
}
//获取promise详细信息
-(BOOL)getPromiseDetail:(NSNumber *)promiseid anduserid:(NSNumber *)userid
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getPromiseInfo.action"]]];

    //[[self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getPromiseInfo.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:promiseid forKey:@"promiseId"];
    [request setPostValue:userid forKey:@"userId"];
    
    
    
    //[self.request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
    
    
    
    //  [KGStatusBar showSuccessWithStatus:@"正在提交！"];
   // [request setDelegate:self];
 //   self.request.tag = 1;
    //  [self.request startAsynchronous];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                return NO;
            }
            else
            {
                
                NSDictionary *promiseJson =[backResult objectForKey:@"data"];
                //传送image
                
                //获取promiseinfo
                [self.appDelegate updatePromiseInfo:promiseJson andpromiseId:promiseid];
                
                //[KGStatusBar showSuccessWithStatus:@"提交成功！"];
                
                return YES;
            }
            
            
        }
    }
    
    //self.message =  @"网络异常，传送失败！";
    return NO;

    
}
//提交promise
-(BOOL)postPromise:(Promise *)addpromise
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/addPromise.action"]]];
    

    
    //[self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/addPromise.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:self.username forKey:@"account"];
    [request setPostValue:self.password forKey:@"password"];
    
   
        
    [request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
        
    
    
  //  [KGStatusBar showSuccessWithStatus:@"正在提交！"];
   // [self.request setDelegate:self];
   // self.request.tag = 1;
  //  [self.request startAsynchronous];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                return NO;
            }
            else
            {
                
                NSNumber *promiseJson =[backResult objectForKey:@"data"];
                //传送image
                addpromise.promiseid = promiseJson;
                //NSLog(@"upload %@",promiseJson);
                for (ImageList *imageList in addpromise.imagelist.allObjects) {
                    [self postProImg:imageList andpromisId:promiseJson];
                  //   NSLog(@"upload %@",imageList.imagepath);
                }
                
                //获取promiseinfo
               // [self getPromiseDetail:addpromise.promiseid anduserid:addpromise.user_id];
               // [KGStatusBar showSuccessWithStatus:@"提交成功！"];
                
                return YES;
            }
            
            
        }
    }
    
    //self.message =  @"网络异常，传送失败！";
    return NO;
}
-(BOOL)postProveImg:(NSString *)imagePath andpromisId: (NSNumber *)promiseId
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/servlet/uploadServlet"]]];
    

    
    //[self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/servlet/uploadServlet"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:promiseId forKey:@"promiseIdProve"];
    //   [self.request setPostValue:imageName forKey:@"filename"];
    //    self.username = userName;
    //    self.password = password;
    
    [request setFile:imagePath forKey:@"filename"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                return NO;
            }
            else
            {
                // NSDictionary *userJson = [backResult objectForKey:@"data"];
                // [self.appDelegate initUserInfo:userJson];
                               
                
                return YES;
            }
            
            
        }
    }
    
    //self.message =  @"网络异常，登录失败！";
    
    return NO;

    
}
-(BOOL)postProImg:(ImageList *)imagePath andpromisId: (NSNumber *)promiseId
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/servlet/uploadServlet"]]];
    
    
   // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/servlet/uploadServlet"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:promiseId forKey:@"promiseId"];
    //   [self.request setPostValue:imageName forKey:@"filename"];
    //    self.username = userName;
    //    self.password = password;
    
    [request setFile:imagePath.imagepath forKey:@"filename"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                return NO;
            }
            else
            {
                // NSDictionary *userJson = [backResult objectForKey:@"data"];
                // [self.appDelegate initUserInfo:userJson];
                
                
                return YES;
            }
            
            
        }
    }
    
    //self.message =  @"网络异常，登录失败！";
    
    return NO;
}

-(BOOL)postPraise:(NSNumber *)userid andPromiseid:(NSNumber *)promiseid andpraise:(NSNumber *)praise withCreateUser:(NSNumber *)createuserid
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/praise.action"]]];
    
    
   // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/praise.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:userid forKey:@"userId"];
    [request setPostValue:createuserid forKey:@"createUserId"];
    [request setPostValue:promiseid   forKey:@"promiseId"];
    [request setPostValue:praise forKey:@"praise"];
   
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                
                
                //return NO;
            }
            else
            {
               // NSDictionary *userJson = [backResult objectForKey:@"data"];
                // [self getPromiseDetail:promiseid anduserid:<#(NSNumber *)#>]
               // [KGStatusBar showSuccessWithStatus:@"提交成功！"];
                return YES;
            }
            //
            //
        }
    }
    
    self.message =  @"网络异常，传送失败！";
   // [KGStatusBar showSuccessWithStatus:@"提交失败！"];
    return NO;

    
}
-(NSArray *)getComment:(NSNumber *)promiseid
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/commentList.action"]]];
    
    
  //  [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/commentList.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:promiseid forKey:@"promiseId"];

    //self.request.tag = 7;
   // [self.request setDelegate:self];
   // [self.request startAsynchronous];
    
    [request startSynchronous];
    
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                
                
                return nil  ;
            }
            else
            {
                NSArray *userJson = [backResult objectForKey:@"data"];
                             return userJson;
            }
        }
    }
    
    self.message =  @"网络异常，传送失败！";
    return nil;
    
    return NO;
}
-(BOOL)addFriendRelation:(NSString *)friendId
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/addFollow.action"]]];
    
    
    //[self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/addFollow.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:friendId forKey:@"friends"];
    [request setPostValue:self.username forKey:@"account"];
    [request setPostValue:self.password forKey:@"password"];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {
 
                
                return NO  ;
            }
            else
            {
                //NSArray *messageJson = [backResult objectForKey:@"data"];
                return YES;
            }
        }
    }
    
    self.message =  @"网络异常，传送失败！";
    return NO;
}

-(NSArray *)getMessage:(NSNumber *)messageType anduserid:(NSNumber *)userId
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/messageList.action"]]];
    
    
    
   // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/messageList.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:userId forKey:@"userId"];
    [request setPostValue:messageType forKey:@"type"];
   
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                
                
                return nil;
            }
            else
            {
                NSArray *messageJson = [backResult objectForKey:@"data"];
                return messageJson;
            }
        }
    }
    
    self.message =  @"网络异常，传送失败！";
    return nil;
}

-(BOOL)postComment:(NSString *)content andState:(NSNumber *)promiseid andPid:(NSNumber *)pid withUserid:(NSNumber *)userid andReplyUserid:(NSNumber *)replyUserid
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/comment.action"]]];
    
    
   // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/comment.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:pid forKey:@"pid"];
    [request setPostValue:promiseid forKey:@"promiseId"];
    [request setPostValue:userid   forKey:@"userId"];
    [request setPostValue:replyUserid forKey:@"repelyUserId"];
    [request setPostValue:content forKey:@"content"];
    // [self.request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
    
    
    
    //[KGStatusBar showSuccessWithStatus:@"提交评论！"];
    //   [self.request setDelegate:self];
    //  self.request.tag = 6;
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                
                
                //return NO;
            }
            else
            {
               // NSDictionary *userJson = [backResult objectForKey:@"data"];
                // [self getPromiseDetail:promiseid anduserid:<#(NSNumber *)#>]
                // [KGStatusBar showSuccessWithStatus:@"提交成功！"];
                return YES;
            }
            //
            //
        }
    }
    
    self.message =  @"网络异常，传送失败！";
    //[KGStatusBar showSuccessWithStatus:@"提交失败！"];
    return NO;
}


-(NSArray *)postWatch:(NSNumber *)promiseid
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/watchList.action"]]];
    
    
    //[self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/watchList.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:promiseid forKey:@"promiseId"];

    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {

                return nil;
            }
            else
            {
                NSArray *watchList = [backResult objectForKey:@"data"];
                return watchList;
            }
            //
            //
        }
    }
    
  //  self.message =  @"网络异常，传送失败！";
    //[KGStatusBar showSuccessWithStatus:@"提交失败！"];
    return nil;
}




-(BOOL)updatePromiseState:(NSNumber *)promiseid andState:(NSNumber *)prostate
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/updateProStatus.action"]]];
    
    
    //[self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/updateProStatus.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:self.username forKey:@"account"];
    [request setPostValue:self.password forKey:@"password"];
     [request setPostValue:promiseid   forKey:@"promiseId"];
     [request setPostValue:prostate forKey:@"status"];
    
    // [self.request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
    
    
    
    //[KGStatusBar showSuccessWithStatus:@"刷新数据！"];
    //   [self.request setDelegate:self];
    //  self.request.tag = 6;
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            NSString *state= [backResult objectForKey:@"state"];
            if([state compare:@"ok"] != NSOrderedSame)
            {
                
                
                return NO;
            }
            else
            {
                NSDictionary *userJson = [backResult objectForKey:@"data"];
               // [self getPromiseDetail:promiseid anduserid:<#(NSNumber *)#>]
                
                return YES;
            }
            //
            //
        }
    }
    
   // self.message =  @"网络异常，传送失败！";
    return NO;
}

-(BOOL)updateUserInfo:(NSString *)userName andPassword:(NSString *)password
{
    
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/login.action"]]];
    
    
    //self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/login.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:userName forKey:@"account"];
    [request setPostValue:password forKey:@"password"];
    
    
    // [self.request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
    
    
    
    //[KGStatusBar showSuccessWithStatus:@"刷新数据！"];
 //   [self.request setDelegate:self];
  //  self.request.tag = 6;
    [request startSynchronous];
    
        NSError *error = [request error];
        if (!error) {
           NSString *response = [request responseString];
    //
            NSError *error;
           NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            if(backResult)
            {
                NSString *state= [backResult objectForKey:@"state"];
                if([state compare:@"ok"] != NSOrderedSame)
                {
                    
                    
                    return NO;
                }
                else
                {
                    NSDictionary *userJson = [backResult objectForKey:@"data"];
                    [self.appDelegate updateUserInfo:userJson];
                    
                    return YES;
                }
    //
    //
            }
        }
    
       //self.message =  @"网络异常，传送失败！";
    return NO;
}



-(NSArray *)getUserPromise:(NSInteger) page andPageNum:(NSInteger) pageNum andPromiseState:(NSInteger) proState
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getOwnPromise.action"]]];
    
    
   // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getOwnPromise.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:self.username forKey:@"account"];
    [request setPostValue:self.password forKey:@"password"];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    [request setPostValue:[NSNumber numberWithInteger:pageNum] forKey:@"pageSize"];
    [request setPostValue:[NSNumber numberWithInteger:proState] forKey:@"status"];
    
    // [self.request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
    
    
    
    //[KGStatusBar showSuccessWithStatus:@"刷新数据！"];
    //[request setDelegate:self];
    //request.tag = 2;
    [request startSynchronous];

    
        NSError *error = [request error];
        if (!error) {
           NSString *response = [request responseString];
    
            NSError *error;
            NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
           if(backResult)
            {
                self.message= [backResult objectForKey:@"state"];
                if([self.message compare:@"ok"] != NSOrderedSame)
                {
                   return nil;
               }
               else
               {
                   NSArray *promiseJson =[backResult objectForKey:@"data"];
                   //[self.appDelegate initPromiseInfo:promiseJson];
                   return promiseJson;
                   
                    return nil;
               }
    //
    //
            }
        }
    //    
    self.message =  @"网络异常，传送失败！";
    return nil;
}

-(NSArray *)getFriendPromiseFromId:(NSInteger)page andPageNum:(NSInteger)pageNum userID:(NSInteger)userId andPromiseState:(NSInteger)proState
{
    ASIFormDataRequest *request  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/friendPromise.action"]]];
    
    
    // [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getOwnPromise.action"]]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
  
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    [request setPostValue:[NSNumber numberWithInteger:pageNum] forKey:@"pageSize"];
    [request setPostValue:[NSNumber numberWithInteger:proState] forKey:@"status"];
    [request setPostValue:[NSNumber numberWithInteger:userId]  forKey:@"userId"];
    
    
    // [self.request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
    
    
    
    //[KGStatusBar showSuccessWithStatus:@"刷新数据！"];
    //[request setDelegate:self];
    //request.tag = 2;
    [request startSynchronous];
    
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *error;
        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(backResult)
        {
            self.message= [backResult objectForKey:@"state"];
            if([self.message compare:@"ok"] != NSOrderedSame)
            {
                return nil;
            }
            else
            {
                NSArray *promiseJson =[backResult objectForKey:@"data"];
                //[self.appDelegate initPromiseInfo:promiseJson];
                return promiseJson;
                
                return nil;
            }
            //
            //
        }
    }
    //
    self.message =  @"网络异常，传送失败！";
    return nil;
}
-(BOOL)getFriendList:(NSInteger) page andPageNum:(NSInteger) pageNum
{
    [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getFriends.action"]]];
    
    [self.request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [self.request setPostValue:self.username forKey:@"account"];
    [self.request setPostValue:self.password forKey:@"password"];
    [self.request setPostValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    [self.request setPostValue:[NSNumber numberWithInteger:pageNum] forKey:@"pageSize"];
   // [self.request setPostValue:[NSNumber numberWithInteger:proState==1?1:-1] forKey:@"status"];
    
    // [self.request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
    
    
    
    //[KGStatusBar showSuccessWithStatus:@"刷新数据！"];
    [self.request setDelegate:self];
    self.request.tag = 5;
    [self.request startAsynchronous];
    
    //    NSError *error = [self.request error];
    //    if (!error) {
    //        NSString *response = [self.request responseString];
    //
    //        NSError *error;
    //        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    //        if(backResult)
    //        {
    //            self.message= [backResult objectForKey:@"state"];
    //            if([self.message compare:@"ok"] != NSOrderedSame)
    //            {
    //                return NO;
    //            }
    //            else
    //            {
    //
    //                return YES;
    //            }
    //
    //
    //        }
    //    }
    //
    //    self.message =  @"网络异常，传送失败！";
    return NO;
}
-(BOOL)getFriendPromise:(NSInteger) page andPageNum:(NSInteger) pageNum
{
    [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getFriendsProList.action"]]];
    
    [self.request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [self.request setPostValue:self.username forKey:@"account"];
    [self.request setPostValue:self.password forKey:@"password"];
    // [self.request setPostValue:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    [self.request setPostValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    [self.request setPostValue:[NSNumber numberWithInteger:pageNum] forKey:@"pageSize"];
    // [self.request setPostValue:[NSNumber numberWithInteger:-1] forKey:@"status"];
    
    // [self.request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
    
    
    
    //[KGStatusBar showSuccessWithStatus:@"刷新数据！"];
    [self.request setDelegate:self];
    self.request.tag = 3;
    [self.request startAsynchronous];
    
    //    NSError *error = [self.request error];
    //    if (!error) {
    //        NSString *response = [self.request responseString];
    //
    //        NSError *error;
    //        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    //        if(backResult)
    //        {
    //            self.message= [backResult objectForKey:@"state"];
    //            if([self.message compare:@"ok"] != NSOrderedSame)
    //            {
    //                return NO;
    //            }
    //            else
    //            {
    //
    //                return YES;
    //            }
    //
    //
    //        }
    //    }
    //
    //    self.message =  @"网络异常，传送失败！";
    return NO;
}
-(NSArray *)getPromisebyTopic:(NSInteger) page andPageNum:(NSInteger) pageNum andTopicId:(NSNumber *)topicid
{
     [self initParam:[NSURL URLWithString:[HOST stringByAppendingString:@"/Upromise/getTopicProList.action"]]];
    
    [self.request setDefaultResponseEncoding:NSUTF8StringEncoding];
//    [self.request setPostValue:self.username forKey:@"account"];
//    [self.request setPostValue:self.password forKey:@"password"];
   // [self.request setPostValue:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    [self.request setPostValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    [self.request setPostValue:[NSNumber numberWithInteger:pageNum] forKey:@"pageSize"];
    [self.request setPostValue:topicid forKey:@"topic"];
    
    // [self.request setPostValue:[addpromise returnJsonData] forKey:@"proObj"];
    self.topicNum = topicid;
    
    
//[KGStatusBar showSuccessWithStatus:@"刷新数据！"];
    [self.request setDelegate:self];
     self.request.tag = 8;
    [self.request startAsynchronous];

//    NSError *error = [request error];
//    if (!error) {
//        NSString *response = [request responseString];
//
//        NSError *error;
//        NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
//        if(backResult)
//        {
//            NSString *message= [backResult objectForKey:@"state"];
//            if([message compare:@"ok"] != NSOrderedSame)
//            {
//                return nil;
//            }
//            else
//            {
//                
//                NSArray *promiseJson =[backResult objectForKey:@"data"];
//                //[self.appDelegate initPromiseInfo:promiseJson];
//                return promiseJson;
//                
//                return nil;
//
//            }
//
//
//        }
//    }
    //
    //    self.message =  @"网络异常，传送失败！";
    return nil;
}


//获取promise信息

//set构造函数
-(void)setVersionCode:(NSString *)versionCode
{
    _versionCode = versionCode;
    [self.request setPostValue:versionCode forKey:@"versionCode"];
}

-(void)setPaltform:(NSString *)paltform
{
    _paltform  = paltform;
    [self.request setPostValue:paltform forKey:@"paltform"];
}

-(void)setChannel:(NSString *)channel
{
    _channel = channel;
    [self.request setPostValue:channel forKey:@"channel"];
}

-(void)setOsVersion:(NSString *)osVersion
{
    _osVersion = osVersion;
    [self.request setPostValue:osVersion forKey:@"osVersion"];
}

-(void)setAccessPoint:(NSString *)accessPoint
{
    _accessPoint = accessPoint;
    [self.request setPostValue:accessPoint forKey:@"accessPoint"];
}

-(void)setImei:(NSString *)imei
{
    _imei = imei;
    [self.request setPostValue:imei forKey:@"imei"];
}

-(void)setMacAddr:(NSString *)macAddr
{
    _macAddr = macAddr;
    [self.request setPostValue:macAddr forKey:@"macAddr"];
}
-(void)setScreenResolution:(NSString *)screenResolution
{
    _screenResolution = screenResolution;
    [self.request setPostValue:screenResolution forKey:@"screenResolution"];
}
-(void)setClientTimestamp:(NSString *)clientTimestamp
{
    _clientTimestamp = clientTimestamp;
    [self.request setPostValue:clientTimestamp forKey:@"clientTimestamp" ];

}

-(void)setPassword:(NSString *)password
{
    _password = password;
       [self.request setPostValue:password forKey:@"password"];
}
-(void)setUsername:(NSString *)username
{
    _username = username;
       [self.request setPostValue:username forKey:@"account" ];
}

#pragma delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    NSString *response = [self.request responseString];
    
    NSError *error;
    NSDictionary *backResult = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if(!backResult)
    {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_table" object:self userInfo:nil];
       return;
    }
    
    NSString *state= [backResult objectForKey:@"state"];
    if([state compare:@"ok"] != NSOrderedSame)
    {

       // [KGStatusBar showSuccessWithStatus:self.message];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_table" object:self userInfo:nil];
        
        return;
    }
//    else
//    {
//        //        //return;
//    }
    if (request.tag == 1)
    {
       // [KGStatusBar showSuccessWithStatus:@"提交成功！"];
        
        NSNumber *promiseJson =[backResult objectForKey:@"data"];
      //  [self.appDelegate initPromiseInfo:promiseJson];
        
      //   [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_table" object:self userInfo:nil];
        
        return;

    }
    else if (request.tag == 2)
    {
        NSArray *promiseJson =[backResult objectForKey:@"data"];
       // [self.appDelegate initPromiseInfo:promiseJson andWatchId:self. andState:<#(NSInteger)#>];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_table" object:self userInfo:nil];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self updateUserInfo:self.username andPassword:self.password];
        });

        
        
       return;
    }
    else if (request.tag == 3)
    {
        NSArray *promiseJson =[backResult objectForKey:@"data"];
        [self.appDelegate initFriendPromiseInfo:promiseJson];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_friend_table" object:self userInfo:nil];
        
        return;

    }
    else if (request.tag == 4)
    {
        NSArray *recommendUser =[backResult objectForKey:@"data"];
        [self.appDelegate initRecommendUserInfo:recommendUser];
        
      //  [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_friend_table" object:self userInfo:nil];
        return;

    }
    else if (request.tag == 5)
    {
        NSArray *friendlist =[backResult objectForKey:@"data"];
        [self.appDelegate initFriendInfo:friendlist];
        
        //  [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_friend_table" object:self userInfo:nil];
        return;

    }
    else if (request.tag == 6)
    {
        NSDictionary *userJson = [backResult objectForKey:@"data"];
        [self.appDelegate updateUserInfo:userJson];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_user" object:nil userInfo:nil];

        //  [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_friend_table" object:self userInfo:nil];
        return;
        
    }
    else if (request.tag == 7)
    {
        NSDictionary *userJson = [backResult objectForKey:@"data"];
        [self.appDelegate initComment:userJson];
        
        return;

    }
    else if (request.tag == 8)
    {
        NSArray *userJson = [backResult objectForKey:@"data"];
        [self.appDelegate initTopicPromise:userJson andtopicNum:self.topicNum];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_friend_table" object:self userInfo:nil];
        return;
        
    }
   // [KGStatusBar showSuccessWithStatus:@"提交失败！"];

    
   
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    self.message =  @"网络异常，服务器请求失败！";
    if (request.tag == 2)
    {[[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_table" object:self userInfo:nil];
    }
    else if (request.tag == 3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_friend_table" object:self userInfo:nil];
        
    }
     [KGStatusBar showErrorWithStatus:self.message];
}

@end
