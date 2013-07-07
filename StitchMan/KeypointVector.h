//
//  KeypointVector.h
//  StitchMan
//
//  Created by wjy on 13-7-6.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Pyramid.h"
#import "Keypoint.h"

@interface KeypointVector : NSObject
{
    NSMutableArray *keypoints;
}

- (id)initWithPyramid:(Pyramid *)pyramid;

- (Keypoint *)getKeypointAtIndex:(int)index __attribute((ns_returns_retained));

- (int)getLength;

@end
