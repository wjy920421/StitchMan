//
//  Keypoint.h
//  StitchMan
//
//  Created by wjy on 13-7-5.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Pyramid.h"
@interface Keypoint : NSObject
{
    NSMutableArray *keypoints;
}

- (id)initWithPyramid:(Pyramid *)pyramid;

@end
