//
//  UIBarButtonItem+Extention.h
//  myWeibo
//
//  Created by MrZhao on 16/2/27.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extention)

//这个是提供自定义带图片的item
+ (UIBarButtonItem *)initWithAction: (SEL)action viewcontroller:(id)Vc imageNamed:(NSString *)imgnamed hightedImageNamed:(NSString *)hightimgnamed;

//该方法提供一种自定义item字体颜色和大小的item
+ (UIBarButtonItem *)initWithTitle:(NSString *)title action: (SEL)action viewcontroller:(id)Vc textFont:(UIFont *)font textNormolColor: (UIColor *)norColor textDisenbleColor: (UIColor *)disColor;
@end
