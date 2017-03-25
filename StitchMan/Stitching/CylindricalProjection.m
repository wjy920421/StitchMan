//
//  CylindricalProjection.m
//  StitchMan
//
//  Created by wjy on 13-7-28.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#ifndef PI
#define PI 3.1415926
#endif

#import "CylindricalProjection.h"

#import "UIImageConverter.h"

@implementation CylindricalProjection

+ (UIImage *)transform:(UIImage *)im Theta:(double)t
{
    UIImage *imout;
    int width=im.size.width;
    int height=im.size.height;
    unsigned char *imRaw=[UIImageConverter UIImage2Data:im];
    unsigned char *outRaw=malloc(sizeof(unsigned char)*4*height*width);
    double theta=t/2;
    bzero(outRaw,sizeof(unsigned char)*4*height*width);
    
    double f=width/2.0/tan(theta);
    for(int i=0;i<height;i++){
        for(int j=0;j<width;j++){
            
                int xx=f*atan((j-width/2)/f)+width/2;
                int yy=f*(i-height/2)/sqrt((j-width/2)*(j-width/2)+f*f)+height/2;
                
                outRaw[4*(yy*width+xx)] = imRaw[4*(i*width+j)];
                outRaw[4*(yy*width+xx)+1] = imRaw[4*(i*width+j)+1];
                outRaw[4*(yy*width+xx)+2] = imRaw[4*(i*width+j)+2];
                outRaw[4*(yy*width+xx)+3] = imRaw[4*(i*width+j)+3];
            
            /*
            int xx=tan((j-width/2)/f)*f+width/2;
            int yy=(i-height/2)*sqrt((xx-width/2)*(xx-width/2)+f*f)/f+height/2;
            
            if(xx>=0 && xx<width && yy>=0 &&yy<height){
                outRaw[4*(i*width+j)] = imRaw[4*(yy*width+xx)];
                outRaw[4*(i*width+j)+1] = imRaw[4*(yy*width+xx)+1];
                outRaw[4*(i*width+j)+2] = imRaw[4*(yy*width+xx)+2];
                outRaw[4*(i*width+j)+3] = imRaw[4*(yy*width+xx)+3];
            }
            else{
                outRaw[4*(i*width+j)] = 0;
                outRaw[4*(i*width+j)+1] = 0;
                outRaw[4*(i*width+j)+2] = 0;
                outRaw[4*(i*width+j)+3] = 0;
            }
            */
        }
    }
    
    imout=[UIImageConverter data2UIImage:outRaw height:height width:width];
    
    free(outRaw);
    free(imRaw);
    
    return imout;
}

@end
