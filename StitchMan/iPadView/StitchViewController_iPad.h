//
//  StitchViewController_iPad.h
//  StitchMan
//
//  Created by wjy on 13-7-30.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StitchViewController_iPad : UIViewController
{
    @public
    int imageNum;
    UIImage *uiimage[20];
    UIImage *stitchedImage;
    
    BOOL isCylindricalProjection;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IBOutlet UITextView *consoleView;

-(IBAction)switchToMainView:(id)sender;

@end
