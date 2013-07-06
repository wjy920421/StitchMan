//
//  ImageConverter.m
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ImageConverter.h"

@implementation ImageConverter

+ (ImageMatrix *)UIImage2ImageMatrixY:(UIImage *)uiimage
__attribute((ns_returns_retained))
{
    
    CGImageRef imageRef = uiimage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger totalPixel = width * height;
    unsigned char *rawData = malloc(height * width * 4);
    double *grayscale = malloc(sizeof(double) * height * width);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    
    int count=0;
    for(int i=0;i<height*width*4;i++){
        int x = rawData[i];
        if (x!=0) {
            count++;
        }
        //    printf("%d\n",x);
    }
    
    for (int i=0; i<totalPixel; i++) {
        int j=4*i;
        grayscale[i] = (0.299 * (int)rawData[j] + 0.587 * (int)rawData[j+1] + 0.114 * (int)rawData[j+2]);
        
        
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

+ (ImageMatrix *)UIImage2ImageMatrixU:(UIImage *)uiimage
__attribute((ns_returns_retained))
{
    
    CGImageRef imageRef = uiimage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger totalPixel = width * height;
    unsigned char *rawData = malloc(height * width * 4);
    double *componentU = malloc(sizeof(double) * height * width);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    for (int i=0; i<totalPixel; i++) {
        int j=4*i;
        componentU[i] = -0.09991 * (int)rawData[j] -  0.33609* (int)rawData[j+1] + 0.436 * (int)rawData[j+2];
        
    }
    
    ImageMatrix * output = [[ImageMatrix alloc] initWithArray:componentU
                                                       Height:height
                                                        Width:width];
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(componentU);
    componentU=NULL;
    
    return output;
}

+ (ImageMatrix *)UIImage2ImageMatrixV:(UIImage *)uiimage
__attribute((ns_returns_retained))
{
    
    CGImageRef imageRef = uiimage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger totalPixel = width * height;
    unsigned char *rawData = malloc(height * width * 4);
    double *componentV = malloc(sizeof(double) * height * width);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    for (int i=0; i<totalPixel; i++) {
        int j=4*i;
        componentV[i] = 0.615 * (int)rawData[j] - 0.58861 * (int)rawData[j+1] - 0.05639 * (int)rawData[j+2];
        
    }
    
    ImageMatrix * output = [[ImageMatrix alloc] initWithArray:componentV
                                                       Height:height
                                                        Width:width];
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(componentV);
    componentV=NULL;
    
    
    return output;
}

+ (ImageMatrix *)UIImage2ImageMatrixAlpha:(UIImage *)uiimage
__attribute((ns_returns_retained))
{
    
    CGImageRef imageRef = uiimage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger totalPixel = width * height;
    unsigned char *rawData = malloc(height * width * 4);
    double *componentAlpha = malloc(sizeof(double) * height * width);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    for (int i=0; i<totalPixel; i++) {
        int j=4*i;
        componentAlpha[i] = (int)rawData[j+3];
        
    }
    
    ImageMatrix * output = [[ImageMatrix alloc] initWithArray:componentAlpha
                                                       Height:height
                                                        Width:width];
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(componentAlpha);
    componentAlpha=NULL;
    
    
    return output;
}

+ (UIImage *) Luminance2UIImage:(ImageMatrix *)im __attribute((ns_returns_retained))
{
    int i,j;
    int height = im.getHeight;
    int width = im.getWidth;
    NSUInteger totalPixel = width * height;
    double *grayscale = malloc(sizeof(double) * height * width);
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            grayscale[i * width + j] = [im getValueAtHeight:i
                                                      Width:j];
            
        }
    }
    unsigned char *rawData = malloc(height * width * 4);
    for (int i=0; i<totalPixel; i++) {
        int j = 4*i;
        rawData[j] = (unsigned char)grayscale[i];
        rawData[j+1] = (unsigned char)grayscale[i];
        rawData[j+2] = (unsigned char)grayscale[i];
        rawData[j+3] = (unsigned char)255;
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


+ (UIImage *) ImageMatrix2UIImage:(ImageMatrix *)im
                       componentU:(ImageMatrix *)U
                       componentV:(ImageMatrix *)V
                   componentAlpha:(ImageMatrix *)Alpha
{
    int i,j;
    int height = im.getHeight;
    int width = im.getWidth;
    NSUInteger totalPixel = width * height;
    double *grayscale = malloc(sizeof(double) * height * width);
    double *componentU = malloc(sizeof(double) * height * width);
    double *componentV = malloc(sizeof(double) * height * width);
    double *componentAlpha = malloc(sizeof(double) * height * width);
    
    //grayscale = im.returnGrayScale;
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            grayscale[i * width + j] = [im getValueAtHeight:i
                                                      Width:j];
            
        }
    }
    
    
    //componentU = im.returnComponentU;
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            componentU[i * width + j] = [U getValueAtHeight:i
                                                      Width:j];
        }
    }
    //componentV = im.returnComponentV;
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            componentV[i * width + j] = [V getValueAtHeight:i
                                                      Width:j];
        }
    }
    //componentAlpha = im.returnComponentAlpha;
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            componentAlpha[i * width + j] = [Alpha getValueAtHeight:i
                                                              Width:j];
            
        }
    }
    unsigned char *rawData = malloc(height * width * 4);
    for (int i=0; i<totalPixel; i++) {
        int j = 4*i;
        rawData[j] = (unsigned char)(grayscale[i] + 1.28033*componentV[i]);
        rawData[j+1] = (unsigned char)(grayscale[i] - 0.21482*componentU[i] - 0.38059*componentV[i]);
        rawData[j+2] = (unsigned char)(grayscale[i] + 2.12798*componentU[i]);
        rawData[j+3] = (unsigned char)componentAlpha[i];
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
    free(componentU);
    componentU=NULL;
    free(componentV);
    componentV=NULL;
    free(componentAlpha);
    componentAlpha=NULL;
    
    return resultImage;
}

@end

