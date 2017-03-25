//
//  StitcherUsingHomography.h
//  StitchMan
//
//  Created by he qiyun on 13-07-27.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stitcher : NSObject
{
    UIImage *uiimage1;
    UIImage *uiimage2;
}

+ (UIImage *)stitch:(UIImage *)im1 And:(UIImage *)im2 UsingHomography:(double *)hmography;

+ (UIImage *)stitch:(UIImage *)im1 And:(UIImage *)im2;

@end
