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
@interface ZCVideoViewController ()<UIAlertViewDelegate>
@property(nonatomic, strong)GPUImageMovieWriter *movieWriter;
@property(nonatomic, strong)GPUImageView *filterView;
@property(nonatomic, strong)GPUImageBeautifyFilter *beautifyFilter;
@property(nonatomic, strong)GPUImageVideoCamera *videoCamera;
@property(nonatomic, strong)NSMutableDictionary *videoSettings;
@property(nonatomic, strong)NSDictionary *audioSettings;
@property(nonatomic, copy)NSString *pathToMovie;


@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)UIButton *saveButton;
@property(nonatomic, strong)UIButton *videoStartButton;

@end

@implementation ZCVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.filterView];
    
    [self.view addSubview:self.cancelButton];
    
    [self.view addSubview:self.videoStartButton];
    
    [self.view addSubview:self.saveButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //首先初始化声音和视频参数
    //init Video Setting
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
    
    //然后是初始化文件路径和视频写入对象
    //init Movie path
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //获取系统时间，用于视频文件名
    
    //调用数据持久层保存数据，注意这里要获取系统时间作为图片的名字，系统时间，图片名字应该在这里获取，因为这属于逻辑层的业务，不应该交给数据持久层来做。
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    // 年月日获得
    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                        fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    comps =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit)
                       fromDate:date];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    
    NSString *movieName = [NSString stringWithFormat:@"%d/%d/%d/%d/%d",year,month,day,hour,minute];
    movieName = [movieName stringByAppendingString:@".movie"];
    
    path = [path stringByAppendingPathComponent:movieName];
    self.pathToMovie = path;
    unlink([self.pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:self.pathToMovie];
    
    //init movieWriter
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1280.0, 720.0) fileType:AVFileTypeMPEG4 outputSettings:self.videoSettings];
    
    [self.movieWriter setHasAudioTrack:YES audioSettings:self.audioSettings];
    
    //接下来是GPUImageVideoCamera和滤镜效果的初始化
    //初始化videocamer
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;

    
    [self.videoCamera addTarget:self.filterView];
    [self.videoCamera startCameraCapture];
    
    //初始化滤镜
    self.beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    
    //把滤镜效果加给摄像头
    [self.videoCamera addTarget:self.beautifyFilter];
    
    //把摄像头上的图像给GPUImageView显示出来
    [self.beautifyFilter addTarget:self.filterView];
    [self.beautifyFilter addTarget:self.movieWriter];
    
    //这样初始化的工作就全部做完了，要开始录制只要开启以下代码：
    
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    
    //[self.movieWriter startRecording];
    // 就可以开始录制了，结束录制也很简单：
    //stop recording
    //[self.beautifyFilter removeTarget:self.movieWriter];
    //[self.movieWriter finishRecording];

}
#pragma 按钮点击相关方法
- (void)cancelButtonClik {
    
    //先暂停录制
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要放弃这段视频吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)videoStarButtonClik {
   [self.movieWriter startRecording];
}
- (void)saveButtonClik {

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {//取消
        //继续录制
    }else {
        
        [self.beautifyFilter removeTarget:self.movieWriter];
        [self.movieWriter finishRecording];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
#pragma 懒加载相关
- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 35, 35)];
        [self.cancelButton setImage:[UIImage imageNamed:@"btn_input_clear"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClik) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)videoStartButton {
    
    CGFloat buttobWH = 50;
    if (_videoStartButton == nil) {
        self.videoStartButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW - buttobWH) / 2, ScreenH - 100, buttobWH, buttobWH)];
        [self.videoStartButton setImage:[UIImage imageNamed:@"Icon"] forState:UIControlStateNormal];
        [self.videoStartButton addTarget:self action:@selector(videoStarButtonClik) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _videoStartButton;
}

- (UIButton *)saveButton {
    CGFloat buttobWH = 50;
    if (_saveButton == nil) {
        
        self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW - buttobWH - 10) , ScreenH - 100, buttobWH, buttobWH)];
        [self.saveButton setImage:[UIImage imageNamed:@"btn_camera_done_a"] forState:UIControlStateNormal];
        [self.saveButton addTarget:self action:@selector(saveButtonClik) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
- (GPUImageView *)filterView {
    if (_filterView == nil) {
        //初始化显示滤镜
        self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
        self.filterView.center = self.view.center;

    }
    return _filterView;
}
@end
