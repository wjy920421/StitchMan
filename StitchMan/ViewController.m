//
//  ViewController.m
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ViewController.h"
#import "StitchViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize stitchViewController;

//@synthesize imageView;

- (id)init
{
    self=[super init];
    //imageView=[[UIImageView alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)switchToStitchView:(id)sender
{
    if(self.stitchViewController==nil){
        self.stitchViewController=[[StitchViewController alloc] initWithNibName:@"StitchView"
                                                                         bundle:nil];
    }
    
    [self.view addSubview:self.stitchViewController.view];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:animation forKey:@"Animation"];
    
    stitchViewController->image[0]=image[0];
    stitchViewController->image[1]=image[1];
}

- (IBAction)openImage
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image[0]=[info objectForKey:UIImagePickerControllerOriginalImage];
    //self.imageView.image=image;
    ImageMatrix *imageMatrix=[ImageConverter UIImage2ImageMatrixY:image[0]];
    //[imageMatrix print];
    
    SIFT *sift=[[SIFT alloc] initWithImageMatrix:imageMatrix];
    self.imageView1.image=[ImageConverter Luminance2UIImage:[sift originalImage]
                                                  withMark:[sift output]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Image size: %.0f x %.0f",image[0].size.width,image[0].size.height);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"No Image is picked up.");
}

@end
