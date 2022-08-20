//
//  UIImageConverter.m
//  StitchMan
//
//  Created by he qiyun on 13-07-09.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "UIImageConverter.h"

@implementation UIImageConverter
+(UIImage *)data2UIImage:(unsigned char*)rawData
                  height:(int)height
                   width:(int)width{

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(rawData, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    
    CFRelease(colorSpace);
    CGImageRelease(cgImage);
    CGContextRelease(bitmapContext);
    
    return resultImage;
}

+(unsigned char*)UIImage2Data:(UIImage *)im{

    CGImageRef imageRef = im.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    unsigned char *rawData = malloc(height * width * 4);
    bzero(rawData,height*width*4);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return rawData;

}

+ (UIImage *)expandUIImage:(UIImage *)originalImage withSize:(int)size
{
    int width = originalImage.size.width;
    int height = originalImage.size.height;
    unsigned char *rawData = [UIImageConverter UIImage2Data:originalImage];
    unsigned char *newData = [UIImageConverter expandRawData:rawData Height:height Width:width
                                                    withSize:size];
    
    UIImage *result = [UIImageConverter data2UIImage:newData
                                              height:height+2*size
                                               width:width+2*size];
    
    free(rawData);
    free(newData);
    
    return result;
}

+ (unsigned char *)expandRawData:(unsigned char *)rawData Height:(int)height Width:(int)width
                        withSize:(int)size;
{
    return [UIImageConverter expandRawData:rawData Height:height Width:width
                                       Top:size Bottom:size Left:size Right:size];
}

+ (unsigned char *)expandRawData:(unsigned char *)rawData Height:(int)height Width:(int)width
                             Top:(int)top Bottom:(int)bottom Left:(int)left Right:(int)right
{
    int imageHeight=height+top+bottom;
    int imageWidth=width+left+right;
    int old_index;
    int new_index;
    
    unsigned char *newData=malloc(sizeof(unsigned char)*4*imageWidth*imageHeight);
    
    for(int i=0;i<imageHeight;i++){
        for(int j=0;j<imageWidth;j++){
            new_index=4*(i*imageWidth+j);
            old_index=4*((i-top)*width+j-left);
            
            if(i>=top && imageHeight-i-1>=bottom && j>=left && imageWidth-j-1>=right
               /*&& rawData[old_index+3]!=0*/){
                newData[new_index]=rawData[old_index];
                newData[new_index+1]=rawData[old_index+1];
                newData[new_index+2]=rawData[old_index+2];
                newData[new_index+3]=rawData[old_index+3];
            }
            else{
                newData[new_index]=newData[new_index+1]=newData[new_index+2]=newData[new_index+3]=0;
            }
        }
    }
    
    return newData;
}

@end
