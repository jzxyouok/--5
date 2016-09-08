//
//  ZCLinLiveEndView.h
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//  直播结束时显示的View

#import <UIKit/UIKit.h>

@class ZCLinLiveEndView;
@protocol linLiveEndViewDelegate <NSObject>
@optional
- (void)exitButtonClik:(ZCLinLiveEndView *)linLiveEndView;
- (void)lookOtherButtonClik:(ZCLinLiveEndView *)linLiveEndView;
@end

@interface ZCLinLiveEndView : UIView

@property (nonatomic, weak)id <linLiveEndViewDelegate>delegate;
+ (instancetype)linLiveEndView;

@end
