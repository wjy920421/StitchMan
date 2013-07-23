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

@interface ViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImage *image;
    //UIImageView *imageView;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

-(IBAction)openImage;

@end
