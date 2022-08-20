//
//  Match.m
//  StitchMan
//
//  Created by wjy on 13-7-12.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "Match.h"

@implementation Match

- (id)initWithSIFT1:(SIFT *)s1 SIFT2:(SIFT *)s2
{
    if(self=[super init]){
        imageMatrix1=s1->imageMatrix;
        imageMatrix2=s2->imageMatrix;
        keypointVector1=s1->keypointVector;
        keypointVector2=s2->keypointVector;
        
        [self matchKeypoints];
    }
    return self;
}

- (void)matchKeypoints
{
    int length1=[keypointVector1->keypoints count];
    int length2=[keypointVector2->keypoints count];
    double diff;
    double dist1,dist2;
    int index;
    Keypoint *kp1,*kp2;
    
    //size=(length1>=length2)?length2:length1;
    size=0;
    
    //build match vectors
    matchVector1=[[NSMutableArray alloc] init];
    matchVector2=[[NSMutableArray alloc] init];
    
    for(int i=0;i<length1;i++){
        kp1=[keypointVector1->keypoints objectAtIndex:i];
        dist1=dist2=10000000;
        index=-1;
        for(int j=0;j<length2;j++){
            kp2=[keypointVector2->keypoints objectAtIndex:j];
            diff=[self euclideanDistanceBetweenKeypoint1:kp1 Keypoint2:kp2];
            
            if(diff<dist1){
                dist2=dist1;
                dist1=diff;
                index=j;
            }
            else if(diff<dist2){
                dist2=diff;
            }
        }
        if(dist1<0.36*dist2){
            size++;
            
            [matchVector1 addObject:kp1];
            [matchVector2 addObject:[keypointVector2->keypoints objectAtIndex:index]];
        }
    }
    
    printf("%d matches are found.\n",size);
}

- (double)euclideanDistanceBetweenKeypoint1:(Keypoint *)kp1 Keypoint2:(Keypoint *)kp2
{
    double sum=0;
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
            for(int k=0;k<8;k++)
                sum+=(kp1->descriptor[i][j][k]-kp2->descriptor[i][j][k])
                *(kp1->descriptor[i][j][k]-kp2->descriptor[i][j][k]);
    return sum;
}

- (UIImage *)output
{
    int i,j;
    int height1 = imageMatrix1->imageHeight;
    int width1 = imageMatrix1->imageWidth;
    int height2 = imageMatrix2->imageHeight;
    int width2 = imageMatrix2->imageWidth;
    int space=50;
    int height = (height1>=height2)?height1:height2;
    int width = width1 + width2 +space;
    float *mat = malloc(sizeof(float) * height * width);
    unsigned char *rawData=malloc(height * width * 4);
    
    for (i=0; i<height; i++) {
        for(j=0;j<width;j++){
            int index=i*width+j;
            
            if(i<height1 && j<width1){
                rawData[4*index]=(unsigned char)imageMatrix1->pImage[i*imageMatrix1->imageWidth+j];
                rawData[4*index+1]=(unsigned char)imageMatrix1->pImage[i*imageMatrix1->imageWidth+j];
                rawData[4*index+2]=(unsigned char)imageMatrix1->pImage[i*imageMatrix1->imageWidth+j];
                rawData[4*index+3]=(unsigned char)255;
            }
            else if(i<height2 && j>=width-width2){
                rawData[4*index]=(unsigned char)imageMatrix2->pImage[i*imageMatrix2->imageWidth+j-width1-space];
                rawData[4*index+1]=(unsigned char)imageMatrix2->pImage[i*imageMatrix2->imageWidth+j-width1-space];
                rawData[4*index+2]=(unsigned char)imageMatrix2->pImage[i*imageMatrix2->imageWidth+j-width1-space];
                rawData[4*index+3]=255;
            }
            else{
                rawData[4*index]=0;
                rawData[4*index+1]=0;
                rawData[4*index+2]=0;
                rawData[4*index+3]=0;
            }
        }
    }
    
    // build uiimage
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(rawData, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    
    //CGContextSetLineWidth(bitmapContext,5);
    CGContextSetStrokeColorWithColor(bitmapContext, [[UIColor redColor] CGColor]);
    
    //draw matches
    for(int i=0;i<size;i++){
            Keypoint *kp1=[matchVector1 objectAtIndex:i];
            Keypoint *kp2=[matchVector2 objectAtIndex:i];
            
            CGFloat x1=kp1->x;
            CGFloat y1=height-1-kp1->y;
            CGFloat x2=kp2->x+width1+space;
            CGFloat y2=height-1-kp2->y;
            CGContextMoveToPoint(bitmapContext,x1,y1);
            CGContextAddLineToPoint(bitmapContext,x2,y2);
    }
    
    CGContextStrokePath(bitmapContext);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    output = [UIImage imageWithCGImage:cgImage];
    
    
    CFRelease(colorSpace);
    CGContextRelease(bitmapContext);
    CGImageRelease(cgImage);
    
    //release memory
    free(rawData);
    rawData=NULL;
    free(mat);
    mat=NULL;
    
    return output;
}

@end
