//
//  ZCVideoViewController.m
//  随手记
//
//  Created by MrZhao on 16/7/29.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCVideoViewController.h"
#import "GPUImageBeautifyFilter.h"
#import "ZCConst.h"
#import "GPUImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface ZCVideoViewController ()<UIAlertViewDelegate>
/*
 *写入视频文件类
 */
@property(nonatomic, strong)GPUImageMovieWriter *movieWriter;
/*
 *展示滤镜后的视频图像
 */
@property(nonatomic, strong)GPUImageView *filterView;
/*
 *滤镜类
 */
@property(nonatomic, strong)GPUImageBeautifyFilter *beautifyFilter;
/*
 *开启摄像机录制视频
 */
@property(nonatomic, strong)GPUImageVideoCamera *videoCamera;
/*
 *video相关设置
 */
@property(nonatomic, strong)NSMutableDictionary *videoSettings;
/*
 *音频相关设置
 */
@property(nonatomic, strong)NSDictionary *audioSettings;
/*
 *文件写入路径
 */
@property(nonatomic, copy)  NSString *pathToMovie;
/*
 *文件URL,供写入系统相册使用
 */
@property(nonatomic, strong)NSURL *movieURL;

/*
 *录制视频取消按钮
 */
@property(nonatomic, strong)UIButton *cancelButton;
/*
 *开始录制视频按钮
 */
@property(nonatomic, strong)UIButton *videoStartButton;
/*
 *返回按钮
 */
@property(nonatomic, strong)UIButton *backButton;
/*
 *记录是否为返回按钮点击
 */
@property(nonatomic, assign)BOOL backButtonCliked;

@end

@implementation ZCVideoViewController

#pragma mark life cycle
/*在该方法中通常做添加子视图操作，子视图的创建不要在这里面做*/
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.filterView];
    
    [self.view addSubview:self.cancelButton];
    
    [self.view addSubview:self.videoStartButton];
    
    [self.view addSubview:self.backButton];
    
    
}

/*在该方法中通常配置操作 ，子视图的frame设置不要在这里面做*/
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //首先初始化声音和视频参数
     self.videoSettings = [[NSMutableDictionary alloc] init];
    [self.videoSettings setObject:AVVideoCodecH264 forKey:AVVideoCodecKey];
    [self.videoSettings setObject:[NSNumber numberWithInteger:200] forKey:AVVideoWidthKey];
    [self.videoSettings setObject:[NSNumber numberWithInteger:200] forKey:AVVideoHeightKey];
    
    //init audio setting
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    
    self.audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                          [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                          [ NSNumber numberWithInt: 2 ], AVNumberOfChannelsKey,
                          [ NSNumber numberWithFloat: 16000.0 ], AVSampleRateKey,
                          [ NSData dataWithBytes:&channelLayout length: sizeof( AudioChannelLayout ) ], AVChannelLayoutKey,
                          [ NSNumber numberWithInt: 32000 ], AVEncoderBitRateKey,
                          nil];
    
    /*接下来是GPUImageVideoCamera和滤镜效果的初始化*/
    //初始化videocamer
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    [self.videoCamera addTarget:self.filterView];
    [self.videoCamera startCameraCapture];
    
    [self.videoCamera removeAllTargets];
    
    //初始化滤镜
    self.beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    
    //把滤镜效果加给摄像头
    [self.videoCamera addTarget:self.beautifyFilter];
    [self.beautifyFilter addTarget:self.filterView];
    
}
/*在该方法中设置子视图的frame比较准确*/
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.backButton.frame = CGRectMake(10, 20, 35, 35);
    
    CGFloat buttobWH = 50;
    self.cancelButton.frame = CGRectMake(10, ScreenH - 100, buttobWH, buttobWH);
    
    self.videoStartButton.frame = CGRectMake((ScreenW - buttobWH) / 2, ScreenH - 100, buttobWH, buttobWH);
    
    self.filterView.frame = self.view.frame;
    
}

