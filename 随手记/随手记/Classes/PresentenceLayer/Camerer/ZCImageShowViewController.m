//
//  ZCImageShowViewController.m
//  随手记
//
//  Created by MrZhao on 16/7/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCImageShowViewController.h"
#import "ZCConst.h"
#import "ZCImageShowBottomView.h"
#import "UIBarButtonItem+Extention.h"
#import "ZCImageDataBL.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"
@interface ZCImageShowViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)ZCImageShowBottomView *bottomView;
@property(nonatomic,strong)UIImage *currentImage;
@end

@implementation ZCImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.bottomView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.imageView.frame  = CGRectMake(0, 64, ScreenW, ScreenH - 80 - 64);
    self.imageView.image = self.imageM.image;
    
    self.currentImage = [self.imageM.image copy];
    
    self.bottomView.frame = CGRectMake(0, ScreenH - 80, ScreenW, 80);

    
    [self.bottomView configBottonViewWith:self faceBeautifullAction:@selector(faceBuautifulButtonClik) cancelAction:@selector(cancelImageButtonClik) saveAction:@selector(saveButtonClik)];
    
    [self setUpNav];
}

- (void)setUpNav {
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem initWithAction:@selector(back) viewcontroller:self imageNamed:@"back_hight" hightedImageNamed:@"back_hight"];
    
    
    //设置导航栏为粉色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:231/255.0 green:143/255.0 blue:186/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"照片";
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = label;
    
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark底部相关按钮点击方法
- (void)cancelImageButtonClik {
    
    self.imageView.image = self.imageM.image;
    
}
- (void)faceBuautifulButtonClik {
    //创建滤镜
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    
    //设置滤镜区域
    
    [beautifyFilter forceProcessingAtSize:self.currentImage.size];
    [beautifyFilter useNextFrameForImageCapture];
    
    //获取数据源
    GPUImagePicture *imageSource = [[GPUImagePicture alloc] initWithImage:self.currentImage];
    
    //添加上滤镜
    [imageSource addTarget:beautifyFilter];
    
    //开始处理
    [imageSource processImage];
    
    //获取渲染后的图片,处理后的图片默认旋转了90度，因此我们要转回来
    UIImage *tempImage = [beautifyFilter imageFromCurrentFramebuffer];
    self.currentImage =[UIImage imageWithCGImage:tempImage.CGImage scale:1 orientation:UIImageOrientationRight];
    self.imageView.image = self.currentImage;
}
- (void)saveButtonClik {
    
    //更新数据库
    [ZCImageDataBL updataImageWithImage:self.currentImage imageName:self.imageM.imagName];
    self.imageM.image = [self.currentImage copy];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSArray *array = [[NSArray alloc] initWithObjects:self.imageM, nil];
    if (buttonIndex == 1) {//确定删除
        
        //删除数据库中数据
        [ZCImageDataBL deletImageDataWithArray:array];
        
        //弹出控制器
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
#pragma 懒加载
- (UIImageView *)imageView {
    if (_imageView == nil) {
        self.imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (ZCImageShowBottomView *)bottomView {
    if (_bottomView== nil) {
        
        self.bottomView = [[ZCImageShowBottomView alloc] init];
        self.bottomView.backgroundColor = [UIColor colorWithRed:231/255.0 green:143/255.0 blue:186/255.0 alpha:1.0];
    }
    return _bottomView;
}
@end
