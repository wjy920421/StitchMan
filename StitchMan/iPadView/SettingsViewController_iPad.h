//
//  SettingsViewController.h
//  StitchMan
//
//  Created by wjy on 13-8-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController_iPad : UIViewController
{
    @public
    BOOL isCylindricalProjection;
}

@property (nonatomic,strong) IBOutlet UISwitch *cylindricalSwitch;

@end