#pragma 按钮点击相关方法
/*返回按钮点击*/
- (void)backButtonClik {
    
    self.backButtonCliked = YES;
    
    //判断是否还在录制,title为录制,表示不在录制，可直接退出，为结束表示还在录制提示用户
    if([self.videoStartButton.titleLabel.text isEqualToString:@"结束"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要放弃这段视频吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        

    }else {
        
        [self.beautifyFilter removeTarget:self.movieWriter];
        //取消录制
        [self.movieWriter cancelRecording];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
}

/*取消按钮点击*/
- (void)cancelButtonClik {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要放弃这段视频吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

/*开始录制按钮点击*/
- (void)videoStarButtonClik {
    
    if([self.videoStartButton.titleLabel.text isEqualToString:@"结束"])
    {
        [self.videoStartButton setImage:[UIImage imageNamed:@"Icon"] forState:UIControlStateNormal];
        [self.videoStartButton setTitle:@"录制" forState:UIControlStateNormal];
        [self.beautifyFilter removeTarget:self.movieWriter];
        
        //结束录制
        [self.movieWriter finishRecording];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.pathToMovie))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:self.movieURL completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (error) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                         
                     } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        }
        
    }else {
        
        self.pathToMovie =  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/movie4.m4v"];
        unlink([self.pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        
        NSURL *movieURL = [NSURL fileURLWithPath:self.pathToMovie];
        self.movieURL = movieURL;
        
        //init movieWriter
        self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1280.0, 720.0) fileType:AVFileTypeMPEG4 outputSettings:self.videoSettings];
        [self.movieWriter setHasAudioTrack:YES audioSettings:self.audioSettings];
        
        self.movieWriter.encodingLiveVideo = YES;
        self.movieWriter.shouldPassthroughAudio = YES;
        
        [self.beautifyFilter addTarget:self.movieWriter];
        
        //这样初始化的工作就全部做完了，要开始录制只要开启以下代码：
        
        self.videoCamera.audioEncodingTarget = self.movieWriter;
        
        [self.movieWriter startRecording];
        
        [self.videoStartButton setTitle:@"结束" forState:UIControlStateNormal];
        [self.videoStartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.videoStartButton setImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {//取消
        
         //继续录制
        self.backButtonCliked = NO;

    }else {
        
        if (self.backButtonCliked) {
            
            [self.beautifyFilter removeTarget:self.movieWriter];
            //取消录制
            [self.movieWriter finishRecording];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else {
        
            [self.beautifyFilter removeTarget:self.movieWriter];
            //取消录制
            [self.movieWriter finishRecording];
            [self.videoStartButton setImage:[UIImage imageNamed:@"Icon"] forState:UIControlStateNormal];
            [self.videoStartButton setTitle:@"录制" forState:UIControlStateNormal];
        
        }
    }
}

#pragma mark 子控件懒加载方法，懒加载方法往后，这样不影响主逻辑
- (UIButton *)backButton {
    
    if (_backButton == nil) {
        self.backButton = [[UIButton alloc] init];
        [self.backButton setImage:[UIImage imageNamed:@"back_hight"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonClik) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
-(UIButton *)cancelButton {
    
    if (_cancelButton == nil) {
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setImage:[UIImage imageNamed:@"btn_del_active_a"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClik) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)videoStartButton {
    
    if (_videoStartButton == nil) {
        
        self.videoStartButton = [[UIButton alloc] init];
        
        [self.videoStartButton setImage:[UIImage imageNamed:@"Icon"] forState:UIControlStateNormal];
        [self.videoStartButton addTarget:self action:@selector(videoStarButtonClik) forControlEvents:UIControlEventTouchUpInside];
        self.videoStartButton.layer.cornerRadius = 20.0;//（该值到一定的程度，就为圆形了。）
        self.videoStartButton.layer.borderWidth = 1.0;
        self.videoStartButton.layer.borderColor =[UIColor clearColor].CGColor;
        self.videoStartButton.clipsToBounds = TRUE;//去除边界
        [self.videoStartButton setBackgroundColor: [UIColor colorWithRed:227/255.0 green:0/255.0 blue:73/255.0 alpha:1.0]];

    }
    return _videoStartButton;
}

- (GPUImageView *)filterView {
    
    if (_filterView == nil) {
        //初始化显示滤镜
        self.filterView = [[GPUImageView alloc] init];
        self.filterView.center = self.view.center;

    }
    return _filterView;
}
@end
