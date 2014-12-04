/*
     File: ImageScrollView.m
 Abstract: Centers image within the scroll view and configures image sizing and display.
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

#import "ImageScrollView.h"
#import "PageViewControllerData.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "DACircularProgressView.h"

//#import "UIImageView+OnlineImage.h"
@interface ImageScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *zoomView;  // contains the full image

@property CGSize imageSize;

@property CGPoint pointToCenterAfterResize;
@property CGFloat scaleToRestoreAfterResize;

@property (strong, nonatomic) DACircularProgressView *progressView;

@end


#pragma mark -

@implementation ImageScrollView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.isFilter = false;
        
        self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 220.0f, 40.0f, 40.0f)];
        [self addSubview:self.progressView];
        
    }
    return self;
}

- (void)setIndex:(NSUInteger)index {
    
    _index = index;
    
    //NSString *stringImage
    PageViewControllerData *pageController = [PageViewControllerData sharedInstance];
    if (pageController.isUrlPath) {
        [self displayImagefromString:[pageController stringAtIndex:index]];
        
    }
    else{
        UIImage *image = [[PageViewControllerData sharedInstance] photoAtIndex:index isFilter:self.isFilter];
    
        [self displayImage:image];
    }
}

+ (NSUInteger)imageCount {
    
    return [[PageViewControllerData sharedInstance] photoCount];
}

- (void)layoutSubviews  {
    
    [super layoutSubviews];
    
    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _zoomView.frame;
    
 //   NSLog(@"framesize1:%d，%@",self.index,NSStringFromCGSize(_zoomView.frame.size));
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
    {
        frameToCenter.origin.x = 0;
        frameToCenter.size.width = boundsSize.width;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
    {
        frameToCenter.origin.y = 0;
        frameToCenter.size.height = boundsSize.height;
    }
    
    _zoomView.frame = frameToCenter;
    _progressView.center = _zoomView.center;
    
  //  NSLog(@"framesize2:%@,index=%d",NSStringFromCGRect(frameToCenter),self.index);
    
}

- (void)setFrame:(CGRect)frame {
    
  //  NSLog(@"setframe:%@,%d",NSStringFromCGRect(frame),self.index);
    
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (sizeChanging) {
        [self recoverFromResizing];
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _zoomView;
}


#pragma mark - Configure scrollView to display new image

- (void)displayImage:(UIImage *)image {
    
    // clear the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;

    // make a new UIImageView for the new image
    _zoomView = [[UIImageView alloc] initWithImage:image];
    //_zoomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
   // [_zoomView sd_setImageWithURL:[NSURL URLWithString:@"http://imgs.veeqi.com/img05/png/071223/02/Badge_Icons_012.png"] placeholderImage:[UIImage imageNamed:@""]];
   // CGRect frameToCenter = _zoomView.frame;
    //[_zoomView setOnlineImage:@"http://"];
   // [self addSubview:_zoomView];
    [self insertSubview:_zoomView belowSubview:self.progressView];
    //self insertSubview:_zoomView aboveSubview:<#(UIView *)#>
    [self configureForImageSize:image.size];
}

- (void)displayImagefromString:(NSString *)imageString {
    
    // clear the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    // make a new UIImageView for the new image
    _zoomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placehold.png"]];
    _zoomView.contentMode = UIViewContentModeScaleToFill;
  //   NSLog(@"zoomview new=%p index=%d",_zoomView,self.index);
    
    //_zoomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    NSString *url =[imageString stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
    
    //UIImage *originImage = nil;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:imageString
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
         if (image)
         {
             // do something with image
             _zoomView.image = image;
         }
     }];
    
    
    //  NSString *url =[imageString stringByReplacingOccurrencesOfString:@"" withString:@""];

    
    [_zoomView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:_zoomView.image
                          options:SDWebImageRetryFailed
                         progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         CGFloat progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
         self.progressView.progress = progress;
        
         
         if (self.progressView.progress > 1.0f||receivedSize == expectedSize)
         {
             self.progressView.hidden =YES;
         }

         
     }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        
//        NSLog(@"imagesize:%@,%d",NSStringFromCGSize(image.size),self.index);
//        NSLog(@"frameset:%@",NSStringFromCGRect(_zoomView.frame));
        if (!image) {
            
        }
        else
        {
         dispatch_async(dispatch_get_main_queue(), ^{
             CGRect frame = CGRectMake(_zoomView.frame.origin.x, _zoomView.frame.origin.y, image.size.width, image.size.height);
             
           //  NSLog(@"frame:%@,zoomfram:%@，index=%d,zooview=%p",NSStringFromCGRect(frame),NSStringFromCGRect(_zoomView.frame),self.index,_zoomView);
             
              [self displayImage:image];
            // self.progressView.hidden =YES;
             
             
       // _zoomView.frame = CGRectMake(_zoomView.frame.origin.x, _zoomView.frame.origin.y, image.size.width, image.size.height);
         });
        }
        
        self.progressView.hidden =YES;
        
        //[self configureForImageSize:image.size];
        
    }];;

  //  _zoomView.contentMode = UIViewContentModeScaleAspectFit;
    
   // [_zoomView setOnlineImage:imageString];
    [self insertSubview:_zoomView belowSubview:self.progressView];
   // [self addSubview:_zoomView];
    //UIImage *image = _zoomView.image;
    
    [self configureForImageSize:_zoomView.image.size];
}

- (void)configureForImageSize:(CGSize)imageSize {
    
    _imageSize = imageSize;
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    
    CGSize boundsSize = self.bounds.size;
                
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width  / _imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / _imageSize.height;   // the scale needed to perfectly fit the image height-wise
    
    // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
    BOOL imagePortrait = _imageSize.height > _imageSize.width;
    BOOL phonePortrait = boundsSize.height > boundsSize.width;
    CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];

    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        minScale = maxScale;
    }
        
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}


#pragma mark - Methods called during rotation to preserve the zoomScale and the visible portion of the image

- (void)prepareToResize {
    
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:_zoomView];

    _scaleToRestoreAfterResize = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing {
    
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:_zoomView];

    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);

    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset {
    
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset {
    
    return CGPointZero;
}

@end
