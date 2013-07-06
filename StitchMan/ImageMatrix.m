//
//  ImageMatrix.m
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ImageMatrix.h"

@implementation ImageMatrix


- (id)initWithUIImage:(UIImage *)uiimage
{
    if(self=[super init]){
        
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithArray:(double *)array Height:(int)height Width:(int)width
{
    if(self=[super init]){
        imageWidth=width;
        imageHeight=height;
        pImage=malloc(sizeof(double)*imageHeight*imageWidth);
        for(int i=0;i<imageHeight;i++)
            for(int j=0;j<imageWidth;j++)
                pImage[i*imageWidth+j]=array[i*imageWidth+j];
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithImageMatrix:(ImageMatrix *)im
{
    if(self=[super init]){
        imageWidth=im->imageWidth;
        imageHeight=im->imageHeight;
        pImage=malloc(sizeof(double)*imageHeight*imageWidth);
        bzero(pImage,sizeof(double)*imageHeight*imageWidth);
        for(int i=0;i<imageHeight;i++)
            for(int j=0;j<imageWidth;j++)
                pImage[i*imageWidth+j]=[im getValueAtHeight:i Width:j];
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithImageMatrix:(ImageMatrix *)im Subtract:(ImageMatrix *)im2
{
    if(self=[super init]){
        imageWidth=im->imageWidth;
        imageHeight=im->imageHeight;
        pImage=malloc(sizeof(double)*imageHeight*imageWidth);
        bzero(pImage,sizeof(double)*imageHeight*imageWidth);
        for(int i=0;i<imageHeight;i++)
            for(int j=0;j<imageWidth;j++)
                pImage[i*imageWidth+j]
                =[im getValueAtHeight:i Width:j]-[im2 getValueAtHeight:i Width:j];
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithImageMatrixByDownsampling:(ImageMatrix *)im Factor:(int)factor
{
    if(self=[super init]){
        imageWidth=im->imageWidth/factor;
        imageHeight=im->imageHeight/factor;
        pImage=malloc(sizeof(double)*imageHeight*imageWidth);
        bzero(pImage,sizeof(double)*imageHeight*imageWidth);
        for(int i=0;i<imageHeight;i++)
            for(int j=0;j<imageWidth;j++)
                pImage[i*imageWidth+j]=[im getValueAtHeight:((i+1)*factor-1)
                                                      Width:((j+1)*factor-1)];
        //NSLog(@"init");
    }
    return self;
}

- (id)initWithHeight:(int)height Width:(int)width
{
    if(self=[super init]){
        imageWidth=width;
        imageHeight=height;
        pImage=malloc(sizeof(double)*imageHeight*imageWidth);
        bzero(pImage,sizeof(double)*imageHeight*imageWidth);
        //NSLog(@"init");
    }
    return self;
}

- (void)dealloc
{
    if(pImage!=NULL){
        free(pImage);
        pImage=NULL;
        //NSLog(@"dealloc");
    }
}


- (double)getValueAtHeight:(int)height Width:(int)width
{
    return pImage[height*imageWidth+width];
}

- (int)getHeight
{
    return imageHeight;
}

-(int)getWidth
{
    return imageWidth;
}

- (void)setValueAtHeight:(int)height Width:(int)width Value:(double)value
{
    pImage[height*imageWidth+width]=value;
}



- (void)print
{
    for(int i=0;i<imageHeight;i++){
        for(int j=0;j<imageWidth;j++){
            printf("%-7.2f ",pImage[i*imageWidth+j]);
        }
        printf("\n");
    }
    printf("\n");
}

@end
