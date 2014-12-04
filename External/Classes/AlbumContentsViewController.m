/*
     File: AlbumContentsViewController.m
 Abstract: View controller to manaage displaying the contents of an album.
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "AlbumContentsViewController.h"
#import "MyPageViewController.h"
#import "PageViewControllerData.h"

@implementation AlbumContentsViewController

#pragma mark - View lifecycle
-(void)viewDidLoad
{
        //[super viewDidLoad];
   // self.collectionView registerClass:<#(__unsafe_unretained Class)#> forCellWithReuseIdentifier:<#(NSString *)#>
//    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bomb.png"]];
//    [self.collectionView addSubview:imageview];
    
    self.numLabel.layer.masksToBounds = YES;
    self.numLabel.layer.cornerRadius = 17;
    self.numLabel.hidden = YES;
    self.completeButton.enabled = false;
 ///   [self addObserver:self forKeyPath:@"selectassets.count" options:NSKeyValueObservingOptionNew context:nil];
    
//    CGColorRef cgColor = [UIColor colorWithRed:78.0/255.0 green:126.0/255.0 blue:158.0/255.0 alpha:0.8].CGColor;
//    self.numLabel.layer.borderColor = cgColor;
//    self.numLabel.layer.borderWidth = 1.8;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == nil) {
        //self.bb  = 56;
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    //[super viewWillAppear:animated];
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.selectassets) {
        self.selectassets = [[NSMutableSet alloc] init];
    }

    if (!self.assets) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets addObject:result];
            
        }
    };

    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
    [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
    
    [self setNumlabelandButton];

    
}

- (void)viewDidAppear:(BOOL)animated {
    
    //[super viewDidAppear:animated];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   static NSString *CellIdentifier = @"photoCell";
  //   NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",[indexPath section], (long)[indexPath row]];
    UICollectionViewCell *cell =  [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
 
    // load the asset for this cell
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
   // cell.tag = indexPath.row    ;
    // apply the image to the cell
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
    imageView.image = thumbnail;
    //imageView.highlightedImage = [UIImage imageNamed:@"bomb.png"];
    
    UIImageView *selectView = (UIImageView *)[cell viewWithTag:2];

    if ([self.selectassets member:indexPath]) {
        NSLog(@"indexpath=%@",indexPath);
        selectView.highlighted =true;
        selectView.image  = [UIImage imageNamed:@"AGIPC-Checkmark-iPhone.png"];
        
    }else
    {
        selectView.highlighted = false;
        selectView.image  = [UIImage imageNamed:@"AGIPC-UnCheckmark-iPhone.png"];
    }
    
//    imageView.userInteractionEnabled = true;
  
//    UIButton *buttonView = (UIButton *)[cell viewWithTag:2];
//    
//    [buttonView addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    buttonView.tag = indexPath.row;
    //因为没有设置image属性，为了显示出图片覆盖区域 imgView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                              action:@selector(handleTap:)];
    singleTap.delegate = self;
    [cell addGestureRecognizer:singleTap];
//
      return cell;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
   // NSLog(@"%@", [self.collectionView indexPathForItemAtPoint:[touch locationInView:self.collectionView]]);
    //NSLog(@"%f", [touch locationInView:touch.view].x);
   // - (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if (!CGRectContainsPoint(CGRectMake(40, 0, 30, 30),[touch locationInView:touch.view])) {
        return NO;
    }
    
    //添加到indexpath中
    
    return  YES;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    
    UICollectionViewCell *cell  = (UICollectionViewCell *)recognizer.view;
  //  NSLog(@"%@", [self.collectionView indexPathForItemAtPoint:[recognizer locationInView:self.collectionView]]);
    
    NSIndexPath *selectPath =[self.collectionView indexPathForItemAtPoint:[recognizer locationInView:self.collectionView]];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];

    if ([self.selectassets member:selectPath]) {
        imageView.highlighted =false;
        imageView.image  = [UIImage imageNamed:@"AGIPC-UnCheckmark-iPhone.png"];
        [self.selectassets removeObject:selectPath];
    }
    else
    {
        [self.selectassets addObject:[self.collectionView indexPathForItemAtPoint:[recognizer locationInView:self.collectionView]]];
        
        imageView.highlighted = true;
        imageView.image  = [UIImage imageNamed:@"AGIPC-Checkmark-iPhone.png"];
    }
    
    [self setNumlabelandButton];
}

-(void)setNumlabelandButton
{
    if([self.selectassets count]==0)
    {
        self.numLabel.hidden = true;
        self.completeButton.enabled = false;
    }
    else
    {
        self.numLabel.text =[NSString stringWithFormat:@"%ld",[self.selectassets count]];
        self.numLabel.hidden = false;
        self.completeButton.enabled = true;
        
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
}
#pragma mark - Segue support

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showPhoto"]) {
        
        // hand off the assets of this album to our singleton data source
        [PageViewControllerData sharedInstance].photoAssets = self.assets;
        [PageViewControllerData sharedInstance].selectAssets = self.selectassets;
        [PageViewControllerData sharedInstance].isFilter = NO;
        [PageViewControllerData sharedInstance].isOrigin = NO;
         [PageViewControllerData sharedInstance].isUrlPath = NO;
                // start viewing the image at the appropriate cell index
        MyPageViewController *pageViewController = [segue destinationViewController];
        NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
        pageViewController.startingIndex = selectedCell.row;
        //pageViewController.
        
    }
}
- (IBAction)preViewClick:(id)sender {
    
//    MyPageViewController *pageViewController = [segue destinationViewController];
//    NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
//    pageViewController.startingIndex = selectedCell.row;
    if(self.selectassets.count >0)
    {
        [PageViewControllerData sharedInstance].isFilter = YES;
        [PageViewControllerData sharedInstance].photoAssets = self.assets;
        [PageViewControllerData sharedInstance].selectAssets = self.selectassets;
    // start viewing the image at the appropriate cell index
        MyPageViewController *pageViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"MypageViewController"];
    //NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
        pageViewController.startingIndex = 0 ;
        pageViewController.checkButton.hidden = YES;
        [self.navigationController pushViewController:pageViewController animated:YES];
        
    }


}
- (IBAction)completeClick:(id)sender {
    
    if(self.popToViewController)
    {
        NSMutableArray *imageList =[[NSMutableArray alloc]init];
        for (NSIndexPath *path in self.selectassets) {
            ALAsset *photoAsset =  self.assets[path.row];
            
           ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
//            
            UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                           scale:[assetRepresentation scale]
                                                    orientation:ALAssetOrientationUp];
           // [imageList addObject:photoAsset];
            [imageList addObject:fullScreenImage];
        }
    [self.popToViewController setImageList:imageList];
    [self.navigationController popToViewController:(UIViewController *)self.popToViewController animated:YES];
    }
  
}

@end

