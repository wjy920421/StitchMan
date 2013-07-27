//
//  StitchViewController.m
//  StitchMan
//
//  Created by wjy on 13-7-26.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "StitchViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface StitchViewController ()

@end

@implementation StitchViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)switchToMainView:(id)sender
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.superview.layer addAnimation:animation forKey:@"Animation"];
    [self.view removeFromSuperview];
    
}

@end
