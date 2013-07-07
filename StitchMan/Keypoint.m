//
//  Keypoint.m
//  StitchMan
//
//  Created by wjy on 13-7-5.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "Keypoint.h"

@implementation Keypoint

- (id)initWithX:(int)x1 Y:(int)y1
{
    if(self=[super init]){
        x=x1;
        y=y1;
        
    }
    return self;
}

- (id)initWithX:(int)x Y:(int)y Octave:(int)octave_num Interval:(int)interval_num
{
    if(self=[super init]){
        
    }
    return self;
}

- (void)print
{
    printf("Keypoint at: %d %d\n",y,x);
}

@end
