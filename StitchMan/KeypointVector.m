//
//  KeypointVector.m
//  StitchMan
//
//  Created by wjy on 13-7-6.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "KeypointVector.h"

@implementation KeypointVector

- (id)initWithPyramid:(Pyramid *)pyramid
{
    if(self=[super init]){
        keypoints=[[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)locate:(Pyramid *)pyramid
{
    
}

- (Keypoint *)getKeypointAtIndex:(int)index __attribute((ns_returns_retained))
{
    return [keypoints objectAtIndex:index];
}

- (int)getLength
{
    return [keypoints count];
}

@end
