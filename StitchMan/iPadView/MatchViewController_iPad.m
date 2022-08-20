//
//  MatchViewController_iPad.m
//  StitchMan
//
//  Created by wjy on 13-7-31.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "MatchViewController_iPad.h"
#import "Match.h"

#import <QuartzCore/QuartzCore.h>

@interface MatchViewController_iPad ()

@end

@implementation MatchViewController_iPad

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
    
    //stitch images
    NSThread *thread=[[NSThread alloc]initWithTarget:self
                                            selector:@selector(match)
                                              object:nil];
    [thread start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)match
{
    ImageMatrix *im1=[ImageConverter UIImage2Luminance:uiimage[0]];
    ImageMatrix *im2=[ImageConverter UIImage2Luminance:uiimage[1]];
    
    SIFT *sift1=[[SIFT alloc] initWithImageMatrix:im1];
    SIFT *sift2=[[SIFT alloc] initWithImageMatrix:im2];
    
    Match *match=[[Match alloc] initWithSIFT1:sift1 SIFT2:sift2];
    
    matchedImage=[match output];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image=matchedImage;
    });
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
    
    for(int i=0;i<2;i++)
        uiimage[i]=nil;
    matchedImage=nil;
    self.imageView.image=nil;
}

@end
