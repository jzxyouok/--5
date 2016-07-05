//
//  ZCViewControllerDispatchMediation.h
//  随手记
//
//  Created by MrZhao on 16/7/4.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//  提供一个中介者对象，用于控件器之间的派遣工作，避免控制器之间相互包含形成横向依赖

#import <UIKit/UIKit.h>

@interface ZCViewControllerDispatchMediation : UIViewController
/*
 *提供一个单例
 */
+(ZCViewControllerDispatchMediation *)shareViewControllerDispatchMediation;

/*
 *派遣方法，提供一个预留参数，防止有参数传递
 */
-(void)dispatchViewControllerWithVc:(UIViewController *)Vc type:(int)type paramers:(id)paramers;
@end
