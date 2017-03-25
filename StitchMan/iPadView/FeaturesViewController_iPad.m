//
//  FeaturesViewController_iPad.m
//  StitchMan
//
//  Created by wjy on 13-7-31.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "FeaturesViewController_iPad.h"
#import "SIFT.h"

#import <QuartzCore/QuartzCore.h>

@interface FeaturesViewController_iPad ()

@end

@implementation FeaturesViewController_iPad

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
    
    imageViewSpace=20;
    scrollViewLength=self.scrollView.frame.size.width+1;
    imageViewLength=imageViewSpace;
    
    //scroll view
    self.scrollView.showsHorizontalScrollIndicator=YES;
    self.scrollView.bounces=YES;
    self.scrollView.contentSize=CGSizeMake(scrollViewLength,self.scrollView.frame.size.height);
    [self.view insertSubview:self.scrollView atIndex:0];
    
    //background
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    [self.scrollView setBackgroundColor:nil];
    
    //detect features
    NSThread *thread=[[NSThread alloc]initWithTarget:self
                                                selector:@selector(detectFeatures)
                                                  object:nil];
    [thread start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)detectFeatures
{
    int tmp=imageNum;
    imageNum=0;
    for(int i=0;i<tmp;i++) {
        ImageMatrix *mat=[ImageConverter UIImage2Luminance:uiimage[i]];
        SIFT *sift=[[SIFT alloc] initWithImageMatrix:mat];
        uiimage[i]=[sift outputUIImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addUIImage:uiimage[i]];
        });
    }
    
}

- (void)addUIImage:(UIImage *)im
{
    int max=(im.size.height>im.size.width)?im.size.height:im.size.width;
    int width=360.0*im.size.width/max;
    int height=360.0*im.size.height/max;
    
    imageView[imageNum]=[[UIImageView alloc] initWithFrame:CGRectMake(imageViewLength,imageViewSpace,width,height)];
    [[imageView[imageNum] layer] setMasksToBounds:YES];
    [[imageView[imageNum] layer] setBorderWidth:3];
    [[imageView[imageNum] layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [imageView[imageNum] setImage:im];
    [self.scrollView addSubview:imageView[imageNum]];
    
    imageNum++;
    imageViewLength+=imageViewSpace+width;
    scrollViewLength=(scrollViewLength>imageViewLength)?scrollViewLength:imageViewLength;
    self.scrollView.contentSize=CGSizeMake(scrollViewLength,self.scrollView.frame.size.height);
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
    
    for(int i=0;i<imageNum;i++){
        uiimage[i]=nil;
        imageView[i].image=nil;
    }
    imageNum=0;
    //self.consoleView.text=nil;
}

@end
