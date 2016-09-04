//
//  ZCLinLiveAnchorView.h
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//  左上角的头像，在线人数View

#import <UIKit/UIKit.h>

@class ZCLinLiveAnchorView;
/**协议，点击头像时让控制器弹出详情页*/
@protocol linLiveAnchorViewDelegate <NSObject>

@optional

- (void)headImageViewClik:(ZCLinLiveAnchorView *)linLiveAnchorView;

@end

@interface ZCLinLiveAnchorView : UIView
//提供一个工厂方法
+ (instancetype)linLiveAnchorView;

//配置anchorView
- (void)configWithImageString:(NSString *)urlString name:(NSString *)name peopleNumber:(NSUInteger)peopleNumber;

/*代理**/
@property (nonatomic, weak)id <linLiveAnchorViewDelegate>delegate;

@end
