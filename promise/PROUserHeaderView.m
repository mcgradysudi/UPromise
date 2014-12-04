//
//  PROUserHeaderView.m
//  promise
//
//  Created by su di on 14-8-16.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROUserHeaderView.h"
#import "UIImageView+WebCache.h"

@interface PROUserHeaderView()
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userExplainInfo;

@property (strong, nonatomic) IBOutlet UILabel *gradeLabel;

@end
@implementation PROUserHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)view {
    static UINib *nib;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    });
    
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    for (id object in nibObjects) {
        if ([object isKindOfClass:[self class]]) {
            return object;
        }
    }
    
    return nil;
}

-(void)refresh
{
    
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"userhead.png"];
    
    UIImage *logoImage = [UIImage imageWithContentsOfFile:path];
    if (!logoImage) {
        logoImage = [UIImage imageNamed:@"head.png"];
        
    }

    
    [self.userImageView sd_setImageWithURL: [NSURL URLWithString:self.viewUser.headpicture] placeholderImage:logoImage];
    
    self.userNameLabel.text = self.viewUser.username;
    self.gradeLabel.text = self.viewUser.grade.description;
    self.userExplainInfo.text = [self.viewUser.explaininfo compare:@""]==NSOrderedSame?@"暂无签名":self.viewUser.explaininfo;

}

-(void)refreshFromFriend
{
    
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"userhead.png"];
    
    UIImage *logoImage = [UIImage imageWithContentsOfFile:path];
    if (!logoImage) {
        logoImage = [UIImage imageNamed:@"head.png"];
        
    }
    
    
    [self.userImageView sd_setImageWithURL: [NSURL URLWithString:self.viewFriend.headpicture] placeholderImage:logoImage];
    
    self.userNameLabel.text = self.viewFriend.username;
    self.gradeLabel.text = self.viewFriend.grade.description;
    self.userExplainInfo.text = [self.viewFriend.explaininfo compare:@""]==NSOrderedSame?@"暂无签名":self.viewFriend.explaininfo;
    
}
-(void)awakeFromNib
{
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 25;
    CGColorRef cgColor = [UIColor colorWithRed:78.0/255.0 green:126.0/255.0 blue:158.0/255.0 alpha:0.8].CGColor;
    self.userImageView.layer.borderColor = cgColor;
    self.userImageView.layer.borderWidth = 1.8;
    
    [self clickTag:1];

    
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refresh_user" object:nil];
    
}
-(void)clickTag:(NSInteger)tagInt
{
    self.completeLabel.textColor = [UIColor whiteColor];
    self.allLabel.textColor = [UIColor whiteColor];
    self.watchLabel.textColor = [UIColor whiteColor];
    
    switch (tagInt) {
        case 1:
            self.allLabel.textColor = [UIColor orangeColor];
            
            break;
        case 2:
              self.completeLabel.textColor = [UIColor orangeColor];
            break;
        case 3:
              self.watchLabel.textColor = [UIColor orangeColor];
            break;
            
        default:
            break;
    }
    
}
-(void)setViewUser:(UserInfo *)viewUser
{
    _viewUser = viewUser;
    //初始化界面
    //[self.userImageView sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>]
    
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"userhead.png"];
    
    UIImage *logoImage = [UIImage imageWithContentsOfFile:path];
    if (!logoImage) {
        logoImage = [UIImage imageNamed:@"head.png"];
        
    }

    
    [self.userImageView sd_setImageWithURL: [NSURL URLWithString:viewUser.headpicture] placeholderImage:logoImage];
   
    self.userNameLabel.text = viewUser.username;
    self.gradeLabel.text = viewUser.grade.description;
    self.userExplainInfo.text = [viewUser.explaininfo compare:@""]==NSOrderedSame?@"暂无签名":viewUser.explaininfo;
    
    
}
-(void)setViewFriend:(FriendList *)viewFriend
{
    _viewFriend = viewFriend;
    //初始化界面
    //[self.userImageView sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>]
    
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"userhead.png"];
    
    UIImage *logoImage = [UIImage imageWithContentsOfFile:path];
    if (!logoImage) {
        logoImage = [UIImage imageNamed:@"head.png"];
        
    }
    
    
    [self.userImageView sd_setImageWithURL: [NSURL URLWithString:viewFriend.headpicture] placeholderImage:logoImage];
    
    self.userNameLabel.text = viewFriend.username;
    self.gradeLabel.text = viewFriend.grade.description;
    self.userExplainInfo.text = [viewFriend.explaininfo compare:@""]==NSOrderedSame?@"暂无签名":viewFriend.explaininfo;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
