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
        duplicateKeypoints=[[NSMutableArray alloc] init];
        
        count0=0;
        count1=0;
        pyr=pyramid;
        [self locateKeypoints:pyr];
        [self calculateOrientations];
        
        printf("%d local maximum.\n",count1);
        printf("%d keypoints are detected.\n",count0);
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
            //printf("finish\n");
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
                
                //
                count1++;
                
                Keypoint *kp=[self adjustExtremaAtX:j Y:i
                                             Octave:octave_num Interval:interval_num
                                            Pyramid:pyramid];
                if(kp!=nil){
                    [keypoints addObject:kp];
                    //
                    count0++;
                }
                
            }
        }
    }
}

- (BOOL)isExtremaAtX:(int)x Y:(int)y
              Octave:(int)octave_num Interval:(int)interval_num Pyramid:(Pyramid *)pyramid
{
    ImageMatrix *prev=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                            Interval:interval_num-1];
    ImageMatrix *im=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                          Interval:interval_num];
    ImageMatrix *next=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                            Interval:interval_num+1];
    
    int width=im->imageWidth;
    float value=im->pImage[y*width+x];
    float value1,value2,value3;
    
    if(value>=0){
        for(int i=y-1;i<=y+1;i++){
            for(int j=x-1;j<=x+1;j++){
                
                value1=prev->pImage[i*width+j];
                value2=im->pImage[i*width+j];
                value3=next->pImage[i*width+j];
                
                if(value<value1 || value<value2 || value<value3)
                    return FALSE;
            }
        }
    }
    else{
        for(int i=y-1;i<=y+1;i++){
            for(int j=x-1;j<=x+1;j++){
                
                value1=prev->pImage[i*width+j];
                value2=im->pImage[i*width+j];
                value3=next->pImage[i*width+j];
                
                if(value>value1 || value>value2 || value>value3)
                    return FALSE;
            }
        }
    }
    return TRUE;
}

- (Keypoint *)adjustExtremaAtX:(int)x Y:(int)y
                  Octave:(int)octave_num Interval:(int)interval_num Pyramid:(Pyramid *)pyramid
__attribute((ns_returns_retained))
{
    int i=0;
    double xc,yc,ic;
    double *dD;
    double *dD2;
    double det_D2;
    double inv_dD2[3][3];
    int intervalNum=[pyramid getIntervalNum];
    ImageMatrix *im=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                          Interval:interval_num];
    
    //interpolation
    while(i<INTERPOLATION_ITERATION)
    {
        //derivatives
        dD=[Derivative deriv3D:pyramid Octave:octave_num Interval:interval_num X:x Y:y];
        dD2=[Derivative hessian3D:pyramid Octave:octave_num Interval:interval_num X:x Y:y];
        
        //inverse of D2
        det_D2=dD2[0]*dD2[4]*dD2[8] + dD2[1]*dD2[5]*dD2[6] + dD2[3]*dD2[7]*dD2[2]
             - dD2[0]*dD2[5]*dD2[7] - dD2[1]*dD2[3]*dD2[8] - dD2[2]*dD2[4]*dD2[6];
        if(det_D2==0.0)
            return nil;
        
        inv_dD2[0][0]= (dD2[4]*dD2[8] - dD2[5]*dD2[7])/det_D2;
        inv_dD2[0][1]=-(dD2[1]*dD2[8] - dD2[2]*dD2[7])/det_D2;
        inv_dD2[0][2]= (dD2[1]*dD2[5] - dD2[2]*dD2[4])/det_D2;
        inv_dD2[1][0]= (dD2[5]*dD2[6] - dD2[3]*dD2[8])/det_D2;
        inv_dD2[1][1]=-(dD2[2]*dD2[6] - dD2[0]*dD2[8])/det_D2;
        inv_dD2[1][2]= (dD2[2]*dD2[3] - dD2[0]*dD2[5])/det_D2;
        inv_dD2[2][0]= (dD2[3]*dD2[7] - dD2[4]*dD2[6])/det_D2;
        inv_dD2[2][1]=-(dD2[0]*dD2[7] - dD2[1]*dD2[6])/det_D2;
        inv_dD2[2][2]= (dD2[0]*dD2[4] - dD2[1]*dD2[3])/det_D2;
        
        //multiply invD2 and D
        xc=-(inv_dD2[0][0]*dD[0] + inv_dD2[0][1]*dD[1] + inv_dD2[0][2]*dD[2]);
        yc=-(inv_dD2[1][0]*dD[0] + inv_dD2[1][1]*dD[1] + inv_dD2[1][2]*dD[2]);
        ic=-(inv_dD2[2][0]*dD[0] + inv_dD2[2][1]*dD[1] + inv_dD2[2][2]*dD[2]);
        
        if(fabs(xc)<0.5 && fabs(yc)<0.5 && fabs(ic)<0.5) break;
        
        x+=round(xc);
        y+=round(yc);
        interval_num+=round(ic);
        
        if(interval_num<1 || interval_num>intervalNum
            || x<1 || x>=im->imageWidth-1
            || y<1 || y>=im->imageHeight-1)
            return nil;
        
        i++;
    }
    
    if(i>=INTERPOLATION_ITERATION)
        return nil;
    
    //remove keypoints with low contrast
    im=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num Interval:interval_num];
    double D=im->pImage[y*im->imageWidth+x] + 0.5*(dD[0]*xc+dD[1]*yc+dD[2]*ic);
    if(fabs(D)<CONTRAST_THRESHOLD/(double)intervalNum)
        return nil;
    
    //remove edge responses
    double tr=dD2[0]+dD2[4];
    double det=dD2[0]*dD2[4]-dD2[1]*dD2[3];
    if(det<=0)
        return nil;
    if(tr*tr/det >= (R+1.0)*(R+1.0)/R)
        return nil;
    
    //return keypoint
    Keypoint *newKeypoint=[[Keypoint alloc]
                           initWithX:(int)(((double)x+xc)*(double)(1<<octave_num))
                                   Y:(int)(((double)y+yc)*(double)(1<<octave_num))
                              Octave:octave_num
                            Interval:interval_num];
    
    return newKeypoint;
}


