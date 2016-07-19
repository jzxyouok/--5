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
#import <AVFoundation/AVFoundation.h>
@interface ZCCamererViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate>

@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) ZCCamererBottonView *bottonView;
@property (nonatomic, strong) GPUImageBeautifyFilter *beautifyFilter;

//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession  *session;

//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong) AVCaptureDeviceInput  *videoInput;

//照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了
@property (nonatomic, strong) AVCaptureStillImageOutput  *stillImageOutput;

//预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong) AVCaptureVideoPreviewLayer  *previewLayer;

//预览图层放在的View
@property (nonatomic, strong) UIView *cameraShowView;

//记录滤镜按钮是否开启
@property(nonatomic, assign)BOOL faceBeautifullSelected;
@end

@implementation ZCCamererViewController

//添加子视图工作
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //添加滤镜View;
    //[self.view addSubview:self.filterView];
    //添加底部View
    [self.view addSubview:self.bottonView];
    
    //添加预览的View
    [self.view addSubview:self.cameraShowView];
}

//配置工作
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //设置导航栏
    [self setUpNav];
    
    self.bottonView.frame = CGRectMake(0, ScreenH - 80, ScreenW, 80);
    
    [self.bottonView configBottonViewWith:self imageViewButtonAction:nil takePhotoButtonAction:@selector(takePhotoButtonClik) faceBeautifullAction:@selector(beautifyButtonClik) cancelAction:nil saveAction:nil];
    
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    self.cameraShowView.frame = CGRectMake(0, 30, ScreenW, ScreenH - 80);
    //设置预览的图层
    [self setUpCamererLayer];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //开启session
    if (self.session) {
        [self.session startRunning];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.session) {
        [self.session stopRunning];
    }
}
- (void)setUpCamererLayer {
    
    UIView * view = self.cameraShowView;
    CALayer * viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [self.previewLayer setFrame:bounds];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
   

   
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

//切换前后摄像头
- (void)reversCamerer {
    
        NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
        if (cameraCount > 1) {
            NSError *error;
            AVCaptureDeviceInput *newVideoInput;
            AVCaptureDevicePosition position = [[_videoInput device] position];
            
            if (position == AVCaptureDevicePositionBack)
                newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
            else if (position == AVCaptureDevicePositionFront)
                newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
            else
                return;
            
            if (newVideoInput != nil) {
                [self.session beginConfiguration];
                [self.session removeInput:self.videoInput];
                if ([self.session canAddInput:newVideoInput]) {
                    [self.session addInput:newVideoInput];
                    [self setVideoInput:newVideoInput];
                } else {
                    [self.session addInput:self.videoInput];
                }
                [self.session commitConfiguration];
            } else if (error) {
                NSLog(@"toggle carema failed, error = %@", error);
            }
        }
    
}
#pragma mark 底部View相关点击事件方法
//美颜开启
- (void)beautifyButtonClik {
    
//    self.faceBeautifullSelected = ! self.faceBeautifullSelected;
//    if (!self.faceBeautifullSelected) {
//        [self.videoCamera removeAllTargets];
//        [self.videoCamera addTarget:self.filterView];
//    }
//    else {
//        
//        [self.videoCamera removeAllTargets];
//        
//        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
//        self.beautifyFilter = beautifyFilter;
//        [self.videoCamera addTarget:beautifyFilter];
//        [beautifyFilter addTarget:self.filterView];
//    }
}
//拍照
- (void)takePhotoButtonClik {
    
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        
        UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:), @"传什么下面就调用什么什么");
        NSLog(@"image size = %@",NSStringFromCGSize(image.size));
    }];
    
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
#pragma 获取前后摄像头的方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
   for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}


#pragma mark 懒加载相关
- (GPUImageView *)filterView {
    
    if (_filterView == nil) {
        
//        self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetiFrame960x540 cameraPosition:AVCaptureDevicePositionFront];
//        self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//        self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
//        self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
//        self.filterView.center = self.view.center;
//        [self.videoCamera addTarget:self.filterView];
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

#pragma mark获取系统相机拍照需要的对象懒加载
- (AVCaptureSession *)session {
    if (_session == nil) {
        self.session = [[AVCaptureSession alloc] init];
         [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    return _session;
}
- (AVCaptureDeviceInput *)videoInput {
    if (_videoInput == nil) {
        self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:nil];
    }
    return _videoInput;
}
- (AVCaptureStillImageOutput *)stillImageOutput {
    if (_stillImageOutput == nil) {
        
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    }
    
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    
//    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
//    [self.stillImageOutput setOutputSettings:outputSettings];
    return _stillImageOutput;
}
- (AVCaptureVideoPreviewLayer *)previewLayer {
    
    if (_previewLayer == nil) {
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    }
    return _previewLayer;
}

- (UIView  *)cameraShowView {
    if (_cameraShowView == nil) {
        self.cameraShowView = [[UIView alloc] init];
    }
    return _cameraShowView;
}
@end


