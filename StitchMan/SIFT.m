//
//  SIFT.m
//  StitchMan
//
//  Created by wjy on 13-7-6.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "SIFT.h"

@implementation SIFT

- (id)initWithImageMatrix:(ImageMatrix *)im
{
    if(self=[super init]){
        imageMatrix=[[ImageMatrix alloc] initWithImageMatrix:im];
        [self buildPyramid];
        //[pyramid output];
        //[self detectKeypoints];
    }
    return self;
}

- (void)buildPyramid
{
    pyramid=[[Pyramid alloc] initWithImageMatrix:imageMatrix];
}

- (void)detectKeypoints
{
    keypointVector=[[KeypointVector alloc] initWithPyramid:pyramid];
}

@end
