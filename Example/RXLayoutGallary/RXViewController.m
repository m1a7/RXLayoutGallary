//
//  RXViewController.m
//  RXLayoutGallary
//
//  Created by m1a7 on 02/15/2018.
//  Copyright (c) 2018 m1a7. All rights reserved.
//

#import "RXViewController.h"
#import <RXLayoutGallary/RXLayoutGallary.h>

// Another fraemwork for opening photo like detail view
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <NYTPhotoViewer/NYTPhotoViewerArrayDataSource.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

// Own model
#import "RXExamplePhoto.h"


@interface RXViewController () <RXLayoutGallaryDelegate, NYTPhotosViewControllerDelegate, NYTPhotoViewerDataSource>

@property (weak, nonatomic) IBOutlet UIView *viewForURLGallary;
@property (weak, nonatomic) IBOutlet UIView *viewForLocalGallary;

@property (nonatomic, strong) NSArray* urlImages;
@property (nonatomic, strong) NSArray* localImages;

@property (nonatomic, strong) NSMutableArray<RXExamplePhoto*>* imageForNYTPhotosVC;
@property (nonatomic, strong) NSNumber *numberOfPhotos;
@property (nonatomic, strong) UIImageView *touchedImgView;

@property (nonatomic, strong) NSOperationQueue *imageOperationQueue;
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation RXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageOperationQueue = [[NSOperationQueue alloc]init];
    self.imageOperationQueue.maxConcurrentOperationCount = 5;
    self.imageCache = [[NSCache alloc] init];
    
    /*
    Use wrapper "RXExtendedImage" if you want to add a description to the picture.
       In this format, you can add.
        picture by url
        gif     by url
        UIImage
        NSData
    */
    RXExtendedImage* ex1 = [[RXExtendedImage alloc] initWithURL:@"https://media.giphy.com/media/l1J3pT7PfLgSRMnFC/giphy.gif" andIsGIF:YES];
    ex1.title   = @"Cat";
    ex1.summary = @"Bro";
    ex1.credit  = @"Fist pound";
    
    
    RXExtendedImage* ex2 = [[RXExtendedImage alloc] initWithURL:@"https://pp.userapi.com/c841233/v841233896/58028/UVgZp5SAuT0.jpg" andIsGIF:NO];
    ex2.title = @"It is fucking swift !";

    
    self.urlImages =   @[
                @"https://media.giphy.com/media/3oxHQqcNQCa2pUgAp2/giphy.gif",
                @"https://pp.userapi.com/c628824/v628824080/4b885/EHKvKapd1NI.jpg",
                ex1,
                ex2
                ];
     self.localImages = @  [
                            [[RXExtendedImage alloc] initWithImage:[UIImage imageNamed:@"st1"]],
                            [NSData dataWithContentsOfFile:  [[NSBundle mainBundle] pathForResource: @"giphy" ofType: @"gif"]],
                            [UIImage imageNamed:@"st3"],
                            [UIImage imageNamed:@"st4"],
                            [UIImage imageNamed:@"st5"]];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //////////////////////////////////////////////////////////////////////
    //                                                                  //
    //  Attention!!                                                     //
    //                                                                  //
    //   You can add from 1 to 5 photos to RXLayoutGallary              //
    //                                                                  //
    //   You can add any formats to RXLayoutGallary                     //
    //  (NSData / UIImage / UIImageView / NSString aka URL)             //
    //  (RXExtendedImage / FLAnimatedImageView / FLAnimatedImage        //
    //                                                                  //
    //////////////////////////////////////////////////////////////////////

    
    // Gallary by URL
    RXLayoutGallary* gallaryURL =[[RXLayoutGallary alloc] initWithFrame:self.viewForURLGallary.bounds andDelegate:self];
    gallaryURL.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleWidth      | UIViewAutoresizingFlexibleHeight;

    [self.viewForURLGallary addSubview:gallaryURL];
    [gallaryURL addImagesFromMixArray:self.urlImages];
    
    
    // Gallary by local image
    RXLayoutGallary* gallaryLocalImages = [[RXLayoutGallary alloc] initWithFrame:self.viewForLocalGallary.bounds andDelegate:self];
    gallaryLocalImages.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                          UIViewAutoresizingFlexibleWidth      | UIViewAutoresizingFlexibleHeight;
    [self.viewForLocalGallary addSubview:gallaryLocalImages];
    [gallaryLocalImages addUIImagesToGallary:self.localImages];
}

#pragma mark - GallaryViewDelegate

