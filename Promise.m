//
//  Promise.m
//  promise
//
//  Created by su di on 14-8-5.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "Promise.h"
#import "UserInfo.h"


@implementation Promise

@dynamic create_date;
@dynamic due_date;
@dynamic egg;
@dynamic end_date;
@dynamic praise;
@dynamic pro_content;
@dynamic pro_status;
@dynamic promiseid;
@dynamic punish;
@dynamic start_date;
@dynamic user_id;
@dynamic friend_id;
@dynamic visiable_scope;
@dynamic user;
@dynamic imagelist;
@dynamic comment;
@dynamic username;
@dynamic imageString;
@dynamic displayall;
@synthesize imageUrl;
@synthesize textDisplayAll;
@synthesize proveimageUrl;
@dynamic headpicture;
@dynamic proveimageString;
@dynamic watchman;
@dynamic hadpraise;
@dynamic hadegg;
@dynamic topic;
@dynamic watch_id;

-(NSString *)returnJsonData
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [dictionary setValue:[dateFormatter stringFromDate:self.create_date]  forKey:@"createDate"];
    [dictionary setValue:[dateFormatter stringFromDate:self.start_date] forKey:@"startDate"];
     [dictionary setValue:[dateFormatter stringFromDate:self.due_date] forKey:@"dueDate"];
    
    
     [dictionary setValue:self.punish forKey:@"punish"];
    [dictionary setValue:self.pro_content forKey:@"proContent"];
     [dictionary setValue:@"" forKey:@"watchman"];
     [dictionary setValue:[NSNumber numberWithInteger:0] forKey:@"promiseId"];
     [dictionary setValue:[NSNumber numberWithInteger:0] forKey:@"comment"];
    [dictionary setValue:[NSNumber numberWithInteger:0] forKey:@"hadPraise"];
    [dictionary setValue:[NSNumber numberWithInteger:0] forKey:@"hadeEgg"];
    [dictionary setValue:[NSNumber numberWithInteger:0] forKey:@"praise"];
      [dictionary setValue:[NSNumber numberWithInteger:1] forKey:@"visiableScope"];
      [dictionary setValue:[NSNumber numberWithInteger:0] forKey:@"proStatus"];
    if (self.topic.integerValue !=0 ) {
        [dictionary setValue:self.topic  forKey:@"topic"];

    }
      [dictionary setValue:[NSNumber numberWithInteger:0] forKey:@"proStatus"];
    [dictionary setValue:self.watchman forKey:@"watchman"];
    NSError *error = nil;
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
       
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
   return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
   
    
    return nil;
}
-(void)initImageUrl:(NSString *)imageString
{
    if (self.imageUrl&&[self.imageUrl count]) return;
    
       if ([imageString compare:@""]!=NSOrderedSame) {
           
        self.imageUrl = [[NSMutableArray alloc]init];
        NSArray *temp = [imageString componentsSeparatedByString:@";"];
        for (NSString *filename in temp) {
           NSString *fullurl =   [NSString stringWithFormat:IMAGEURL,filename];
            [self.imageUrl addObject:fullurl];
            
        }
      //  self.imageUrl

    }
    
  // - （NSArray*）componentsSeparatedByString：（NSString*）NString
    
    
}

-(void)initProveImageUrl
{
    if ([self.proveimageUrl count]>=3) return;
    
    if ([self.proveimageString compare:@""]!=NSOrderedSame) {
        
        self.proveimageUrl = [[NSMutableArray alloc]init];
        NSArray *temp = [self.proveimageString componentsSeparatedByString:@";"];
        for (NSString *filename in temp) {
            NSString *fullurl =   [NSString stringWithFormat:IMAGEURL,filename];
            [self.proveimageUrl addObject:fullurl];
            
        }
        //  self.imageUrl
        
    }
    
    // - （NSArray*）componentsSeparatedByString：（NSString*）NString
    
    
}

-(CGFloat)calcPromiseRowHeight
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:17];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [self.pro_content boundingRectWithSize:CGSizeMake(155, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    if (self.promiseid.integerValue ==99999) {
        return [self.imagelist count]==0?size.height+50:size.height+120.0;

    }
    
    return [self.imageString isEqual:@""]?size.height+50:size.height+120.0;
}

-(CGFloat)calcFriendRowHeight
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:17];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [self.pro_content boundingRectWithSize:CGSizeMake(226, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    return [self.imageString isEqual:@""]?size.height+61:size.height+130.0;
}


-(CGFloat)calcDetailRowHeight
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:20];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [self.pro_content boundingRectWithSize:CGSizeMake(298, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGFloat buttonDisplay = 0.0;
//    if (self.friend_id.integerValue >0 ) {
//        buttonDisplay = -35.0;
//    }
    return [self.imageString isEqual:@""]?size.height+140+buttonDisplay:size.height+205.0+buttonDisplay;
}


@end
