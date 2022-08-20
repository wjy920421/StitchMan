//
//  RANSAC.m
//  StitchMan
//
//  Created by wjy on 13-7-28.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "RANSAC.h"

#import "Homography.h"
#import "coordinate.h"

#define RANSAC_ITERATIONS 10000 //5000
#define RANSAC_INLIER_THRESHOLD 4 //4

@implementation RANSAC

- (id)initWithMatch:(Match *)match
{
    if(self=[super init]){
        imageMatrix1=match->imageMatrix1;
        imageMatrix2=match->imageMatrix2;
        
        size=match->size;
        keypoints1=match->matchVector1;
        keypoints2=match->matchVector2;
        width1=match->imageMatrix1->imageWidth;
        height1=match->imageMatrix1->imageHeight;
        width2=match->imageMatrix2->imageWidth;
        height2=match->imageMatrix2->imageHeight;
        
        //find best matches
        if(size>=10){
            [self findBestMatches];
        }
    }
    return self;
}

- (void)findBestMatches
{
    int i,j,k;
    int inliers;
    int selections[4];
    double *homography_tmp;
    Keypoint *tmpKeypoint1_1;
    Keypoint *tmpKeypoint1_2;
    Keypoint *tmpKeypoint1_3;
    Keypoint *tmpKeypoint1_4;
    Keypoint *tmpKeypoint2_1;
    Keypoint *tmpKeypoint2_2;
    Keypoint *tmpKeypoint2_3;
    Keypoint *tmpKeypoint2_4;
    
    coordinate *coord1_1;
    coordinate *coord1_2;
    coordinate *coord1_3;
    coordinate *coord1_4;
    coordinate *coord2_1;
    coordinate *coord2_2;
    coordinate *coord2_3;
    coordinate *coord2_4;
    //generate random seed
    srand((int)time(NULL));
    
    i=0;
    inliers=-1;
    while((i++)<RANSAC_ITERATIONS){
        
        //randomly choose four pairs
        k=0;
        while(k<4){
            selections[k]=rand()%size;
            //selections[k]=arc4random()%size;
            
            int repeat=0;
            for(j=0;j<k;j++){
                if(selections[k]==selections[j])
                    repeat=1;
                Keypoint *kp001=[keypoints1 objectAtIndex:selections[j]];
                Keypoint *kp002=[keypoints1 objectAtIndex:selections[k]];
                if(kp001->x==kp002->x && kp001->y==kp002->y)
                    repeat=1;
            }
            
            if(!repeat){
                k++;
            }
        }
        //printf("selections: %d %d %d %d\n",selections[0],selections[1],selections[2],selections[3]);
        
        tmpKeypoint1_1=[keypoints1 objectAtIndex:selections[0]];
        tmpKeypoint1_2=[keypoints1 objectAtIndex:selections[1]];
        tmpKeypoint1_3=[keypoints1 objectAtIndex:selections[2]];
        tmpKeypoint1_4=[keypoints1 objectAtIndex:selections[3]];
        tmpKeypoint2_1=[keypoints2 objectAtIndex:selections[0]];
        tmpKeypoint2_2=[keypoints2 objectAtIndex:selections[1]];
        tmpKeypoint2_3=[keypoints2 objectAtIndex:selections[2]];
        tmpKeypoint2_4=[keypoints2 objectAtIndex:selections[3]];
        
        coord1_1=[[coordinate alloc] initWIthKeypointAndChange:tmpKeypoint1_1
                                                        height:height1 width:width1];
        coord1_2=[[coordinate alloc] initWIthKeypointAndChange:tmpKeypoint1_2
                                                        height:height1 width:width1];
        coord1_3=[[coordinate alloc] initWIthKeypointAndChange:tmpKeypoint1_3
                                                        height:height1 width:width1];
        coord1_4=[[coordinate alloc] initWIthKeypointAndChange:tmpKeypoint1_4
                                                        height:height1 width:width1];
        coord2_1=[[coordinate alloc] initWIthKeypointAndChange:tmpKeypoint2_1
                                                        height:height2 width:width2];
        coord2_2=[[coordinate alloc] initWIthKeypointAndChange:tmpKeypoint2_2
                                                        height:height2 width:width2];
        coord2_3=[[coordinate alloc] initWIthKeypointAndChange:tmpKeypoint2_3
                                                        height:height2 width:width2];
        coord2_4=[[coordinate alloc] initWIthKeypointAndChange:tmpKeypoint2_4
                                                        height:height2 width:width2];
        
        //find homography from im1 to im2
        homography_tmp=[Homography findHomography2DWithX1:coord1_1->x Y1:coord1_1->y
                                                      X11:coord2_1->x Y11:coord2_1->y
                                                       X2:coord1_2->x Y2:coord1_2->y
                                                      X22:coord2_2->x Y22:coord2_2->y
                                                       X3:coord1_3->x Y3:coord1_3->y
                                                      X33:coord2_3->x Y33:coord2_3->y
                                                       X4:coord1_4->x Y4:coord1_4->y
                                                      X44:coord2_4->x Y44:coord2_4->y];
        
        j=[self inlierOfCurrentHomography:homography_tmp];
        if(j>inliers){
            inliers=j;
            [self copyHomographyFrom:homography_tmp];
        }
    }
    printf("RANSAC done!\ninliers=%d\n",inliers);
}

- (int)inlierOfCurrentHomography:(double *)h
{
    Keypoint *kp1,*kp2;
    coordinate *coord1,*coord2;
    double x1,y1,x2,y2,x3,y3,z,sqdist;
    int count=0;
    
    for(int i=0;i<size;i++){
            kp1=[keypoints1 objectAtIndex:i];
            kp2=[keypoints2 objectAtIndex:i];
            
            coord1=[[coordinate alloc] initWIthKeypointAndChange:kp1 height:height1 width:width1];
            coord2=[[coordinate alloc] initWIthKeypointAndChange:kp2 height:height2 width:width2];
            
            x1=coord1->x;y1=coord1->y;
            x2=coord2->x;y2=coord2->y;
            
            x3=h[0]*x1+h[1]*y1+h[2];
            y3=h[3]*x1+h[4]*y1+h[5];
            z=h[6]*x1+h[7]*y1+h[8];
            x3=x3/z;
            y3=y3/z;
            
            sqdist=(x3-x2)*(x3-x2) + (y3-y2)*(y3-y2);
            
            if(sqdist<RANSAC_INLIER_THRESHOLD)
                count++;
    }
    return count;
}

- (void)copyHomographyFrom:(double *)h
{
    for(int i=0;i<9;i++){
        self->homography[i]=h[i];
    }
}

@end
