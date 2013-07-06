//
//  ViewController.m
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//@synthesize imageView;

- (id)init
{
    self=[super init];
    //imageView=[[UIImageView alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openImage
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image=image;
    ImageMatrix *imageMatrix=[ImageConverter UIImage2ImageMatrixY:image];
    //[imageMatrix print];
    Pyramid *test=[[Pyramid alloc] initWithImageMatrix:imageMatrix];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Image size: %.0f x %.0f",image.size.width,image.size.height);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"No Image is picked up.");
}

@end
