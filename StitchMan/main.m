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
#import "RANSAC.h"
#import "Stitcher.h"
#import "CylindricalProjection.h"
#import "UIImageConverter.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        /*
        UIImage *uiimage1=[UIImage imageWithContentsOfFile:@"/Users/wjy/Desktop/stadium2.png"];
        UIImage *uiimage2=[UIImage imageWithContentsOfFile:@"/Users/wjy/Desktop/stadium1.png"];
        
        
        uiimage1=[CylindricalProjection transform:uiimage1 Theta:PI/4];
        uiimage2=[CylindricalProjection transform:uiimage2 Theta:PI/4];
        
        
        ImageMatrix *im1=[ImageConverter UIImage2Luminance:uiimage1];
        ImageMatrix *im2=[ImageConverter UIImage2Luminance:uiimage2];
        
        SIFT *sift1=[[SIFT alloc] initWithImageMatrix:im1];
        SIFT *sift2=[[SIFT alloc] initWithImageMatrix:im2];
        
        UIImage *siftimage1=[sift1 outputUIImage];
        UIImage *siftimage2=[sift2 outputUIImage];
        [UIImagePNGRepresentation(siftimage1) writeToFile:@"/Users/wjy/Desktop/sift1.png"
                                            atomically:YES];
        [UIImagePNGRepresentation(siftimage2) writeToFile:@"/Users/wjy/Desktop/sift2.png"
                                            atomically:YES];
        
        Match *match=[[Match alloc] initWithSIFT1:sift1 SIFT2:sift2];
        
        UIImage *immatch=[match output];
        [UIImagePNGRepresentation(immatch) writeToFile:@"/Users/wjy/Desktop/match.png"
                                            atomically:YES];
        
        RANSAC *ransac=[[RANSAC alloc] initWithMatch:match];
        
        double *h=ransac->homography;
        printf("Homography:\n%f %f %f\n%f %f %f\n%f %f %f\n",
               h[0],h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]);
        
        UIImage * imout=[Stitcher stitch:uiimage1 And:uiimage2 UsingHomography:ransac->homography];
        
        [UIImagePNGRepresentation(imout) writeToFile:@"/Users/wjy/Desktop/stitching.png"
                                          atomically:YES];
        */
         
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
