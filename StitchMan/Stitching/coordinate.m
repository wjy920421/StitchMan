//
//  coordinate.m
//  StitchMan
//
//  Created by he qiyun on 13-07-27.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "coordinate.h"

@implementation coordinate

-(id)initWithKeypoint:(Keypoint *)keypoint{
    if (self = [super init]) {
        /*
        x = round(keypoint->x);
        y = round(keypoint->y);*/
        x = keypoint->x;
        y = keypoint->y;
    }
    return self;
}

-(id)initWIthKeypointAndChange:(Keypoint *)keypoint
                        height:(int)height
                         width:(int)width{

    if (self = [super init]) {
        /*
        double xx = round(keypoint->x);
        double yy = round(keypoint->y);*/
        double xx = keypoint->x;
        double yy = keypoint->y;
        x = xx - width/2;
        y = height/2 - yy;
        //printf("x : %d y : %d\n",x,y);
    }
    return self;
}

+(coordinate *)changeToNormal:(coordinate *)p
                       height:(int)height
                        width:(int)width{    
    p->x = p->x - width/2;
    p->y = height/2 - p->y;
    return p;
}

+(coordinate *)changeToReverse:(coordinate *)p
                        height:(int)height
                         width:(int)width{
    p->x = p->x + width/2;
    p->y = height/2 - p->y;
    return p;
}




@end
