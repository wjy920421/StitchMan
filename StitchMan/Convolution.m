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

+ (ImageMatrix *)convWithGaussianFast:(ImageMatrix *)target
sigma:(double)sigma filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
    ImageMatrix *hg=[self getHorizontalGaussianFilter:sigma filterSize:filterSize];
    ImageMatrix *vg=[self getVerticalGaussianFilter:sigma filterSize:filterSize];
    
	return [Convolution conv:target horizontalFilter:hg verticalFilter:vg];
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

+ (ImageMatrix *)conv:(ImageMatrix *)target
     horizontalFilter:(ImageMatrix *)horizontalFilter verticalFilter:(ImageMatrix *)verticalFilter
__attribute((ns_returns_retained))
{
	int targetHeight=[target getHeight];
	int targetWidth=[target getWidth];
	int filterHeight=[verticalFilter getHeight];
	int filterWidth=[horizontalFilter getWidth];
	
    ImageMatrix *tmp=[[ImageMatrix alloc] initWithHeight:targetHeight Width:targetWidth];
    ImageMatrix *result=[[ImageMatrix alloc] initWithHeight:targetHeight Width:targetWidth];
    
    for(int i=0;i<targetHeight;i++){
        for(int j=0;j<targetWidth;j++){
            //opeation on each pixel
            int targetBaseWidth=j-filterWidth/2;
            double sum=0;
            for(int m=0;m<filterWidth;m++){
                    double targetValue;
                    double filterValue;
                    int targetIndexHeight=i;
                    int targetIndexWidth=targetBaseWidth+m;
                    
                    if(targetIndexWidth<0)
                        targetIndexWidth=0;
                    else if(targetIndexWidth>=targetWidth)
                        targetIndexWidth=targetWidth-1;
                    
					filterValue
					=[horizontalFilter getValueAtHeight:0 Width:m];
                    targetValue
                    =[target getValueAtHeight:targetIndexHeight Width:targetIndexWidth];
                    
                    sum=sum+filterValue*targetValue;
            }
            [tmp setValueAtHeight:i Width:j Value:sum];
        }
    }
    
    for(int i=0;i<targetHeight;i++){
        for(int j=0;j<targetWidth;j++){
            //opeation on each pixel
            int targetBaseHeight=i-filterHeight/2;
            double sum=0;
            for(int m=0;m<filterHeight;m++){
                double targetValue;
                double filterValue;
                int targetIndexHeight=targetBaseHeight+m;
                int targetIndexWidth=j;
                
                if(targetIndexHeight<0)
                    targetIndexHeight=0;
                else if(targetIndexHeight>=targetHeight)
                    targetIndexHeight=targetHeight-1;
                
                filterValue
                =[verticalFilter getValueAtHeight:m Width:0];
                targetValue
                =[tmp getValueAtHeight:targetIndexHeight Width:targetIndexWidth];
                
                sum=sum+filterValue*targetValue;
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
    free(filter);
	
    return filterMatrix;
}

+ (ImageMatrix *)getHorizontalGaussianFilter:(double) sigma
filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
    int x;
    int halfSize=filterSize/2;
	double value;
	double sum=0;
    double filter[30];
	
    for (x=0; x<filterSize; x++) {
            double mid = pow((x - halfSize),2)/(2*sigma*sigma);
			value=sqrt(1.0 / (2 * PI * sigma * sigma))* pow(EULER,-mid);
            filter[x] = value;
			sum=sum+value;
    }
	
	for (x=0; x<filterSize; x++)
            filter[x] = filter[x]/sum;
	
	ImageMatrix *filterMatrix=[[ImageMatrix alloc] initWithArray:filter
                                                          Height:1 Width:filterSize];
	
	//tmp
	//[filterMatrix print];
	
    return filterMatrix;
}

+ (ImageMatrix *)getVerticalGaussianFilter:(double) sigma
filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
    int x;
    int halfSize=filterSize/2;
	double value;
	double sum=0;
    double filter[30];
	
    for (x=0; x<filterSize; x++) {
        double mid = pow((x - halfSize),2)/(2*sigma*sigma);
        value=sqrt(1.0 / (2 * PI * sigma * sigma))* pow(EULER,-mid);
        filter[x] = value;
        sum=sum+value;
    }
	
	for (x=0; x<filterSize; x++)
        filter[x] = filter[x]/sum;
    
	ImageMatrix *filterMatrix=[[ImageMatrix alloc] initWithArray:filter
                                                          Height:filterSize Width:1];
	
	//tmp
	//[filterMatrix print];
	
    return filterMatrix;
}

@end
