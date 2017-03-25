//
//  ImageConverter.m
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ImageConverter.h"

@implementation ImageConverter

+ (ImageMatrix *)UIImage2Luminance:(UIImage *)uiimage
__attribute((ns_returns_retained))
{
    
    CGImageRef imageRef = uiimage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    unsigned char *rawData = malloc(height * width * 4);
    float *grayscale = malloc(sizeof(float) * height * width);
    bzero(rawData,height*width*4);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CFRelease(colorSpace);
    CGContextRelease(context);
    
    for (int i=0; i<height; i++) {
        for(int j=0;j<width;j++){
            
        int k=i*width+j;
        if(rawData[4*k+3]!=0)
            grayscale[k] = (0.299 * (float)rawData[4*k] + 0.587 * (float)rawData[4*k+1] + 0.114 * (float)rawData[4*k+2]);
        else
            grayscale[k]=-1;
        
        }
    }
    
    ImageMatrix * output = [[ImageMatrix alloc] initWithArray:grayscale
                                                       Height:height
                                                        Width:width];
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(grayscale);
    grayscale=NULL;
    
    return output;
}

+ (UIImage *) Luminance2UIImage:(ImageMatrix *)im __attribute((ns_returns_retained))
{
    int i,j;
    int height = im->imageHeight;
    int width = im->imageWidth;
    unsigned char *rawData = malloc(height * width * 4);
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            int k = i*width+j;
            if(im->pImage[k]>=0){
                rawData[4*k] = (unsigned char)im->pImage[k];
                rawData[4*k+1] = (unsigned char)im->pImage[k];
                rawData[4*k+2] = (unsigned char)im->pImage[k];
                rawData[4*k+3] = (unsigned char)255;
            }
            else{
                rawData[4*k] = 0;
                rawData[4*k+1] = 0;
                rawData[4*k+2] = 0;
                rawData[4*k+3] = 0;
            }
        }
    }
    
    // build uiimage
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(rawData, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    
    CFRelease(colorSpace);
    CGImageRelease(cgImage);
    CGContextRelease(bitmapContext);
    
    //release memory
    free(rawData);
    rawData=NULL;
    
    return resultImage;
}

+ (UIImage *) Luminance2UIImage:(ImageMatrix *)im withMark:(ImageMatrix *)mark
__attribute((ns_returns_retained))
{
    int i,j,threshold=180;
    int height = im->imageHeight;
    int width = im->imageWidth;
    NSUInteger totalPixel = width * height;
    float *grayscale = malloc(sizeof(float) * height * width);
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            grayscale[i * width + j] = im->pImage[i*im->imageWidth+j];
            
        }
    }
    unsigned char *rawData = malloc(height * width * 4);
    for (int i=0; i<totalPixel; i++) {
        int j = 4*i;
        if((int)mark->pImage[i]>threshold){
            rawData[j]=255;
            rawData[j+1]=0;
            rawData[j+2]=0;
            rawData[j+3]=200;
        }
        else{
            rawData[j] = (unsigned char)grayscale[i];
            rawData[j+1] = (unsigned char)grayscale[i];
            rawData[j+2] = (unsigned char)grayscale[i];
            rawData[j+3] = (unsigned char)255;
        }
    }
    
    // build uiimage
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(rawData, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    CFRelease(colorSpace);
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(grayscale);
    grayscale=NULL;
    
    return resultImage;
    
    
    
}


@end

