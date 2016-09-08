//
//  ZCLinLiveUserView.h
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//  主播基本信息的View

#import <UIKit/UIKit.h>

@class ZCLinLiveUserView;
@protocol linLiveUserViewDelegate <NSObject>
@optional
- (void)tipsClik:(ZCLinLiveUserView *)linLiveUserView;
- (void)closeButtonClik:(ZCLinLiveUserView *)linLiveUserView;

@end

@interface ZCLinLiveUserView : UIView
@property (nonatomic, weak)id <linLiveUserViewDelegate>delegate;

+ (instancetype)linLiveUserView;
- (void)configlinLiveUserViewWithImageViewURLStr:(NSString *)urlStr nikName:(NSString *)nikeName;
@end
