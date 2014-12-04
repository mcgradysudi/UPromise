/*
     File: PageViewControllerData.m
 Abstract: Data source that manages the array of ALAsset objects.
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

#import "PageViewControllerData.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import "UIImageView+OnlineImage.h"
@implementation PageViewControllerData

+ (PageViewControllerData *)sharedInstance
{
    static dispatch_once_t onceToken;
    static PageViewControllerData *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[PageViewControllerData alloc] init];
        sSharedInstance.isFilter = false;
        sSharedInstance.isOrigin = false;
        sSharedInstance.isUrlPath = false;
    });
    
    
    return sSharedInstance;
}

- (NSUInteger)photoCount
{
    return !self.isFilter?self.photoAssets.count:self.selectAssets.count;
}

- (UIImage *)photoAtIndex:(NSUInteger)index
{
    ALAsset *photoAsset = self.photoAssets[index];
    
    ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
    
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                   scale:[assetRepresentation scale]
                                             orientation:ALAssetOrientationUp];
    return fullScreenImage;
}

- (NSString *)stringAtIndex:(NSUInteger)index
{
    return self.photoAssets[index];
    
}
- (UIImage *)photoAtOriginIndex:(NSUInteger)index
{
    UIImage *tempImage = [[UIImage alloc]init];
    
    UIImageView *tempView = [[UIImageView alloc]init];
   // [tempView setOnlineImage:self.photoAssets[index] placeholderImage:tempImage];
    return tempImage;
    return  (UIImage *)self.photoAssets[index];
    
}
- (UIImage *)photoAtIndex:(NSUInteger)index isFilter:(BOOL) isfilter
{
   
    
    if (self.isOrigin) {
        return  [self photoAtOriginIndex:index];
    }
    
    if(!self.isFilter)
    {
       return  [self photoAtIndex:index];
    }
    
   
    NSIndexPath *tempPath = self.selectAssets.allObjects[index];
    
    
    ALAsset *photoAsset = self.photoAssets[tempPath.row];
    
    ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
    
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                   scale:[assetRepresentation scale]
                                             orientation:ALAssetOrientationUp];
    return fullScreenImage;
}
-(BOOL)isSelectImage:(NSIndexPath *)index
{
    if (!self.isFilter) {
        return [self.selectAssets member:index]?YES:NO;
    }
    return YES;
}
-(void)removeSelect:(NSInteger)index
{
   // NSMutableSet* selectAssets =  [PageViewControllerData sharedInstance].selectAssets;
    NSIndexPath *indexPath = !self.isFilter?[NSIndexPath indexPathForRow:index inSection:0]:self.selectAssets.allObjects[index];

    
    if([self.selectAssets member:indexPath])
    {
        [self.selectAssets removeObject:indexPath];
    }
    else
    {
        [self.selectAssets addObject:indexPath];
    }
    
}
@end
