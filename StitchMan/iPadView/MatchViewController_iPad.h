//
//  MatchViewController_iPad.h
//  StitchMan
//
//  Created by wjy on 13-7-31.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchViewController_iPad : UIViewController
{
    @public
    //int imageNum;
    UIImage *uiimage[2];
    UIImage *matchedImage;
}

@property (nonatomic,strong) IBOutlet UIImageView *imageView;

- (IBAction)switchToMainView:(id)sender;

@end
