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
#import "ComplexMatrix.h"
#import "Filter.h"
#import "ImageMatrix.h"
#import "Pyramid.h"
#import "Derivative.h"


int main(int argc, char *argv[])
{
    @autoreleasepool {
        
         /*
         float input[120]={  12,34,56,78,90,11,12,34,56,78,90,11,
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
         
         float filter[9]={ -1.0/4,0,1.0/4,
         -2.0/4,0,2.0/4,
         -1.0/4,0,1.0/4};
         
         id inputMatrix=[[ImageMatrix alloc] initWithArray:input Height:10 Width:12];
         id filterMatrix=[[ImageMatrix alloc] initWithArray:filter Height:3 Width:3];
         
         //[inputMatrix print];
         //[filterMatrix print];
         
         ImageMatrix *output;
         
         //while(1)
         //output=[Convolution conv:inputMatrix filter:filterMatrix];
         output=[Filter convWithGaussian:inputMatrix sigma:1 filterSize:7];
        [output print];
        
        output=[Filter convWithGaussianFast:inputMatrix sigma:1 filterSize:7];
        [output print];
        
         output=nil;
         inputMatrix=nil;
         filterMatrix=nil;
         */
        
        
        /*
        clock_t start,finish;
        start=clock();
        ImageMatrix *im=[[ImageMatrix alloc] initWithHeight:2000 Width:2000];
        ComplexMatrix *cm=[[ComplexMatrix alloc] initWithImageMatrix:im];
        finish=clock();
        printf("Total time: %f s",(float)(finish-start)/1000000);
        */
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
