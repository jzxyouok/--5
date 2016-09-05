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
@interface ZCLiveViewController () <linLiveAnchorViewDelegate,linLiveUserViewDelegate>

/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
/** 底部的View */
@property (nonatomic, strong) ZCLinLiveBottomView *bottomView;
/** 顶部主播相关视图 */
@property (nonatomic, strong) ZCLinLiveAnchorView *anchorView;

/** 主播详情相关视图 */
@property (nonatomic, strong) ZCLinLiveUserView *userView;

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
    
    //主播详情的View
    [self.view addSubview:self.userView];
    
    //点赞效果
    [self.view.layer addSublayer:self.emitterLayer];
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
    
    [self.loadingAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(72);
        make.width.mas_equalTo(60);
        make.center.mas_equalTo(0);
    }];
    
    //anchorView
    [self.anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(220);
        
    }];
    
    //底部bottomView
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(0);
    }];
    
    //userView
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(ScreenH * 0.8);
        make.center.mas_equalTo(0);
        
    }];
    
    //点赞layer的位置
    // 发射器在xy平面的中心位置
    self.emitterLayer.emitterPosition = CGPointMake(self.view.frame.size.width - 50,self.view.frame.size.height - 50);
    
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

#pragma mark 代理相关方法
//anchrolView的头像被点击时调用
- (void)headImageViewClik:(ZCLinLiveAnchorView *)linLiveAnchorView {
    
       [UIView animateWithDuration:0.5 animations:^{
           
        //有一个逐渐增大的动画效果
        self.userView.transform = CGAffineTransformMakeScale(1.00, 1.00);
        self.userView.hidden = NO;
           
    }];
}
- (void)tipsClik:(ZCLinLiveUserView *)linLiveUserView {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"举报成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
}
- (void)closeButtonClik:(ZCLinLiveUserView *)linLiveUserView {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.userView.hidden = YES;

    }];
}

- (void)quit
{
    if (_moviePlayer) {
        
        [self.moviePlayer shutdown];
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IJKMPMoviePlayerPlaybackDidFinishNotification" object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IJKMPMoviePlayerLoadStateDidChangeNotification" object:self.moviePlayer];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
#pragma 懒加载相关,懒加载放在最后不影响主逻辑
- (ZCLinLiveAnchorView *)anchorView {
    
    if (_anchorView == nil) {
        
        self.anchorView = [ZCLinLiveAnchorView linLiveAnchorView];
        
        [self.anchorView configWithImageString:self.linLive.smallpic name:self.linLive.myname peopleNumber:self.linLive.allnum];
        self.anchorView.delegate = self;
        
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
        
        //防止循环引用
        __weak typeof(self) weakSelf = self;
        self.bottomView.clikToolBlock = ^(toolType type){
            switch (type) {
                case LiveToolTypePublicTalk:
                {
                    break;
                }
                case LiveToolTypeGift:
                {
                    break;
                }
                case LiveToolTypeRank:
                {
                    break;
                }
                case LiveToolTypeShare:
                {
                    break;
                }
                case LiveToolTypeClose:
                {
                    [weakSelf quit];
                    break;
                }
                default:
                    break;
            }
        
        };
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
- (ZCLinLiveUserView *)userView {
    
    if (_userView == nil) {
        
        self.userView = [ZCLinLiveUserView linLiveUserView];
        [self.userView configlinLiveUserViewWithImageViewURLStr:self.linLive.smallpic nikName:self.linLive.myname];
        self.userView.delegate = self;
        self.userView.hidden = YES;
        self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
    return _userView;
}

- (CAEmitterLayer *)emitterLayer
{
    if (_emitterLayer == nil) {
        
        self.emitterLayer = [CAEmitterLayer layer];
        // 发射器的尺寸大小
        self.emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        self.emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        }
        
        self.emitterLayer.emitterCells = array;
    }
    return _emitterLayer;
}
@end
