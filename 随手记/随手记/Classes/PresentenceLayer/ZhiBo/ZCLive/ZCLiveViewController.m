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
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "Masonry.h"
@interface ZCLiveViewController ()
/** 直播播放器 */
@property (nonatomic, weak) IJKFFMoviePlayerController *moviePlayer;
/** 底部的View */
@property(nonatomic, weak)ZCLinLiveBottomView *bottomView;
/** 顶部主播相关视图 */
@property(nonatomic, weak) ZCLinLiveAnchorView *anchorView;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;
/** 直播结束的界面 */
@property (nonatomic, weak) ZCLinLiveEndView *endView;
@end

@implementation ZCLiveViewController

#pragma life cycle
//这里只做添加子视图操作
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.anchorView];
    [self.view addSubview:self.placeHolderView];
    [self.view addSubview:self.bottomView];
}
//在这里对子视图做布局
- (void)viewDidLayoutSubviews {
    
    //bottomView
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@50);
        make.bottom.equalTo(@30);
    }];
    
}
#pragma 懒加载相关,懒加载放在最后不影响主逻辑
- (ZCLinLiveAnchorView *)anchorView {
    if (_anchorView == nil) {
        ZCLinLiveAnchorView *anchorView = [[ZCLinLiveAnchorView alloc] init];
        _anchorView = anchorView;
    }
    return _anchorView;
}

- (UIImageView *)placeHolderView {
    
    if (_placeHolderView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"profile_user_414x414"];
        _placeHolderView = imageView;
    }
    return _placeHolderView;
}
- (ZCLinLiveBottomView *)bottomView {
    
    if (_bottomView == nil) {
        
        ZCLinLiveBottomView *bottomView = [[ZCLinLiveBottomView alloc] init];
        _bottomView = bottomView;
        
    }
    return _bottomView;
}
@end
