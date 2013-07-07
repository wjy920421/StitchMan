//
//  Pyramid.h
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Convolution.h"
#import "ImageMatrix.h"
#import "ImageConverter.h"

@interface Pyramid : NSObject
{
    int octaveNum;
    int intervalNum;
    double sigma[30];
    
    int originalHeight;
    int originalWidth;
    ImageMatrix *originalImage;
    
    NSMutableArray *gaussianPyramid;
    NSMutableArray *differenceOfGaussianPyramid;
}

- (id)initWithImageMatrix:(ImageMatrix *)originalImage;

- (int)getOctaveNum;

- (int)getIntervalNum;

@end
