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
    unsigned char descriptor[4][4][8];
    
    double theta;
    
}

- (id)initWithX:(int)x Y:(int)y;

- (id)initWithX:(int)x Y:(int)y Octave:(int)octave_num Interval:(int)interval_num;

- (void)print;

@end