-(void) rxgallaryView:(RXLayoutGallary *)rxlayoutGallary didTapAtImageView:(UIImageView *)imageView sourceObject:(id)sourceImage atIndex:(NSUInteger)index
{
    /*
    This is an optional code. This is an example of how to open images from a full-screen RXLayoutGallary
    */
    self.imageForNYTPhotosVC = [NSMutableArray new];;
    self.numberOfPhotos      = [NSNumber numberWithInteger:rxlayoutGallary.imagesArray.count];
    self.touchedImgView      = imageView;
    
    [rxlayoutGallary.imagesArray enumerateObjectsUsingBlock:^(id  _Nonnull imgFromGallary, NSUInteger idx, BOOL * _Nonnull stop) {
        
        RXExamplePhoto *p = [RXExamplePhoto new];
        
        //Ask if in our second array source Images Array the object RX Extended Image
        // If so, set RXExamplePhoto text properti
        if ([[rxlayoutGallary.sourceImagesArray objectAtIndex:idx] isKindOfClass:[RXExtendedImage class]])
        {
            RXExtendedImage* exImgView = (RXExtendedImage*)[rxlayoutGallary.sourceImagesArray objectAtIndex:idx];
            
            if (exImgView.title)    p.attributedCaptionTitle   =  [RXViewController attributedTitleFromString:exImgView.title];
            if (exImgView.summary)  p.attributedCaptionSummary =  [RXViewController attributedSummaryFromString:exImgView.summary];
            if (exImgView.credit)   p.attributedCaptionCredit  =  [RXViewController attributedCreditFromString:exImgView.credit];
            
        }
        // And further everything as according to the plan, we ask if in our main array images Array
        // Lies the FLAnimatedImageView object, then such actions
        if ([imgFromGallary isKindOfClass:[FLAnimatedImageView class]])
        {
            FLAnimatedImageView* flaImgView = (FLAnimatedImageView*)imgFromGallary;
            [self.imageForNYTPhotosVC addObject:({
                p.imageData = flaImgView.animatedImage.data;
                p;
            })];
        } else
            // If the UIImageView object is Lying, then such actions
            if ([imgFromGallary isKindOfClass:[UIImageView class]])
            {
                UIImageView* imageView = (UIImageView*)imgFromGallary;
                [self.imageForNYTPhotosVC addObject:({
                    p.image = imageView.image;
                    p;
                })];
            }
        // And it could only lie UIImageView or FLAnimatedImageView
    }];
    
    NYTPhotosViewController* vc = [[NYTPhotosViewController alloc] initWithDataSource:self
                                                                    initialPhotoIndex:index
                                                                             delegate:self];
    [self presentViewController:vc animated:YES completion:nil];
    
}

/*
 Methods are optional. But they increase productivity when working with a table. Using cache
*/
-(NSData*) getDataFromCacheByURL:(NSString*) urlStr
{
    return  [self.imageCache objectForKey:urlStr];
}
-(NSOperationQueue*) getOperationQueue
{
    return self.imageOperationQueue;
}
-(void) writeToCacheData:(NSData*) data urlKey:(NSString*) key
{
    [self.imageCache setObject:data forKey:key];
}


#pragma mark - NYTPhotoViewerDataSource
/*
 The NYTPhotoViewerDataSource Methods. To display full screen pictures
*/
- (NSInteger)indexOfPhoto:(id <NYTPhoto>)photo {
    return [self.imageForNYTPhotosVC indexOfObject:photo];
}

- (nullable id <NYTPhoto>)photoAtIndex:(NSInteger)photoIndex
{
    if (self.imageForNYTPhotosVC.count > photoIndex){
        return [self.imageForNYTPhotosVC objectAtIndex:photoIndex];
    }
    return  nil;
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo {
    return self.touchedImgView;
}
- (void)photosViewController:(NYTPhotosViewController *)photosViewController didNavigateToPhoto:(id <NYTPhoto>)photo atIndex:(NSUInteger)photoIndex {
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType {
}

- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController {
}


#pragma mark - Helpers

+ (NSAttributedString *)attributedTitleFromString:(NSString *)caption {
    return [[NSAttributedString alloc] initWithString:caption attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
}
+ (NSAttributedString *)attributedSummaryFromString:(NSString *)summary {
    return [[NSAttributedString alloc] initWithString:summary attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
}

+ (NSAttributedString *)attributedCreditFromString:(NSString *)credit {
    return [[NSAttributedString alloc] initWithString:credit attributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]}];
}



      
      
@end
