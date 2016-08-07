//
//  ZCItemView.h
//  随手记
//
//  Created by MrZhao on 16/7/4.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCItemView : UIView
/*
 *配置首页Item
 */
- (void)configItemViewWithImageName:(NSString *)imageName title:(NSString *)title backgroundColor:(UIColor *)color tagert:(id)target action:(SEL)action;
@end
