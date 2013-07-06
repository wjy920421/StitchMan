//
//  Convolution.m
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "Convolution.h"

#define PI 3.1415926
#define EULER 2.718281828

@implementation Convolution

- (void)dealloc
{
	//NSLog(@"dealloc called");
}

+ (ImageMatrix *)convWithGaussian:(ImageMatrix *)target
sigma:(double)sigma filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
	return [Convolution conv:target filter:[Convolution getGaussianFilter:sigma
															   filterSize:filterSize]];
}

+ (ImageMatrix *)conv:(ImageMatrix *)target filter:(ImageMatrix *)filter
__attribute((ns_returns_retained))
{
	int targetHeight=[target getHeight];
	int targetWidth=[target getWidth];
	int filterHeight=[filter getHeight];
	int filterWidth=[filter getWidth];
	
    ImageMatrix *result=[[ImageMatrix alloc] initWithHeight:targetHeight Width:targetWidth];
	
    //if the target is too small, return the target without convolution.
    //if(targetHeight<filterHeight || targetWidth<filterWidth)
    //    return target;
    
    for(int i=0;i<targetHeight;i++){
        for(int j=0;j<targetWidth;j++){
            //opeation on each pixel
            int targetBaseWidth=j-filterWidth/2;
            int targetBaseHeight=i-filterHeight/2;
            double sum=0;
            
            for(int m=0;m<filterHeight;m++){
                for(int n=0;n<filterWidth;n++){
                    double targetValue;
                    double filterValue;
                    int targetIndexHeight=targetBaseHeight+m;
                    int targetIndexWidth=targetBaseWidth+n;
                    
                    if(targetIndexHeight<0)
                        targetIndexHeight=0;
                    else if(targetIndexHeight>=targetHeight)
                        targetIndexHeight=targetHeight-1;
                    if(targetIndexWidth<0)
                        targetIndexWidth=0;
                    else if(targetIndexWidth>=targetWidth)
                        targetIndexWidth=targetWidth-1;
                    
					filterValue
					=[filter getValueAtHeight:m Width:n];
                    targetValue
                    =[target getValueAtHeight:targetIndexHeight Width:targetIndexWidth];
                    
                    sum=sum+filterValue*targetValue;
                }
            }
            [result setValueAtHeight:i Width:j Value:sum];
        }
    }
    
    return result;
}

+ (ImageMatrix *)getGaussianFilter:(double) sigma
filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
    int x,y;
    int size = sizeof(double)* filterSize *filterSize;
    int halfSize=filterSize/2;
	double value;
	double sum=0;
    double *filter = malloc(size);
	
    for (x=0; x<filterSize; x++) {
        for (y=0; y<filterSize; y++) {
            double mid = (pow((x - halfSize),2) + pow((y - halfSize),2))/(2*sigma*sigma);
			value=(1.0 / (2 * PI * sigma * sigma))* pow(EULER,-mid);
            filter[x * filterSize + y] = value;
			sum=sum+value;
        }
    }
	
	for (x=0; x<filterSize; x++)
        for (y=0; y<filterSize; y++)
            filter[x * filterSize + y] = filter[x * filterSize + y]/sum;
	
	ImageMatrix *filterMatrix=[[ImageMatrix alloc] initWithArray:filter
                                                          Height:filterSize Width:filterSize];
	
	//tmp
	//[filterMatrix print];
	
    return filterMatrix;
}

@end
