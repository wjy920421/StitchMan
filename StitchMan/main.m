//
//  main.m
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

//test
#import "SIFT.h"
#import "Match.h"


int main(int argc, char *argv[])
{
    @autoreleasepool {
        
        UIImage *uiimage1=[UIImage imageWithContentsOfFile:@"/Users/wjy/Desktop/lena1.tiff"];
        UIImage *uiimage2=[UIImage imageWithContentsOfFile:@"/Users/wjy/Desktop/lena4.tiff"];
        ImageMatrix *im1=[ImageConverter UIImage2ImageMatrixY:uiimage1];
        ImageMatrix *im2=[ImageConverter UIImage2ImageMatrixY:uiimage2];
        
        SIFT *sift1=[[SIFT alloc] initWithImageMatrix:im1];
        SIFT *sift2=[[SIFT alloc] initWithImageMatrix:im2];
        
        Match *match=[[Match alloc] initWithSIFT1:sift1 SIFT2:sift2];
        UIImage *imout=[match output];
        NSData *data=UIImagePNGRepresentation(imout);
        NSString *str=[[NSString alloc] initWithFormat:@"/Users/wjy/Desktop/lena_match.png"];
        [[NSFileManager defaultManager] createFileAtPath:str contents:data attributes:nil];
        
         
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