- (void)calculateOrientations
{
    int length=[keypoints count];
    Keypoint *kp;
    for(int i=0;i<length;i++){
        kp=[keypoints objectAtIndex:i];
        [self calculateOrientationAtKeypoint:kp Pyramid:pyr];
    }
    
    int length2=[duplicateKeypoints count];
    for(int i=0;i<length2;i++){
        kp=[duplicateKeypoints objectAtIndex:i];
        [keypoints addObject:kp];
    }
    duplicateKeypoints=nil;
}



- (void)calculateOrientationAtKeypoint:(Keypoint *)kp
                        Pyramid:(Pyramid *)pyramid
{
    ImageMatrix *im=[pyramid getGaussianMatrixAtOctave:kp->octave_num Interval:kp->interval_num];
    int width=im->imageWidth;
    int height=im->imageHeight;
    int x=kp->x;
    int y=kp->y;
    int x1,y1;
    double scale=[self getScaleAtOctave:kp->octave_num Interval:kp->interval_num];
    double sigma=1.5*scale;
    int radius=(int)(3.0*1.5*scale);
    double magnitude,theta;
    double histogram[36];
    
    for(int i=0;i<36;i++)
        histogram[i]=0.0;
    
    for(int i=-radius;i<radius;i++){
        for(int j=-radius;j<radius;j++){
            x1=x+j;
            y1=y+i;
            if(x1>0 && x1<width-1 && y1>0 && y1<height-1){
                double dx=im->pImage[y1*width+x1+1]-im->pImage[y1*width+x1-1];
                double dy=im->pImage[(y1+1)*width+x1]-im->pImage[(y1-1)*width+x1];
                magnitude=sqrt(dx*dx+dy*dy);
                theta=atan2(-dy,dx);
                
                int index=(int)(36*(theta+PI)/PI/2.0);
                if(index<0) index=0;
                else if(index>35) index=35;
                
                double mid=(i*i+j*j)/(2*sigma*sigma);
                double gaussian=(1.0/(2*PI*sigma*sigma))* pow(EULER,-mid);
                
                histogram[index]=histogram[index]+gaussian*magnitude;
            }
        }
    }
    
    double max=0.0;
    int max_index=0;
    for(int i=0;i<36;i++)
        if(histogram[i]>max){
            max=histogram[i];
            max_index=i;
        }
    kp->theta=2.0*PI*max_index/36.0-PI;
    
    for(int i=0;i<36;i++)
        if(i!=max_index && histogram[i]>0.8*max){
            Keypoint *newkp=[[Keypoint alloc] initWithKeypoint:kp];
            newkp->theta=2.0*PI*i/36.0-PI;
            [duplicateKeypoints addObject:newkp];
        }
}




- (Keypoint *)getKeypointAtIndex:(int)index __attribute((ns_returns_retained))
{
    return [keypoints objectAtIndex:index];
}

- (int)getLength
{
    return [keypoints count];
}

- (double)getScaleAtOctave:(int)octave_num Interval:(int)interval_num;
{
    return pyr->sigma[0]*pow(2.0,octave_num+(double)interval_num/pyr->intervalNum);
}

@end
