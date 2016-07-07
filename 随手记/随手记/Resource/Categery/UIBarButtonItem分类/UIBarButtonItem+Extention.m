//
//  UIBarButtonItem+Extention.m
//  myWeibo
//
//  Created by MrZhao on 16/2/27.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//
//为导航控制器baiButtonItem 做分类实现自定义item.

#import "UIBarButtonItem+Extention.h"

@implementation UIBarButtonItem (Extention)
+ (UIBarButtonItem *)initWithAction:(SEL)action viewcontroller:(id)Vc imageNamed:(NSString *)imgnamed hightedImageNamed:(NSString *)hightimgnamed
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imgnamed ] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightimgnamed] forState:UIControlStateHighlighted];
    [btn addTarget:Vc action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置按钮位置，不然无法显示
    btn.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);
    [btn sizeToFit];

    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)initWithTitle:(NSString *)title action:(SEL)action viewcontroller:(id)Vc textFont:(UIFont *)font textNormolColor:(UIColor *)norColor textDisenbleColor:(UIColor *)disColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn addTarget:Vc action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateDisabled];
    [btn setTitleColor:norColor forState:UIControlStateNormal];
    [btn setTitleColor:disColor forState:UIControlStateDisabled];
    btn.font = font;
    
    //设置按钮位置，不然无法显示
    //btn.frame = CGRectMake(0, 0, );
    [btn sizeToFit];
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
@end
