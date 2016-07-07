//
//  ZCCamererBottonView.m
//  随手记
//
//  Created by MrZhao on 16/7/6.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCCamererBottonView.h"
#import "ZCConst.h"
@interface ZCCamererBottonView ()
/*
 *左边的图片控件
 */
@property(nonatomic,weak)UIButton *imageButton;

/*
 *相机
 */
@property(nonatomic,weak)UIButton *takePhotoButton;

/*
 *是否开启美颜
 */
@property(nonatomic,weak)UIButton *faceBeautifulButton;
/*
 *取消
 */
@property(nonatomic,weak)UIButton *cancelButton;
/*
 *保存
 */
@property(nonatomic,weak)UIButton *saveButton;

@end
@implementation ZCCamererBottonView
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //添加子控件
        [self setUpChild];
    }
    return self;
}

- (void)setUpChild {
    //左边的图片
    //是否开启美颜的button
    UIButton *imageButton = [[UIButton alloc] init];
    [imageButton setImage:[UIImage imageNamed:@"meinv"] forState:UIControlStateNormal];
    [self addSubview:imageButton];
    self.imageButton = imageButton;
    
    
    //是否开启美颜的button
    UIButton *faceBeautifulButton = [[UIButton alloc] init];
    
    [faceBeautifulButton setImage:[UIImage imageNamed:@"icon_editor"] forState:UIControlStateNormal];
    
    [self addSubview:faceBeautifulButton];
    self.faceBeautifulButton = faceBeautifulButton;
    
    
    
    //为中间的takeView 添加一个按钮
    UIButton *takePhotoButton = [[UIButton alloc] init];
    [takePhotoButton setImage:[UIImage imageNamed:@"icon_camera"] forState:UIControlStateNormal];
    [self addSubview:takePhotoButton];
    self.takePhotoButton = takePhotoButton;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat margin = 20;
    CGFloat imageButtonW = 40;
    CGFloat imageButtonH = 50;
    //左边图片
    self.imageButton.frame = CGRectMake(margin, (self.frame.size.height - imageButtonH) / 2, imageButtonW, imageButtonH);
    CGFloat  takePhotoWH = 30;
    CGFloat takePhotoX = (ScreenW - takePhotoWH) / 2;
    CGFloat takePhotoY =  (self.frame.size.height - takePhotoWH) / 2;
    
    //画个矩形
    
    //相机
    self.takePhotoButton.frame = CGRectMake(takePhotoX, takePhotoY, takePhotoWH, takePhotoWH);
    
    //开启美颜
    CGFloat faceBeautifulWH = 40;
    self.faceBeautifulButton.frame = CGRectMake(ScreenW -60, (self.frame.size.height - faceBeautifulWH) / 2, faceBeautifulWH, faceBeautifulWH);
    
}

- (void)drawRect:(CGRect)rect {
    
    //为相册画一个矩形框
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(contextRef, color.CGColor);
    CGContextSetLineWidth(contextRef, 0.5);
    CGContextStrokeRect(contextRef, CGRectMake(19, (self.frame.size.height - 50) / 2 -1, 41, 51));
    
    //中间的相机画个圆
    CGContextSetLineWidth(contextRef, 3.0);
    CGContextAddArc(contextRef, self.frame.size.width / 2, self.frame.size.height / 2, 25, 0, 2 * M_PI, 0);
    CGContextStrokePath(contextRef);
}
- (void)configBottonViewWith:(UIViewController *)target imageViewButtonAction:(SEL)imageViewAction takePhotoButtonAction:(SEL)takePhotoAction faceBeautifullAction:(SEL)faceBeautifullAction cancelAction:(SEL)cancelAction saveAction:(SEL)saveAction {
    
    [self.imageButton addTarget:target action:imageViewAction forControlEvents:UIControlEventTouchUpInside];
    [self.takePhotoButton addTarget:target action:takePhotoAction forControlEvents:UIControlEventTouchUpInside];
    [self.faceBeautifulButton addTarget:target action:faceBeautifullAction forControlEvents:UIControlEventTouchUpInside];
    
}
@end
