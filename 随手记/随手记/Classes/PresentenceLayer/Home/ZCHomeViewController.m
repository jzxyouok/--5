//
//  ZCHomeViewController.m
//  随手记
//
//  Created by MrZhao on 16/7/4.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCHomeViewController.h"
#import "ZCViewControllerDispatchMediation.h"
#import "ZCItemView.h"
#import "ZCConst.h"

@interface ZCHomeViewController ()
/*
 *标题图片
 */
@property(nonatomic,strong)UIImageView *icon;
/*
 *标题
 */
@property(nonatomic,strong)UILabel *titleLabel;
/*
 *标题描述
 */
@property(nonatomic,strong)UILabel *descLabel;
/*
 *自拍
 */
@property(nonatomic,strong)ZCItemView *camerer;
/*
 *录视频
 */
@property(nonatomic,strong)ZCItemView *video;
/*
 *直播
 */
@property(nonatomic,strong)ZCItemView *timeVideo;
/*
 *笔记
 */
@property(nonatomic,strong)ZCItemView *notes;


@end

@implementation ZCHomeViewController

/*在该方法中通常做添加子视图操作，子视图的创建不要在这里面做*/
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.icon];//注意不能用_icon这是调用set方法，那么所有控件都不会创建了
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.descLabel];
    
    [self.view addSubview:self.camerer];
    
    [self.view addSubview:self.video];
    
    [self.view addSubview:self.notes];
    
    [self.view addSubview:self.timeVideo];
    

    
}
/*在该方法中通常初始化操作 ，子视图的创建不要在这里面做*/
- (void)viewWillAppear:(BOOL)animated{
    
//    //隐藏导航栏
//    [self.navigationController.navigationBar setHidden:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:231/255.0 green:143/255.0 blue:186/255.0 alpha:1.0];
    CGFloat margin = 15;
    
    CGFloat iconWH = 70;
    self.icon.frame = CGRectMake((ScreenW - iconWH) / 2, 64, iconWH, iconWH);
    
    CGFloat titleW = 90;
    CGFloat titleH = 40;
    CGFloat titleY = CGRectGetMaxY(self.icon.frame) +margin;
    self.titleLabel.frame = CGRectMake((ScreenW - titleW) / 2, titleY , titleW, titleH);
    
    
    CGFloat descW = 90;
    CGFloat descH = 40;
    CGFloat descY = CGRectGetMaxY(self.titleLabel.frame);
    self.descLabel.frame = CGRectMake((ScreenW - descW) / 2, descY, descW, descH);
    
    CGFloat imageWH = 90;
    CGFloat camererX = (ScreenW - 2 * imageWH - 4* margin) /2;
    CGFloat camererY = ScreenH / 2 - 50;
    self.camerer.frame = CGRectMake(camererX, camererY, imageWH, imageWH);
    
    CGFloat videoX = CGRectGetMaxX(self.camerer.frame) + 4*margin;
    self.video.frame = CGRectMake(videoX, camererY , imageWH, imageWH);
    
    CGFloat notesY = CGRectGetMaxY(self.video.frame) + 4 *margin;
    self.notes.frame = CGRectMake(camererX, notesY, imageWH, imageWH);
   
    self.timeVideo.frame = CGRectMake(videoX , notesY, imageWH, imageWH);
    
}
#pragma mark 点击各item调用的方法
//照相
- (void)camererButtonClik {
    
    ZCViewControllerDispatchMediation *mediationVc =[ZCViewControllerDispatchMediation shareViewControllerDispatchMediation];
    
    [mediationVc dispatchViewControllerWithVc:self type:kCamererVc paramers:nil];
    
}
- (void)videoButtonClik {
    
    ZCViewControllerDispatchMediation *mediationVc =[ZCViewControllerDispatchMediation shareViewControllerDispatchMediation];
    [mediationVc dispatchViewControllerWithVc:self type:kVideoVc paramers:nil];
    
}
- (void)notesButtonClik {

}
- (void)timeVideoButtonClik {

}


#pragma mark 子控件懒加载方法，懒加载方法往后放逻辑更直观
- (UIImageView *)icon {
    
    if (_icon == nil) {
        
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camerer"]];
    }
    return _icon;
}
- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"随手记";
        self.titleLabel.contentMode = UIViewContentModeCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:30];
    }
    return _titleLabel;
}
- (UILabel *)descLabel {
    if (_descLabel == nil) {
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.text = @"记录生活点滴";
        self.descLabel.textColor = [UIColor whiteColor];
        self.descLabel.font = [UIFont systemFontOfSize:15];
        self.descLabel.contentMode = UIViewContentModeCenter;
    }
    return _descLabel;
}
- (ZCItemView *)camerer{
    if (_camerer == nil) {
        
        self.camerer = [[ZCItemView alloc] init];
        [self.camerer configItemViewWithImageName:@"camerer" title:@"拍照" backgroundColor:  [UIColor colorWithRed:222/255.0 green:47/255.0 blue:120/255.0 alpha:1.0] tagert:self action:@selector(camererButtonClik)];
       
    }
    return _camerer;
}

- (ZCItemView *)video{
    
    if (_video == nil) {
        
        self.video =  [[ZCItemView alloc] init];
        
        [self.video configItemViewWithImageName:@"video" title:@"视频自拍" backgroundColor: [UIColor colorWithRed:245/255.0 green:184/255.0 blue:14/255.0 alpha:1.0]
                                         tagert:self action:@selector(videoButtonClik)];
        
    }
    return _video;
}

- (ZCItemView *)timeVideo{
    if (_timeVideo == nil) {
        
        self.timeVideo =  [[ZCItemView alloc] init];
        
        [self.timeVideo configItemViewWithImageName:@"timeVideo" title:@"TV直播" backgroundColor: [UIColor colorWithRed:113/255.0 green:58/255.0 blue:161/255.0 alpha:1.0] tagert:self action:@selector(timeVideoButtonClik)];

    }
    return _timeVideo;
}
- (ZCItemView *)notes{
    if (_notes == nil) {
        
        self.notes =  [[ZCItemView alloc] init];
        
        [self.notes configItemViewWithImageName:@"notes" title:@"日记" backgroundColor: [UIColor colorWithRed:113/255.0 green:58/255.0 blue:161/255.0 alpha:1.0] tagert:self action:@selector(notesButtonClik)];
    }
    return _notes;
}

@end
