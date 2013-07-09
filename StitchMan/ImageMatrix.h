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
    @public
    float *pImage;
    int imageWidth;
    int imageHeight;
}

- (id)initWithHeight:(int)imageHeight Width:(int)imageWidth;

- (id)initWithUIImage:(UIImage *)uiimage;

- (id)initWithArray:(float *)array Height:(int)height Width:(int)width;

- (id)initWithImageMatrix:(ImageMatrix *)im;

- (id)initWithImageMatrix:(ImageMatrix *)im Subtract:(ImageMatrix *)im2;

- (id)initWithImageMatrixByDownsampling:(ImageMatrix *)im Factor:(int)factor;

- (void)expandWithValue:(float)value
                    Top:(int)top Bottom:(int)bottom
                   Left:(int)left Right:(int)right;

//- (float)getValueAtHeight:(int)height Width:(int)width;

//- (int)getHeight;

//- (int)getWidth;

//- (void)setValueAtHeight:(int)height Width:(int)width Value:(float)value;



- (void)print;

@end
