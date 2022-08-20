//
//  StitcherUsingHomography.m
//  StitchMan
//
//  Created by he qiyun on 13-07-27.
//  Copyright (c) 2013 wjy. All rights reserved.
//

#import "Stitcher.h"
#import "SIFT.h"
#import "Match.h"
#import "RANSAC.h"
#import "UIImageConverter.h"
#import "UIImagePruner.h"
#import "Coordinate.h"

@implementation Stitcher

+ (UIImage *)stitch:(UIImage *)uiimage1 And:(UIImage *)uiimage2
{
    /*
    im1=[CylindricalProjection transform:uiimage1 Theta:PI/5];
    im2=[CylindricalProjection transform:uiimage2 Theta:PI/5];
    */
    
    ImageMatrix *im1=[ImageConverter UIImage2Luminance:uiimage1];
    ImageMatrix *im2=[ImageConverter UIImage2Luminance:uiimage2];
    
    SIFT *sift1=[[SIFT alloc] initWithImageMatrix:im1];
    SIFT *sift2=[[SIFT alloc] initWithImageMatrix:im2];
    
    Match *match=[[Match alloc] initWithSIFT1:sift1 SIFT2:sift2];
    
    RANSAC *ransac=[[RANSAC alloc] initWithMatch:match];
    
    return [Stitcher stitch:uiimage1 And:uiimage2 UsingHomography:ransac->homography];
}

+ (UIImage *)stitch:(UIImage *)firstImage And:(UIImage *)secondImage UsingHomography:(double *)homography
{
    int newWidth;
    int newHeight;
    int i,j;
    int componentR,componentG,componentB,componentAlpha;
    int Red,G,B,Alpha;
    int firstImageWidth=firstImage.size.width;
    int firstImageHeight=firstImage.size.height;
    int secondImageWidth=secondImage.size.width;
    int secondImageHeight=secondImage.size.height;
    int expandLength=(secondImageHeight>secondImageWidth)?secondImageHeight:secondImageWidth;
    newWidth = firstImageWidth + 2 * expandLength;
    newHeight = firstImageHeight + 2 * expandLength;
    
    UIImage * finalFirstImage = [UIImageConverter expandUIImage:firstImage withSize:expandLength];
    unsigned char* firstRawData = [UIImageConverter UIImage2Data:finalFirstImage];
    unsigned char* secondRawData = [UIImageConverter UIImage2Data:secondImage];
    coordinate *temp,*second;
    temp = [[coordinate alloc] init];
    second = [[coordinate alloc] init];
    
    //for weighting
    double sigma1_w=firstImageWidth/6.0;
    double sigma1_h=firstImageHeight/6.0;
    double sigma2_w=secondImageWidth/6.0;
    double sigma2_h=secondImageHeight/6.0;
    
     for (i=0;i<newHeight; i++) {
     for (j=0; j<newWidth; j++) {
     componentR = 4 * (i * newWidth + j);
     componentG = componentR + 1;
     componentB = componentG + 1;
     componentAlpha = componentB +1;
         
     temp->x = j;
     temp->y = i;
     temp = [coordinate changeToNormal:temp
                                height:newHeight
                                 width:newWidth];
     
     second->x = homography[0]*temp->x + homography[1]*temp->y + homography[2];
     second->y = homography[3]*temp->x + homography[4]*temp->y + homography[5];
     double z = homography[6]*temp->x + homography[7]*temp->y + homography[8];
     second->x=second->x/z;
     second->y=second->y/z;
     
     second = [coordinate changeToReverse:second
                                   height:secondImageHeight
                                    width:secondImageWidth];
         
         if(i==1010 && j==firstImageWidth+999){
             int g=0;
             g++;
         }
     
     if (round(second->x) >-1 && round(second->x) < secondImageWidth
         && round(second->y) > -1 && round(second->y) < secondImageHeight) {
         Red = 4 * (round(second->y) * secondImageWidth + round(second->x));
         G = Red+1;
         B = G+1;
         Alpha = B+1;
         if (i>=expandLength && i<(expandLength+firstImageHeight)
             && j>=expandLength && j<(expandLength + firstImageWidth)) {
             if(firstRawData[componentAlpha]!=0 && secondRawData[Alpha]!=0){
                 
                 second=[coordinate changeToNormal:second
                                            height:secondImageHeight width:secondImageWidth];
                 double firstWeight=exp(-(temp->x*temp->x/2.0/sigma1_w/sigma1_w
                                          +temp->y*temp->y/2.0/sigma1_h/sigma1_h));
                 double secondWeight=exp(-(second->x*second->x/2.0/sigma2_w/sigma2_w
                                           +second->y*second->y/2.0/sigma2_h/sigma2_h));
                 double totalWeight=firstWeight+secondWeight;
                 
                 firstRawData[componentR]
                 =(firstWeight*firstRawData[componentR] + secondWeight*secondRawData[Red])
                    /totalWeight;
                 firstRawData[componentG]
                 =(firstWeight*firstRawData[componentG] + secondWeight*secondRawData[G])
                    /totalWeight;
                 firstRawData[componentB]
                 =(firstWeight*firstRawData[componentB] + secondWeight*secondRawData[B])
                    /totalWeight;
                 
                 /*
                 firstRawData[componentR] = (firstRawData[componentR] + secondRawData[Red])/2;
                 firstRawData[componentG] = (firstRawData[componentG] + secondRawData[G])/2;
                 firstRawData[componentB] = (firstRawData[componentB] + secondRawData[B])/2;
                 */
             }
             else if (firstRawData[componentAlpha]==0 && secondRawData[Alpha]!=0){
                 firstRawData[componentR] = secondRawData[Red];
                 firstRawData[componentG] = secondRawData[G];
                 firstRawData[componentB] = secondRawData[B];
                 firstRawData[componentAlpha] = 255;
             }
         }
         else{
             if(secondRawData[Alpha]!=0){
             firstRawData[componentR] = secondRawData[Red];
             firstRawData[componentG] = secondRawData[G];
             firstRawData[componentB] = secondRawData[B];
             firstRawData[componentAlpha] = 255;
             }
         }
     }
     else continue;
     }
     }
    
    
    UIImage *resultImage = [UIImageConverter data2UIImage:firstRawData
                                                   height:newHeight
                                                    width:newWidth];
    free(firstRawData);
    free(secondRawData);
    
    resultImage = [UIImagePruner pruneImage:resultImage];
    
    return resultImage;
}

+ (UIImage *)stitch:(UIImage **)pImage UsingSIFT:(SIFT **)pSIFT Num:(int)num
{
    return nil;
}

@end
