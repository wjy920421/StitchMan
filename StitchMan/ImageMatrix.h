//
//  ImageMatrix.h
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageMatrix : NSObject
{
    double *pImage;
    int imageWidth;
    int imageHeight;
}

- (id)initWithHeight:(int)imageHeight Width:(int)imageWidth;

- (id)initWithUIImage:(UIImage *)uiimage;

- (id)initWithArray:(double *)array Height:(int)height Width:(int)width;

- (id)initWithImageMatrix:(ImageMatrix *)im;

- (id)initWithImageMatrix:(ImageMatrix *)im Subtract:(ImageMatrix *)im2;

- (id)initWithImageMatrixByDownsampling:(ImageMatrix *)im Factor:(int)factor;

- (double)getValueAtHeight:(int)height Width:(int)width;

- (int)getHeight;

- (int)getWidth;

- (void)setValueAtHeight:(int)height Width:(int)width Value:(double)value;



- (void)print;

@end
