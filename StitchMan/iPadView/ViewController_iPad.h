//
//  ViewController-iPad.h
//  StitchMan
//
//  Created by wjy on 13-7-29.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController_iPad;

@class StitchViewController_iPad;

@class FeaturesViewController_iPad;

@class MatchViewController_iPad;

@interface ViewController_iPad : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *imageView[20];
    UIImage *uiimage[20];
    
    int imageNum;
    int imageViewSpace;
    int imageViewLength;
    int scrollViewLength;
    
    BOOL isCylindricalProjection;
}

@property (strong,nonatomic) SettingsViewController_iPad *settingsView;

@property (strong,nonatomic) StitchViewController_iPad *stitchViewController_iPad;

@property (strong,nonatomic) FeaturesViewController_iPad *featuresViewController_iPad;

@property (strong,nonatomic) MatchViewController_iPad *matchViewController_iPad;

@property (nonatomic,strong) IBOutlet UIScrollView  *scrollView;

@property (nonatomic,strong) UIPopoverController *popover;

- (IBAction)changeSettings:(id)sender;

- (IBAction)openImage:(id)sender;

- (IBAction)clearView:(id)sender;

- (IBAction)switchToStitchView:(id)sender;

- (IBAction)switchToFeaturesView:(id)sender;

- (IBAction)switchToMatchView:(id)sender;

@end
