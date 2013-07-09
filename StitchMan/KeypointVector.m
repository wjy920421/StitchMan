//
//  KeypointVector.m
//  StitchMan
//
//  Created by wjy on 13-7-6.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "KeypointVector.h"

@implementation KeypointVector

- (id)initWithPyramid:(Pyramid *)pyramid
{
    if(self=[super init]){
        keypoints=[[NSMutableArray alloc] init];
        
        [self locateKeypoints:pyramid];
    }
    return self;
}

- (void)locateKeypoints:(Pyramid *)pyramid
{
    int octaveNum=[pyramid getOctaveNum];
    int intervalNum=[pyramid getIntervalNum];
    
    for(int i=0;i<octaveNum;i++){
        for(int j=1;j<intervalNum+1;j++){
            [self locateKeypointsAtOctave:i Interval:j Pyramid:pyramid];
        }
    }
}

- (void)locateKeypointsAtOctave:(int)octave_num Interval:(int)interval_num
                        Pyramid:(Pyramid *)pyramid
{
    ImageMatrix *imtmp=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                             Interval:interval_num];
    int width=imtmp->imageWidth;
    int height=imtmp->imageHeight;
    
    for(int i=1;i<height-1;i++){
        for(int j=1;j<width-1;j++){
            if([self isExtremaAtX:j Y:i
                           Octave:octave_num Interval:interval_num Pyramid:pyramid]){
                
                float correction_x=0;
                float correction_y=0;
                float x=j;
                float y=i;
                [self adjustExtremaAtX:&x Y:&y
                                Octave:octave_num Interval:interval_num Pyramid:pyramid
                     returnCorrectionX:&correction_x CorrectionY:&correction_y];
                
                Keypoint *newKeypoint=[[Keypoint alloc]
                                        initWithX:(x+correction_x)*(1<<octave_num)
                                                Y:(y+correction_y)*(1<<octave_num)];
                [keypoints addObject:newKeypoint];
                
                //test
                [newKeypoint print];
            }
        }
    }
}

- (BOOL)isExtremaAtX:(int)x Y:(int)y
              Octave:(int)octave_num Interval:(int)interval_num Pyramid:(Pyramid *)pyramid
{
    ImageMatrix *im=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                          Interval:interval_num];
    float value=im->pImage[y*im->imageWidth+x];
    
    if(value>=0){
        for(int k=interval_num-1;k<=interval_num+1;k++){
            for(int i=y-1;i<=y+1;i++){
                for(int j=x-1;j<=x+1;j++){
                    if(i==y && j==x && k==interval_num)
                        continue;
                    
                    ImageMatrix *imtmp=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                                             Interval:k];
                    float valuetmp=imtmp->pImage[i*imtmp->imageWidth+j];
                    
                    if(value<valuetmp)
                        return FALSE;
                }
            }
        }
    }
    else{
        for(int k=interval_num-1;k<=interval_num+1;k++){
            for(int i=y-1;i<=y+1;i++){
                for(int j=x-1;j<=x+1;j++){
                    if(i==y && j==x && k==interval_num)
                        continue;
                    
                    ImageMatrix *imtmp=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                                             Interval:k];
                    float valuetmp=imtmp->pImage[i*imtmp->imageWidth+j];
                    
                    if(value>valuetmp)
                        return FALSE;
                }
            }
        }
    }
    return TRUE;
}

- (void)adjustExtremaAtX:(float *)px Y:(float *)py
                  Octave:(int)octave_num Interval:(int)interval_num Pyramid:(Pyramid *)pyramid
       returnCorrectionX:(float *)p_correction_x CorrectionY:(float *)p_correction_y
{
    
}


- (Keypoint *)getKeypointAtIndex:(int)index __attribute((ns_returns_retained))
{
    return [keypoints objectAtIndex:index];
}

- (int)getLength
{
    return [keypoints count];
}

@end
