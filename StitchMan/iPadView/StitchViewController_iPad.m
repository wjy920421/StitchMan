//
//  StitchViewController_iPad.m
//  StitchMan
//
//  Created by wjy on 13-7-30.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "StitchViewController_iPad.h"
#import "Stitcher.h"
#import "SIFT.h"
#import "Match.h"
#import "RANSAC.h"
#import "CylindricalProjection.h"

#import <QuartzCore/QuartzCore.h>

@interface StitchViewController_iPad ()

@end

@implementation StitchViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //background
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    
    //configure image view
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    //configure console view
    self.consoleView.editable=NO;
    self.consoleView.backgroundColor=[UIColor blackColor];
    self.consoleView.textColor=[UIColor whiteColor];
    self.consoleView.font=[UIFont fontWithName:@"Courier-Bold" size:16];
    self.consoleView.text=[[NSString alloc] initWithFormat:@""];
    
    //stitch images
    NSThread *thread=[[NSThread alloc]initWithTarget:self
                                            selector:@selector(stitchImages)
                                              object:nil];
    [thread start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stitchImages
{
    if(imageNum==2){
        if(isCylindricalProjection){
            [self addTextToConsole:@"Now projecting images to cylindrical space.\n"];
            uiimage[0]=[CylindricalProjection transform:uiimage[0] Theta:PI/3];
            uiimage[1]=[CylindricalProjection transform:uiimage[1] Theta:PI/3];
            [self addTextToConsole:@"Done.\n\n"];
        }
        
        ImageMatrix *im1=[ImageConverter UIImage2Luminance:uiimage[0]];
        ImageMatrix *im2=[ImageConverter UIImage2Luminance:uiimage[1]];
        
        [self addTextToConsole:@"Now detecting feature points in images.\n"];
        SIFT *sift1=[[SIFT alloc] initWithImageMatrix:im1];
        SIFT *sift2=[[SIFT alloc] initWithImageMatrix:im2];
        [self addTextToConsole:@"Done.\n\n"];
        
        [self addTextToConsole:@"Now matching features in images.\n"];
        Match *match=[[Match alloc] initWithSIFT1:sift1 SIFT2:sift2];
        [self addTextToConsole:@"Done.\n\n"];
        
        [self addTextToConsole:@"Now performing RANSAC to find best matches.\n"];
        RANSAC *ransac=[[RANSAC alloc] initWithMatch:match];
        [self addTextToConsole:@"Done.\n\n"];
        
        [self addTextToConsole:@"Now stitching images.\n"];
        stitchedImage=[Stitcher stitch:uiimage[0] And:uiimage[1] UsingHomography:ransac->homography];
        [self addTextToConsole:@"Done!\n\n"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image=stitchedImage;
        });
    }
}

- (IBAction)switchToMainView:(id)sender
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.superview.layer addAnimation:animation forKey:@"Animation"];
    [self.view removeFromSuperview];
    
    for(int i=0;i<imageNum;i++)
        uiimage[i]=nil;
    imageNum=0;
    stitchedImage=nil;
    self.imageView.image=nil;
    self.consoleView.text=nil;
}

- (void)addTextToConsole:(NSString *)str
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.consoleView.text=[self.consoleView.text stringByAppendingString:str];
    });
}

@end
