//
//  FeaturesViewController_iPad.h
//  StitchMan
//
//  Created by wjy on 13-7-31.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturesViewController_iPad : UIViewController
{
    @public
    UIImageView *imageView[20];
    UIImage *uiimage[20];
    
    int imageNum;
    int imageViewSpace;
    int imageViewLength;
    int scrollViewLength;
}

@property (nonatomic,strong) IBOutlet UIScrollView  *scrollView;

- (IBAction)switchToMainView:(id)sender;

@end
