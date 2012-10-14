//
//  UICliper.h
//  image
//
//  Created by 覃宏明 on 12-10-14.
//  Copyright (c) 2012年 广东省电信规划设计院有限公司-集客部 All rights reserved.
//
#define minWidth 60
#define minHeight 80
#import <UIKit/UIKit.h>
@interface UICliper : UIView
{
    UIImageView *imgView;
    CGRect cliprect;
    CGColorRef grayAlpha;
    CGPoint touchPoint;
    UIImageView *imageView_r;
    UIImageView *imageView_l;
    UIImageView *imageView_u;
    UIImageView *imageView_d;
}

- (id)initWithImageView:(UIImageView*)iv;
- (UIImage*)getClipImageRect:(CGRect)rect;
- (UIImage*)getSubImage;
- (void)setImage_narmal;
- (void)setImage_hover;
@end
