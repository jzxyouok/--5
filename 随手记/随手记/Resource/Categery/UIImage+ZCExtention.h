//
//  UIImage+ZCExtention.h
//  随手记
//
//  Created by MrZhao on 16/9/3.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZCExtention)

//通过颜色提供一张背景图
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize )size;
@end
