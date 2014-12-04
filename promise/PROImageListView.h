//
//  PROImageListView.h
//  promise
//
//  Created by su di on 14-7-31.
//  Copyright (c) 2014年 su di. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PROImageListView : UICollectionView<UIGestureRecognizerDelegate>
@property (strong,nonatomic)NSMutableArray *imageList;
@property (nonatomic,assign)NSInteger imageNumLimit;
@property (nonatomic,strong)UIImage *defaultImage;
-(BOOL)addImagetoList:(UIImage *)addimage;
@end
