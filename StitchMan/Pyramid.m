//
//  Pyramid.m
//  StitchMan
//
//  Created by wjy on 13-7-3.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "Pyramid.h"

@implementation Pyramid

- (void)dealloc
{
    
}

- (id)initWithImageMatrix:(ImageMatrix *)oi
{
    if(self=[super init]){
        //get original image
        originalImage=oi;
        originalHeight=[originalImage getHeight];
        originalWidth=[originalImage getWidth];
        
        intervalNum=3;
        sigma[0]=1.6;
        
        //set sigma values
        [self setSigma];
        
        //get octave number
        [self setOctaveNum];
        
        //build pyramid
        gaussianPyramid=[[NSMutableArray alloc] init];
        
        for(int i=0;i<=octaveNum;i++){
            for(int j=0;j<intervalNum+3;j++){
                //gaussian pyramid
                ImageMatrix *newGaussian=[self buildImageMatrixAtOctave:i Interval:j];
                
                //difference of gaussian
                if(j!=0){
                    ImageMatrix *previousGaussian=[gaussianPyramid lastObject];
                    ImageMatrix *newDog=[[ImageMatrix alloc]
                                         initWithImageMatrix:newGaussian
                                         Subtract:previousGaussian];
                    [differenceOfGaussianPyramid addObject:newDog];
                }
                
                [gaussianPyramid addObject:newGaussian];
            }
        }
        
        //test
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSData *data;
        for(int i=0;i<=octaveNum;i++){
            for(int j=0;j<intervalNum+3;j++){
                //gaussian pyramid
                int index=i*(intervalNum+3)+j;
                ImageMatrix *im=[gaussianPyramid objectAtIndex:index];
                UIImage *uiimage=[ImageConverter Luminance2UIImage:im];
                data=UIImagePNGRepresentation(uiimage);
                NSString *str
                =[[NSString alloc] initWithFormat:@"/Users/wjy/Desktop/output/%d.png",index];
                [fileManager createFileAtPath:str
                                     contents:data
                                   attributes:nil];
            }
        }
        //end
        
        gaussianPyramid=nil;
    }
    return self;
}

- (ImageMatrix *)buildImageMatrixAtOctave:(int)octave_num Interval:(int)interval_num
__attribute((ns_returns_retained))
{
    ImageMatrix *output;
    int height=originalHeight;
    int width=originalWidth;
    
    //get height and width
    for(int i=0;i<octave_num;i++){
        height=height/2;
        width=width/2;
    }
    //init image matrix
    output=[[ImageMatrix alloc] initWithHeight:height Width:width];
    
    if(interval_num==0){
        if(octave_num==0){
            output=[[ImageMatrix alloc] initWithImageMatrix:originalImage];
        }
        else{
            int index=(octave_num-1)*(intervalNum+3)+intervalNum;
            ImageMatrix *previousMatrix=[gaussianPyramid objectAtIndex:index];
            output=[[ImageMatrix alloc] initWithImageMatrixByDownsampling:previousMatrix
                                                                   Factor:2];
        }
    }
    else{
        int index=octave_num*(intervalNum+3)+interval_num-1;
        ImageMatrix *previousMatrix=[gaussianPyramid objectAtIndex:index];
        int filterSize=ceil(6*sigma[interval_num]+1);
        
        if(filterSize>[previousMatrix getHeight])
            filterSize=[previousMatrix getHeight];
        if(filterSize>[previousMatrix getWidth])
            filterSize=[previousMatrix getWidth];
        if(!(filterSize%2))
            filterSize++;
        
        output=[Convolution convWithGaussian:previousMatrix
                                       sigma:sigma[interval_num] filterSize:filterSize];
    }
    return output;
}

- (void)setSigma
{
    double k=pow(2.0,1.0/(double)(intervalNum));
    
    for(int i=1;i<intervalNum+3;i++){
        sigma[i]=sqrt(pow(sigma[0]*pow(k,i),2) - pow(sigma[0]*pow(k,i-1),2));
    }
}

- (void)setOctaveNum
{
    int size;
    
    if(originalHeight>=originalWidth)
        size=originalWidth;
    else
        size=originalHeight;
    
    octaveNum=0;
    while(size>=8){
        size=size/2;
        octaveNum++;
    }
}


- (int)getOctaveNum
{
    return octaveNum;
}

- (int)getIntervalNum
{
    return intervalNum;
}

@end
