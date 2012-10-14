//
//  ViewController.m
//  ImageCroper
//
//  Created by hongming qin on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "UIImage-Extensions.h"
@implementation ViewController
@synthesize imageView=_imageView;
@synthesize cliper=_cliper;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:YES];    
    UINavigationItem *aNavigationItem = [[UINavigationItem alloc] initWithTitle:@"图片剪切"];
    [aNavigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(getImage:)] autorelease]];    
    UIBarButtonItem *croperBtnItem=[[UIBarButtonItem alloc]initWithTitle:@"剪切" style:UIBarButtonItemStylePlain target:self action:@selector(croperPicture:)];
    
    [aNavigationItem setLeftBarButtonItem:croperBtnItem];
    [navigationBar setItems:[NSArray arrayWithObject:aNavigationItem]];    
    [aNavigationItem release];   
    
    [[self view] addSubview:navigationBar];    
    [navigationBar release];
    
    [self displayOverView:[UIImage imageNamed:@"girl.jpeg"]];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];

}
- (void)displayOverView:(UIImage *)image{
    UIImage *originImage=[image fixOrientation]; 
    _imageView.image=originImage;
    float height=originImage.size.height;
    float width=originImage.size.width;    
    
    if (height>width) {
        _imageView.frame=CGRectMake(0, 0,width*(416/height), 416);
    }else{
        _imageView.frame=CGRectMake(0, 0,320, height*(320/width));
    }
    
    if (_cliper) {
        [_cliper removeFromSuperview];
    }
    UICliper *cliper=[[UICliper alloc]initWithImageView:_imageView];
    self.cliper=cliper;
    [cliper release];
   
    _imageView.center=CGPointMake(160, 460/2+22);

}
- (void)disMissShowView:(UITapGestureRecognizer *)sender{
    [[self.view viewWithTag:1122] removeFromSuperview];
}
- (void)croperPicture:(id)sender{
    
    //_imageView.image=[_cliper getSubImage];
    
    UIView *showView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    showView.backgroundColor=[UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.6];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissShowView:)];
    [showView addGestureRecognizer:tap];
    [tap release];
    showView.tag=1122;
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    imageView.image=[_cliper getSubImage];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [showView addSubview:imageView];
    [imageView release];
    
    [self.view addSubview:showView];
    [showView release];
}

//截取部分图像
- (UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(_imageView.image.CGImage, rect);
	CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));	
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];   
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();	
    NSLog(@"x:%f y:%f w:%f h:%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    NSLog(@"w:%f h:%f",smallImage.size.width,smallImage.size.height);
    return smallImage;
}
- (void)getImage:(id)sender{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"用户相册", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
   
	[picker dismissModalViewControllerAnimated:NO];
	UIImage* img=(UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
    
    [self displayOverView:img];

}
- (void)dealloc {
    [_imageView release];
    [_cliper release];
    [super dealloc];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    switch (buttonIndex) {
        case 0:{
            UIImagePickerController *picker=[[UIImagePickerController alloc]init];
            picker.delegate=self;
            picker.allowsEditing=NO;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
              picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            }else{
              picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            
            [self presentModalViewController:picker animated:YES];	
            break;
        }
        case 1:{
            UIImagePickerController *picker=[[UIImagePickerController alloc]init];
            picker.delegate=self;
            picker.allowsEditing=NO;
            picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentModalViewController:picker animated:YES];	
            break;
        }
        
        default:
            break;
    }
}
@end
