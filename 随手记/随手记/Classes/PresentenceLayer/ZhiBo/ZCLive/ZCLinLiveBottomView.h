//
//  ZCLinLiveBottomView.h
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//  底部的View

#import <UIKit/UIKit.h>
typedef enum {
    LiveToolTypePublicTalk = 1,
    LiveToolTypeGift,
    LiveToolTypeRank,
    LiveToolTypeShare,
    LiveToolTypeClose
}toolType;
@interface ZCLinLiveBottomView : UIView

//工具栏某个图片被点击
@property(nonatomic, copy)void(^clikToolBlock)(toolType type);

@end
