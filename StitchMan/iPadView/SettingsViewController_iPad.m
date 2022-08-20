//
//  SettingsViewController.m
//  StitchMan
//
//  Created by wjy on 13-8-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "SettingsViewController_iPad.h"

@interface SettingsViewController_iPad ()

@end

@implementation SettingsViewController_iPad

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
    
    //frame
    int height=self.view.frame.size.height;
    int width=self.view.frame.size.width;
    self.contentSizeForViewInPopover=CGSizeMake(width,height);
    
    //set switch
    if(isCylindricalProjection){
        self.cylindricalSwitch.on=YES;
    }
    else{
        self.cylindricalSwitch.on=NO;
    }
    
    //background
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    
    [self.cylindricalSwitch addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchChanged
{
    if(self.cylindricalSwitch.on==YES)
        isCylindricalProjection=YES;
    else
        isCylindricalProjection=NO;
}

@end
