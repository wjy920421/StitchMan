//
//  ViewController-iPad.m
//  StitchMan
//
//  Created by wjy on 13-7-29.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ViewController_iPad.h"
#import "StitchViewController_iPad.h"
#import "FeaturesViewController_iPad.h"
#import "MatchViewController_iPad.h"
#import "SettingsViewController_iPad.h"

#import <QuartzCore/QuartzCore.h>

@interface ViewController_iPad ()

@end

@implementation ViewController_iPad

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
	// Do any additional setup after loading the view.
    
    imageViewSpace=20;
    imageNum=0;
    scrollViewLength=self.scrollView.frame.size.width+1;
    imageViewLength=imageViewSpace;
    
    isCylindricalProjection=NO;
    
    //scroll view
    self.scrollView.showsHorizontalScrollIndicator=YES;
    self.scrollView.bounces=YES;
    self.scrollView.contentSize=CGSizeMake(scrollViewLength,self.scrollView.frame.size.height);
    [self.view insertSubview:self.scrollView atIndex:0];
    
    //background
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    [self.scrollView setBackgroundColor:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)switchToStitchView:(id)sender
{
    if(imageNum<2)
        return;
    
    self.stitchViewController_iPad=nil;
    self.stitchViewController_iPad=[[StitchViewController_iPad alloc] initWithNibName:@"StitchView_iPad"
                                                                               bundle:nil];
    
    self.stitchViewController_iPad->imageNum=imageNum;
    for(int i=0;i<imageNum;i++)
        self.stitchViewController_iPad->uiimage[i]=uiimage[i];
    if(self.settingsView!=nil)
        isCylindricalProjection=self.settingsView->isCylindricalProjection;
    self.stitchViewController_iPad->isCylindricalProjection=isCylindricalProjection;
    
    [self.view addSubview:self.stitchViewController_iPad.view];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:animation forKey:@"Animation"];
    
    [self clearView:nil];
}

- (IBAction)switchToFeaturesView:(id)sender
{
    if(imageNum==0)
        return;
    
    self.featuresViewController_iPad=nil;
    self.featuresViewController_iPad=[[FeaturesViewController_iPad alloc]
                                      initWithNibName:@"FeaturesView_iPad"
                                      bundle:nil];
    
    self.featuresViewController_iPad->imageNum=imageNum;
    for(int i=0;i<imageNum;i++)
        self.featuresViewController_iPad->uiimage[i]=uiimage[i];
    
    [self.view addSubview:self.featuresViewController_iPad.view];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:animation forKey:@"Animation"];
    
    [self clearView:nil];
}

- (IBAction)switchToMatchView:(id)sender
{
    if(imageNum<2)
        return;
    
    self.matchViewController_iPad=nil;
    self.matchViewController_iPad=[[MatchViewController_iPad alloc] initWithNibName:@"MatchView_iPad"
                                                                               bundle:nil];
    
    for(int i=0;i<2;i++)
        self.matchViewController_iPad->uiimage[i]=uiimage[i];
    
    [self.view addSubview:self.matchViewController_iPad.view];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:animation forKey:@"Animation"];
    
    [self clearView:nil];
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

- (IBAction)changeSettings:(id)sender
{
    if(self.popover!=nil && self.popover.isPopoverVisible==YES){
        [self.popover dismissPopoverAnimated:YES];
        self.popover=nil;
        return;
    }
    
    if(self.settingsView==nil){
    self.settingsView=[[SettingsViewController_iPad alloc] initWithNibName:@"SettingsView_iPad" bundle:nil];
    self.settingsView->isCylindricalProjection=isCylindricalProjection;
    }
    UIPopoverController *po=[[UIPopoverController alloc] initWithContentViewController:self.settingsView];
    self.popover=po;
    [self.popover presentPopoverFromBarButtonItem:sender
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
}

- (IBAction)openImage:(id)sender
{
    if(imageNum>=20)
        return;
    
    if(self.popover!=nil && self.popover.isPopoverVisible==YES){
        [self.popover dismissPopoverAnimated:YES];
        self.popover=nil;
        return;
    }
    
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIPopoverController *po=[[UIPopoverController alloc] initWithContentViewController:picker];
        self.popover=po;
        [self.popover presentPopoverFromBarButtonItem:sender
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    uiimage[imageNum]=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self addUIImage:uiimage[imageNum]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self.popover dismissPopoverAnimated:YES];
    //self.popover=nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self.popover dismissPopoverAnimated:YES];
    //self.popover=nil;
}


- (IBAction)clearView:(id)sender
{
    for(int i=0;i<imageNum;i++){
        [imageView[i] removeFromSuperview];
        imageView[i]=nil;
        uiimage[i]=nil;
    }
    
    imageViewSpace=20;
    imageNum=0;
    scrollViewLength=self.scrollView.frame.size.width+1;
    imageViewLength=imageViewSpace;
    self.scrollView.contentSize=CGSizeMake(scrollViewLength,self.scrollView.frame.size.height);
}


- (void)projectionChanged
{
    isCylindricalProjection=YES;
}

@end
