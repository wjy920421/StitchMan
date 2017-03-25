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
    if(self=[super init]){
        image1FeaturesDetected=FALSE;
        image2FeaturesDetected=FALSE;
    }
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

- (IBAction)detectFeatures
{
    if(!image1FeaturesDetected && image[0]!=nil){
        ImageMatrix *im=[ImageConverter UIImage2Luminance:image[0]];
        SIFT *sift=[[SIFT alloc] initWithImageMatrix:im];
        self.imageView1.image=[ImageConverter Luminance2UIImage:[sift originalImage]
                                                       withMark:[sift output]];
        image1FeaturesDetected=TRUE;
    }
    if(!image2FeaturesDetected && image[1]!=nil){
        ImageMatrix *im=[ImageConverter UIImage2Luminance:image[1]];
        SIFT *sift=[[SIFT alloc] initWithImageMatrix:im];
        self.imageView2.image=[ImageConverter Luminance2UIImage:[sift originalImage]
                                                       withMark:[sift output]];
        image2FeaturesDetected=TRUE;
    }
}

-(IBAction)match
{
    if(image[0]!=nil && image[1]!=nil){
        /*
        CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
        CGContextRef context=UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextMoveToPoint(context,100,100);
        CGContextAddLineToPoint(context,500,500);
        CGContextStrokePath(context);
        
        CFRelease(colorSpace);
        CGContextRelease(context);
        */
    }
}


- (IBAction)openImage
{
    if(image[0]!=nil && image[1]!=nil)
        return;
    
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(image[0]==nil){
        image[0]=[info objectForKey:UIImagePickerControllerOriginalImage];
        self.imageView1.image=image[0];
    }
    else{
        image[1]=[info objectForKey:UIImagePickerControllerOriginalImage];
        self.imageView2.image=image[1];
    }
    /*
    ImageMatrix *imageMatrix=[ImageConverter UIImage2ImageMatrixY:image[0]];
    SIFT *sift=[[SIFT alloc] initWithImageMatrix:imageMatrix];
    self.imageView1.image=[ImageConverter Luminance2UIImage:[sift originalImage]
                                                  withMark:[sift output]];
    */
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //NSLog(@"Image size: %.0f x %.0f",image[0].size.width,image[0].size.height);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"No Image is picked up.");
}

@end
