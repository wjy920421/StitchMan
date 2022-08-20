//
//  RANSAC.h
//  StitchMan
//
//  Created by wjy on 13-7-28.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Keypoint.h"
#import "Match.h"
#import "ImageMatrix.h"

@interface RANSAC : NSObject
{
@private
    ImageMatrix *imageMatrix1;
    ImageMatrix *imageMatrix2;
    
    int size;
    NSMutableArray *keypoints1;
    NSMutableArray *keypoints2;
    int width1;
    int height1;
    int width2;
    int height2;
    
@public
    double homography[9];
    /*
    Keypoint *keypoint1_1;
    Keypoint *keypoint1_2;
    Keypoint *keypoint1_3;
    Keypoint *keypoint1_4;
    
    Keypoint *keypoint2_1;
    Keypoint *keypoint2_2;
    Keypoint *keypoint2_3;
    Keypoint *keypoint2_4;*/
}

- (id)initWithMatch:(Match *)match;

@end
