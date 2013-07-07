//
//  Convolution.h
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageMatrix.h"

@interface Convolution : NSObject
{
    //unsigned char *result;
    //unsigned char *gaussianFilter;
}

+ (ImageMatrix *)conv:(ImageMatrix *)target filter:(ImageMatrix *)filter
__attribute((ns_returns_retained));

+ (ImageMatrix *)convWithGaussian:(ImageMatrix *)target
sigma:(double)sigma filterSize:(int)filterSize
__attribute((ns_returns_retained));

+ (ImageMatrix *)convWithGaussianFast:(ImageMatrix *)target
sigma:(double)sigma filterSize:(int)filterSize
__attribute((ns_returns_retained));

+ (ImageMatrix *)getGaussianFilter:(double) sigma
filterSize:(int)filterSize
__attribute((ns_returns_retained));

@end
