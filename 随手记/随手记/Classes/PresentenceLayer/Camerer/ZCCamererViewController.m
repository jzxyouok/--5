//
//  ZCCamererViewController.m
//  随手记
//
//  Created by MrZhao on 16/7/5.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCCamererViewController.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"
#import "Masonry.h"
#import "UIBarButtonItem+Extention.h"
#import "ZCCamererBottonView.h"
#import "ZCConst.h"
#import "GPUImageOutput.h"
@interface ZCCamererViewController ()
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) ZCCamererBottonView *bottonView;
@property (nonatomic, strong)GPUImageBeautifyFilter *beautifyFilter;

//记录滤镜按钮是否开启
@property(nonatomic, assign)BOOL faceBeautifullSelected;
@end

@implementation ZCCamererViewController

//添加子视图工作
- (void)viewDidLoad{
    
    [super viewDidLoad];
    //添加滤镜View;
    [self.view addSubview:self.filterView];
    //添加底部View
    [self.view addSubview:self.bottonView];
}

//配置工作
- (void)viewWillAppear:(BOOL)animated {
    
    //设置导航栏
    [self setUpNav];
    
    self.bottonView.frame = CGRectMake(0, ScreenH - 70, ScreenW, 70);
    
    [self.bottonView configBottonViewWith:self imageViewButtonAction:nil takePhotoButtonAction:@selector(takePhotoButtonClik) faceBeautifullAction:@selector(beautifyButtonClik) cancelAction:nil saveAction:nil];
    
    [self.videoCamera startCameraCapture];
    
}
#pragma mark 导航栏相关设置
- (void)setUpNav {
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem initWithAction:@selector(back) viewcontroller:self imageNamed:@"back_hight" hightedImageNamed:@"back_hight"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithAction:@selector(reversCamerer) viewcontroller:self imageNamed:@"icon_component_list" hightedImageNamed:@"icon_component_list"];
    
    //设置导航栏为粉色
   self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:231/255.0 green:143/255.0 blue:186/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"拍照";
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = label;
    
}
- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)reversCamerer {
    
}
#pragma mark 底部View相关点击事件方法
//美颜开启
- (void)beautifyButtonClik {
    
    self.faceBeautifullSelected = ! self.faceBeautifullSelected;
    if (!self.faceBeautifullSelected) {
        [self.videoCamera removeAllTargets];
        [self.videoCamera addTarget:self.filterView];
    }
    else {
        
        [self.videoCamera removeAllTargets];
        
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        self.beautifyFilter = beautifyFilter;
        [self.videoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:self.filterView];
        
        
    }
}
//拍照
- (void)takePhotoButtonClik {
    
    //利用Cocos 2D截取屏幕图片并显示
    //获得某个范围内的屏幕图像
    
        UIGraphicsBeginImageContext(self.filterView.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
       // UIRectClip(CGRectMake(0, 64, ScreenW, ScreenH - 64 - 60));
        [self.filterView.layer renderInContext:context];
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
       //UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);
     //GPUImageOutput *output = [self.beautifyFilter filterAtIndex:0];
     //UIImage *image = [output imageFromCurrentFramebuffer];

      UIImageWriteToSavedPhotosAlbum(theImage, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), @"传什么下面就调用什么什么");
}

// 需要实现下面的方法,或者传入三个参数即可
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"保存失败");
    }else
    {
        NSLog(@"保存成功");
    }
}
#pragma mark 懒加载相关
- (GPUImageView *)filterView {
    
    if (_filterView == nil) {
        
        self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetiFrame960x540 cameraPosition:AVCaptureDevicePositionFront];
        self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
        self.filterView.center = self.view.center;
        [self.videoCamera addTarget:self.filterView];
    }
    return _filterView;
}
- (ZCCamererBottonView *)bottonView {
    if (_bottonView == nil) {
        
        self.bottonView = [[ZCCamererBottonView alloc] init];
        self.bottonView.backgroundColor = [UIColor colorWithRed:231/255.0 green:143/255.0 blue:186/255.0 alpha:1.0];
    }
    return _bottonView;
}
@end


