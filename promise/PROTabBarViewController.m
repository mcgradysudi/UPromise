//
//  PROTabBarViewController.m
//  promise
//
//  Created by su di on 14-7-19.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import "PROTabBarViewController.h"
#import "PROAddTableViewController.h"
@interface PROTabBarViewController ()

@end

@implementation PROTabBarViewController

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
     //self.navigationController.navigationBarHidden = YES;
    UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sampleButton.frame = CGRectMake(140, 2, 42, 42);
    
    [sampleButton setBackgroundImage:[[UIImage imageNamed:@"add.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [sampleButton setAdjustsImageWhenHighlighted:NO];
    [sampleButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    [self.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
    self.navigationItem.hidesBackButton = YES;

    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    NSArray *items = self.tabBar.items;
    UITabBarItem *indexTabbar = items[0];
    
    indexTabbar.titlePositionAdjustment = UIOffsetMake(-5, 0);
   // NSLog(@"version %f",[[[UIDevice currentDevice]systemVersion]floatValue]);
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.099999)
        
    {
        
        // 7.0 系统的适配处理。
        indexTabbar.imageInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    }
    
 
    
    UITabBarItem *friendTabbar = items[1];
    
    friendTabbar.titlePositionAdjustment = UIOffsetMake(-25, 0);
   // friendTabbar.imageInsets = UIEdgeInsetsMake(0, -22, 0, 22);
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.099999)
        
    {
    
        // 7.0 系统的适配处理。
        friendTabbar.imageInsets = UIEdgeInsetsMake(0, -25, 0, 25);
    }
    UITabBarItem *activeTabbar = items[2];
    
    activeTabbar.titlePositionAdjustment = UIOffsetMake(25, 0);
   // activeTabbar.imageInsets = UIEdgeInsetsMake(0, 25, 0, -25);
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.099999)
        
    {
        
        // 7.0 系统的适配处理。
        activeTabbar.imageInsets = UIEdgeInsetsMake(0, 25, 0, -25);
    }
    
         //self.navigationController.navigationBarHidden = YES;
    
     [self.tabBar addSubview:sampleButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickButton {
    PROAddTableViewController *addTableController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"proaddtable"];
    self.navigationItem.title = @"";
    [self.navigationController pushViewController:addTableController animated:YES];
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

@end
