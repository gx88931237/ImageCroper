//
//  ViewController.h
//  ImageCroper
//
//  Created by hongming qin on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICliper.h"
@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>{}
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,retain) IBOutlet UICliper *cliper;
- (void)displayOverView:(UIImage *)image;
- (void)croperPicture:(id)sender;
- (UIImage*)getSubImage:(CGRect)rect;
- (void)getImage:(id)sender;
@end
