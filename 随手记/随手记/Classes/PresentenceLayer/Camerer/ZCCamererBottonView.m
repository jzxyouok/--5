//
//  ZCCamererBottonView.m
//  随手记
//
//  Created by MrZhao on 16/7/6.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCCamererBottonView.h"
#import "ZCConst.h"
#import "Masonry.h"
@interface ZCCamererBottonView ()
/*
 *左边的图片控件
 */
@property(nonatomic, weak)UIButton *imageButton;

/*
 *相机
 */
@property(nonatomic, weak)UIButton *takePhotoButton;

/*
 *是否开启美颜
 */
@property(nonatomic, weak)UIButton *faceBeautifulButton;
/*
 *取消
 */
@property(nonatomic, weak)UIButton *cancelButton;
/*
 *保存
 */
@property(nonatomic, weak)UIButton *saveButton;

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
    UIButton *imageButton = [[UIButton alloc] init];
    [imageButton setImage:[UIImage imageNamed:@"meinv"] forState:UIControlStateNormal];
    [self addSubview:imageButton];
    self.imageButton = imageButton;
    
    //左边的取消按钮，开始时让其隐藏
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setImage:[UIImage imageNamed:@"btn_input_clear"] forState:UIControlStateNormal];
    cancelButton.hidden = YES;
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    //是否开启美颜的button,开始让其隐藏
    UIButton *faceBeautifulButton = [[UIButton alloc] init];
    [faceBeautifulButton setImage:[UIImage imageNamed:@"icon_editor"] forState:UIControlStateNormal];
    faceBeautifulButton.hidden = YES;
    [self addSubview:faceBeautifulButton];
     self.faceBeautifulButton = faceBeautifulButton;
    
    
    //为中间的takeView 添加一个按钮
    UIButton *takePhotoButton = [[UIButton alloc] init];
    [takePhotoButton setImage:[UIImage imageNamed:@"icon_camera"] forState:UIControlStateNormal];
    [self addSubview:takePhotoButton];
    self.takePhotoButton = takePhotoButton;
    
    //右边保存按钮,开始时让其隐藏
    UIButton *savePhotoButton = [[UIButton alloc] init];
    [savePhotoButton setImage:[UIImage imageNamed:@"btn_camera_done"] forState:UIControlStateNormal];
    savePhotoButton.hidden = YES;
    [self addSubview:savePhotoButton];
    self.saveButton = savePhotoButton;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    //左边图片
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo((self.frame.size.height - 50) / 2);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(50);

    }];
    
    //左边取消按钮,与图片通位置
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo((self.frame.size.height - 50) / 2);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    //相机
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo((ScreenW - 60) / 2);
        make.top.mas_equalTo((self.frame.size.height - 60) / 2);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);

    }];
    
    //开启美颜
    [self.faceBeautifulButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((ScreenW - 60) / 2);
        make.top.mas_equalTo((self.frame.size.height - 60) / 2);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    //右边的保存按钮
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.frame.size.width - 70);
        make.top.mas_equalTo((self.frame.size.height - 50) / 2);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
}

- (void)drawRect:(CGRect)rect {
    
    //为相册画一个矩形框
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(contextRef, color.CGColor);
    
    //中间的相机画个圆
    CGContextSetLineWidth(contextRef, 3.0);
    CGContextAddArc(contextRef, self.frame.size.width / 2, self.frame.size.height / 2, 25, 0, 2 * M_PI, 0);
    CGContextStrokePath(contextRef);
    
}

- (void)configBottonViewWith:(UIViewController *)target imageViewButtonAction:(SEL)imageViewAction takePhotoButtonAction:(SEL)takePhotoAction faceBeautifullAction:(SEL)faceBeautifullAction cancelAction:(SEL)cancelAction saveAction:(SEL)saveAction {
    
    [self.imageButton addTarget:target action:imageViewAction forControlEvents:UIControlEventTouchUpInside];
    [self.takePhotoButton addTarget:target action:takePhotoAction forControlEvents:UIControlEventTouchUpInside];
    [self.faceBeautifulButton addTarget:target action:faceBeautifullAction forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:target action:cancelAction forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:target action:saveAction forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)configBottonViewSubViewcancelHidden:(BOOL)cancelHidden imageViewButton:(BOOL)imageViewHidden takePhotoButtonHidden:(BOOL)takePhotoHidden faceBeautifulHidden:(BOOL)faceBeautifulHidden saveButtonHidden:(BOOL)saveButtonHiddem {
    
    self.cancelButton.hidden = cancelHidden;
    self.imageButton.hidden = imageViewHidden;
    self.takePhotoButton.hidden = takePhotoHidden;
    self.faceBeautifulButton.hidden = faceBeautifulHidden;
    self.saveButton.hidden = saveButtonHiddem;
    
}
- (void)configLeftImageViewWithImage:(UIImage *)image {
    
    [self.imageButton setImage:image forState:UIControlStateNormal];
    
}
@end
