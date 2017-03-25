//
//  ViewController.h
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SIFT.h"
#import "Match.h"


@class StitchViewController;

@interface ViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImage *image[2];
    BOOL image1FeaturesDetected;
    BOOL image2FeaturesDetected;
}

@property (strong, nonatomic) StitchViewController *stitchViewController;

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;

@property (strong, nonatomic) IBOutlet UIImageView *imageView2;

- (IBAction)switchToStitchView:(id)sender;

- (IBAction)openImage;

- (IBAction)match;

- (IBAction)detectFeatures;

@end
