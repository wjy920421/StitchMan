//
//  Keypoint.h
//  StitchMan
//
//  Created by wjy on 13-7-5.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keypoint : NSObject
{
    @public
    int x;
    int y;
    
    int octave_num;
    int interval_num;
    
    unsigned char descriptor[4][4][8];
    
    float theta;
    
}

- (id)initWithX:(int)x Y:(int)y Octave:(int)octave_num Interval:(int)interval_num;

- (id)initWithKeypoint:(Keypoint *)keypoint;

- (void)print;

@end
