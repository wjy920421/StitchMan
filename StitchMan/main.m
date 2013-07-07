//
//  main.m
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

//test
#import "Convolution.h"
#import "ImageMatrix.h"
#import "Pyramid.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
         /*
         double input[120]={  12,34,56,78,90,11,12,34,56,78,90,11,
             98,76,54,32,10,98,76,54,32,10,45,82,
             76,54,32,10,45,82,34,56,78,90,11,12,
             76,54,32,10,45,82,34,56,78,90,11,12,
             34,56,78,90,11,12,76,54,32,10,45,82,
             76,54,34,56,78,90,11,12,32,10,45,82,
             90,11,12,76,54,32,78,90,11,12,34,56,
             78,90,11,12,34,56,90,11,12,76,54,32,
             12,34,56,90,11,12,54,32,10,45,82,34,
             12,34,56,90,11,12,54,32,10,45,82,34,
         };
         
         double filter[9]={ -1.0/4,0,1.0/4,
         -2.0/4,0,2.0/4,
         -1.0/4,0,1.0/4};
         
         id inputMatrix=[[ImageMatrix alloc] initWithArray:input Height:10 Width:12];
         id filterMatrix=[[ImageMatrix alloc] initWithArray:filter Height:3 Width:3];
         
         //[inputMatrix print];
         //[filterMatrix print];
         
         ImageMatrix *output;
         
         //while(1)
         //output=[Convolution conv:inputMatrix filter:filterMatrix];
         output=[Convolution convWithGaussian:inputMatrix sigma:2 filterSize:13];
        [output print];
        
        output=[Convolution convWithGaussianFast:inputMatrix sigma:2 filterSize:13];
        [output print];
        
         output=nil;
         inputMatrix=nil;
         filterMatrix=nil;
         */
        
        /*
         double input[65536];
         for(int i=0;i<256;i++)
         for(int j=0;j<256;j++)
         input[i*256+j]=(i+j)%256;
         Pyramid *test=[[Pyramid alloc] initWithImageMatrix:[[ImageMatrix alloc]
         initWithArray:input
         Height:256
         Width:256]];
         */
        
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
