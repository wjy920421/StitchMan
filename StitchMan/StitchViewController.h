//
//  StitchViewController.h
//  StitchMan
//
//  Created by wjy on 13-7-26.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StitchViewController : UIViewController
{
    @public
    UIImage *image[2];
}

-(IBAction)switchToMainView:(id)sender;

@end
