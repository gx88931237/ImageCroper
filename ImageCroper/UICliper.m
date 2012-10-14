//
//  UICliper.h
//  image
//
//  Created by 覃宏明 on 12-10-14.
//  Copyright (c) 2012年 广东省电信规划设计院有限公司-集客部 All rights reserved.
//


#import "UICliper.h"

@implementation UICliper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}
- (id)initWithImageView:(UIImageView*)iv
{
    CGRect r = [iv bounds];
    self = [super initWithFrame:r];
    if (self) {
        [iv addSubview:self];
        [iv setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        float size = r.size.height>r.size.width? r.size.width :r.size.height;
        cliprect = CGRectMake((r.size.width-size*0.75)/2, (r.size.height-size)/2, size*0.75, size);
        grayAlpha = [[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.6] CGColor];
        [self setMultipleTouchEnabled:NO];
        touchPoint = CGPointZero;
        imgView = iv;
        
        
        imageView_r=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rl_narmal"]];
        imageView_l=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rl_narmal"]];
        imageView_u=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ud_narmal"]];     
        imageView_d=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ud_narmal"]];
        
        imageView_r.frame=CGRectMake(cliprect.origin.x+cliprect.size.width-13.5, cliprect.origin.y+(cliprect.size.height-27)/2, 27, 27);
        imageView_l.frame=CGRectMake(cliprect.origin.x-13.5, cliprect.origin.y+(cliprect.size.height-27)/2, 27, 27);
        imageView_u.frame=CGRectMake(cliprect.origin.x+(cliprect.size.width-27)/2, cliprect.origin.y-13.5, 27, 27);
        imageView_d.frame=CGRectMake(cliprect.origin.x+(cliprect.size.width-27)/2, cliprect.origin.y+cliprect.size.height-13.5, 27, 27);
        
        
        [self addSubview:imageView_r];
        [self addSubview:imageView_l];
        [self addSubview:imageView_u];
        [self addSubview:imageView_d];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    //绘制剪裁区域外半透明效果
    CGContextSetFillColorWithColor(context, grayAlpha);
    CGRect r = CGRectMake(0, 0, rect.size.width, cliprect.origin.y);
    CGContextFillRect(context, r);
    
    r = CGRectMake(0, cliprect.origin.y, cliprect.origin.x, cliprect.size.height);
    CGContextFillRect(context, r);
    
    r = CGRectMake(cliprect.origin.x + cliprect.size.width, cliprect.origin.y, rect.size.width - cliprect.origin.x - cliprect.size.width, cliprect.size.height);
    CGContextFillRect(context, r);
    
    r = CGRectMake(0, cliprect.origin.y + cliprect.size.height, rect.size.width, rect.size.height - cliprect.origin.y - cliprect.size.height);
    CGContextFillRect(context, r);
    
    
    //绘制剪裁区域的格子
    CGContextSetRGBStrokeColor(context, 0.0f, 1.0f, 0.0f, 0.8f);
    CGContextSetLineWidth(context, 2.0);   
    CGContextAddRect(context, cliprect);
    
    
    
    CGContextStrokePath(context); 
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    touchPoint = [touch locationInView:self];
    float x=touchPoint.x;
    float y=touchPoint.y;
    if (fabsf(x-cliprect.origin.x)<20) //左
    {
        [self setImage_hover];    
        
    }else if(fabsf(x-cliprect.origin.x-cliprect.size.width)<20) //右
    {
        [self setImage_hover];    
        
    }else if(fabsf(y-cliprect.origin.y)<20) //上
    {   
        [self setImage_hover];     
        
    }else if(fabsf(y-cliprect.origin.y-cliprect.size.height)<20) //下
    {   
        [self setImage_hover];     
        
    }else {
        return;
    }
    
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    float x = touchPoint.x;
    float y = touchPoint.y;
    if (fabsf(x-cliprect.origin.x)<20) //左
    {
        //判断放大还是缩小
        if (p.x>x) {//缩小
            cliprect.origin.x+=p.x-x;
            cliprect.size.width-=(p.x-x)*2;
            cliprect.size.width=cliprect.size.width<minWidth?minWidth:cliprect.size.width;
            
            cliprect.origin.y-=(cliprect.size.width/0.75-cliprect.size.height)/2;
            cliprect.size.height=cliprect.size.width/0.75;           
            
        }else{
            cliprect.origin.x-=x-p.x;
            cliprect.size.width+=(x-p.x)*2;
            
            cliprect.origin.y-=(cliprect.size.width/0.75-cliprect.size.height)/2;
            cliprect.size.height=cliprect.size.width/0.75;
        }
        
        
        
    }else if(fabsf(x-cliprect.origin.x-cliprect.size.width)<20) //右
    {
        //判断放大还是缩小
        if (p.x>x) {//放大
            cliprect.origin.x-=p.x-x;
            cliprect.size.width+=(p.x-x)*2;
            cliprect.origin.y-=(cliprect.size.width/0.75-cliprect.size.height)/2;
            cliprect.size.height=cliprect.size.width/0.75;   
            
            
            
        }else{//缩小
            cliprect.origin.x+=x-p.x;
            cliprect.size.width-=(x-p.x)*2;
            cliprect.size.width=cliprect.size.width<minWidth?minWidth:cliprect.size.width;
            cliprect.origin.y-=(cliprect.size.width/0.75-cliprect.size.height)/2;
            cliprect.size.height=cliprect.size.width/0.75;  
        }
        
        
        
    }else if(fabsf(y-cliprect.origin.y)<20){ //上
        //判断放大还是缩小
        if (p.y>y) {//缩小
            cliprect.origin.y+=p.y-y;
            cliprect.size.height-=(p.y-y)*2;
            cliprect.size.height=cliprect.size.height<minHeight?minHeight:cliprect.size.height;
            cliprect.origin.x-=(cliprect.size.height*0.75-cliprect.size.width)/2;
            cliprect.size.width=cliprect.size.height*0.75;           
            
        }else{ //放大
            cliprect.origin.y-=y-p.y;
            cliprect.size.height+=(y-p.y)*2;
            
            cliprect.origin.x-=(cliprect.size.height*0.75-cliprect.size.width)/2;
            cliprect.size.width=cliprect.size.height*0.75;         
        }
        
        
    }else if(fabsf(y-cliprect.origin.y-cliprect.size.height)<20){ //下
        //判断放大还是缩小
        if (p.y>y) {//放大
            cliprect.origin.y-=p.y-y;
            cliprect.size.height+=(p.y-y)*2;
            cliprect.origin.x-=(cliprect.size.height*0.75-cliprect.size.width)/2;
            cliprect.size.width=cliprect.size.height*0.75;           
            
        }else{ //缩小
            cliprect.origin.y+=y-p.y;
            cliprect.size.height-=(y-p.y)*2;
            cliprect.size.height=cliprect.size.height<minHeight?minHeight:cliprect.size.height;
            
            cliprect.origin.x-=(cliprect.size.height*0.75-cliprect.size.width)/2;
            cliprect.size.width=cliprect.size.height*0.75;         
        }
        
    }else if((x>cliprect.origin.x && x< cliprect.origin.x+cliprect.size.width)&&(y>cliprect.origin.y && y<cliprect.origin.y+cliprect.size.height)){ //正中
        cliprect.origin.x += (p.x -touchPoint.x);
        cliprect.origin.y += (p.y -touchPoint.y);
       
    }else {
        return;
    }
    
    if (cliprect.origin.x<0) {
        cliprect.origin.x=0;
    }else if(cliprect.origin.x>self.bounds.size.width-cliprect.size.width)
    {
        cliprect.origin.x=self.bounds.size.width-cliprect.size.width;
    }
    if (cliprect.origin.y<0) {
        cliprect.origin.y=0;
    }else if(cliprect.origin.y>self.bounds.size.height-cliprect.size.height)
    {
        cliprect.origin.y=self.bounds.size.height-cliprect.size.height;
    }
    if (cliprect.size.height>imgView.frame.size.height) {
        cliprect.size.height=imgView.frame.size.height;
        cliprect.size.width= cliprect.size.height*0.75;
        cliprect.origin.y=0;
    } 
    if (cliprect.size.width>imgView.frame.size.width) {
        cliprect.size.width=imgView.frame.size.width;
        cliprect.size.height= cliprect.size.width/0.75;
        cliprect.origin.x=0;
        
    } 
    
    
    imageView_r.frame=CGRectMake(cliprect.origin.x+cliprect.size.width-13.5, cliprect.origin.y+(cliprect.size.height-27)/2, 27, 27);
    imageView_l.frame=CGRectMake(cliprect.origin.x-13.5, cliprect.origin.y+(cliprect.size.height-27)/2, 27, 27);
    imageView_u.frame=CGRectMake(cliprect.origin.x+(cliprect.size.width-27)/2, cliprect.origin.y-13.5, 27, 27);
    imageView_d.frame=CGRectMake(cliprect.origin.x+(cliprect.size.width-27)/2, cliprect.origin.y+cliprect.size.height-13.5, 27, 27);
    
    [self setNeedsDisplay];
    touchPoint = p;
}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setImage_narmal];
    
    touchPoint = CGPointZero;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

-(UIImage*)getClipImageRect:(CGRect)rect
{
    CGImageRef imgrefout = CGImageCreateWithImageInRect([imgView.image CGImage], rect);
    UIImage *img_ret = [[UIImage alloc]initWithCGImage:imgrefout];
    return img_ret;
}
//截取部分图像
- (UIImage*)getSubImage
{
    CGRect rect=cliprect;
    float scale=imgView.image.size.height/imgView.frame.size.height;//计算原图与imageView缩放比例
    rect.origin.x*=scale;
    rect.origin.y*=scale;
    rect.size.height*=scale;
    rect.size.width*=scale;
    return [self getClipImageRect:rect];
}
- (void)setImage_narmal{
    imageView_l.image=[UIImage imageNamed:@"rl_narmal"];
    imageView_r.image=[UIImage imageNamed:@"rl_narmal"];
    imageView_u.image=[UIImage imageNamed:@"ud_narmal"];
    imageView_d.image=[UIImage imageNamed:@"ud_narmal"];
}
- (void)setImage_hover{
    imageView_l.image=[UIImage imageNamed:@"rl_hover"];
    imageView_r.image=[UIImage imageNamed:@"rl_hover"];
    imageView_u.image=[UIImage imageNamed:@"ud_hover"];
    imageView_d.image=[UIImage imageNamed:@"ud_hover"];
    
}
-(void)dealloc{
    [imageView_l release];
    [imageView_r release];
    [imageView_u release];
    [imageView_d release];
    [super dealloc];
}
@end
