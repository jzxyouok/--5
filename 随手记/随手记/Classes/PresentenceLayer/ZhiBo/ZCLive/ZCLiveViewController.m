//
//  ZCLiveViewController.m
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCLiveViewController.h"
#import "ZCLinLiveBottomView.h"
#import "ZCLinLiveAnchorView.h"
#import "ZCLinLiveEndView.h"
#import "ZCLinLiveUserView.h"
#import "ZCLinLive.h"
#import "ZCConst.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface ZCLiveViewController ()

/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
/** 底部的View */
@property (nonatomic, strong) ZCLinLiveBottomView *bottomView;
/** 顶部主播相关视图 */
@property (nonatomic, strong) ZCLinLiveAnchorView *anchorView;
/** 直播开始前的占位图片 */
@property (nonatomic, strong) UIImageView *placeHolderView;
/** 直播开始前的加载动画 */
@property (nonatomic, strong) UIImageView *loadingAnimationView;

/** 粒子动画 */
@property (nonatomic, strong) CAEmitterLayer *emitterLayer;
/** 直播结束的界面 */
@property (nonatomic, strong) ZCLinLiveEndView *endView;

@end

@implementation ZCLiveViewController

#pragma life cycle
//这里只做添加子视图操作
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //将播放器的view添加到视图上
    [self.view addSubview:self.moviePlayer.view];
    
    //开始时展示一张大图做占位
    [self.view addSubview:self.placeHolderView];
    
    //直播开始前显示loading,提醒
    [self.view addSubview:self.loadingAnimationView];
    
    //添加底部的View
    [self.view addSubview:self.bottomView];
    
    //添加顶部的View
    [self.view addSubview:self.anchorView];
}
//在这个方法中做相关配置工作
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.placeHolderView.hidden = NO;
    self.loadingAnimationView.hidden = NO;
    [self.loadingAnimationView startAnimating];
    
    // 设置监听
    [self initObserver];

    //初始化直播播放器
    
    [self.moviePlayer prepareToPlay];

}
//在这里对子视图做布局,这样才准确
- (void)viewDidLayoutSubviews {
    
    //占位符
     self.placeHolderView.frame = self.view.bounds;
    
    //正在加载动画
    CGFloat imageW = 60;
    CGFloat imageH = 72;
    self.loadingAnimationView.frame = CGRectMake((ScreenW - imageW) / 2, (ScreenH - imageH) / 2, imageW, imageH);
    
    //anchorView
    [self.anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(220);
        
    }];
    
    //底部bottomView
    self.bottomView.frame = CGRectMake(0,ScreenH * 0.8, ScreenW, 50);
    
}

// 设置监听
- (void)initObserver {
    
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
}

#pragma mark - notify method

- (void)stateDidChange
{
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.moviePlayer.isPlaying) {
            
            [self.moviePlayer play];
            
            //完成加载后隐藏占位符
            self.placeHolderView.hidden = YES;
            
            //停止加载动画，同时隐藏
            [self.loadingAnimationView stopAnimating];
             self.loadingAnimationView.hidden = YES;
        }
    }else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
        
    }
}

- (void)didFinish
{
    NSLog(@"加载状态...%ld %ld %s", self.moviePlayer.loadState, self.moviePlayer.playbackState, __func__);
    
}

//移除监听
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IJKMPMoviePlayerPlaybackDidFinishNotification" object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IJKMPMoviePlayerLoadStateDidChangeNotification" object:self.moviePlayer];
    
    
}

#pragma 懒加载相关,懒加载放在最后不影响主逻辑
- (ZCLinLiveAnchorView *)anchorView {
    
    if (_anchorView == nil) {
        
        self.anchorView = [ZCLinLiveAnchorView linLiveAnchorView];
        
        [self.anchorView configWithImageString:self.linLive.smallpic name:self.linLive.myname peopleNumber:self.linLive.allnum];
        
    }
    return _anchorView;
}

- (UIImageView *)placeHolderView {
    
    if (_placeHolderView == nil) {
        
        self.placeHolderView = [[UIImageView alloc] init];
        NSURL *url = [NSURL URLWithString:self.linLive.bigpic];
        
        [self.placeHolderView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
    }
    return _placeHolderView;
}

- (UIImageView *)loadingAnimationView {
    if (_loadingAnimationView == nil) {
        
        self.loadingAnimationView = [[UIImageView alloc] init];
        
        //添加动画图片
        NSMutableArray *arrayImages = [NSMutableArray array];
        UIImage *image1 = [UIImage imageNamed:@"hold1_60x72"];
        [arrayImages addObject:image1];
        
        UIImage *image2 = [UIImage imageNamed:@"hold2_60x72"];
        [arrayImages addObject:image2];
        
        UIImage *image3 = [UIImage imageNamed:@"hold3_60x72"];
        [arrayImages addObject:image3];
        
        self.loadingAnimationView.animationDuration = 0.15 *arrayImages.count;
        self.loadingAnimationView.animationImages = arrayImages;
        
    }
    return _loadingAnimationView;
}
- (ZCLinLiveBottomView *)bottomView {
    
    if (_bottomView == nil) {
        
        self.bottomView = [[ZCLinLiveBottomView alloc] init];
    }
    return _bottomView;
}
- (IJKFFMoviePlayerController *)moviePlayer {
    
    if (_moviePlayer == nil) {
        //初始化直播播放器
        
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
        
        // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
        [options setPlayerOptionIntValue:29.97 forKey:@"r"];
        // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
        [options setPlayerOptionIntValue:512 forKey:@"vol"];
        
        self.moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.linLive.flv withOptions:options];
        self.moviePlayer.view.backgroundColor = [UIColor whiteColor];
        
        self.moviePlayer.view.frame = self.view.bounds;
        // 填充fill
        self.moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
        // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
        self.moviePlayer.shouldAutoplay = NO;
        // 默认不显示
        self.moviePlayer.shouldShowHudView = NO;
    }
    
    return _moviePlayer;
    
}
@end
