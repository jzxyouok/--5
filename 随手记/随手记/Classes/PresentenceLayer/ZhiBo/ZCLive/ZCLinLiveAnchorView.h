//
//  ZCLinLiveAnchorView.h
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//  左上角的头像，在线人数View

#import <UIKit/UIKit.h>

@interface ZCLinLiveAnchorView : UIView
//提供一个工厂方法
+ (instancetype)linLiveAnchorView;

//配置anchorView
- (void)configWithImageString:(NSString *)urlString name:(NSString *)name peopleNumber:(NSUInteger)peopleNumber;
@end
