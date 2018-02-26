//
//  RXExamplePhoto.h
//  RXLayoutGallary_Example
//
//  Created by Uber on 16/02/2018.
//  Copyright © 2018 m1a7. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <NYTPhotoViewer/NYTPhoto.h>


@interface RXExamplePhoto : NSObject <NYTPhoto>

// Redeclare all the properties as readwrite for sample/testing purposes.
@property (nonatomic) UIImage *image;
@property (nonatomic) NSData *imageData;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
@property (nonatomic) NSAttributedString *attributedCaptionSummary;
@property (nonatomic) NSAttributedString *attributedCaptionCredit;

@end
