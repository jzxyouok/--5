//
//  ZCImageShowBottomView.h
//  随手记
//
//  Created by MrZhao on 16/7/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCImageShowBottomView : UIView
/*
 *配置底部美颜底的方法
 */
- (void)configBottonViewWith:(UIViewController *)target faceBeautifullAction:(SEL)faceBeautifullAction cancelAction:(SEL)cancelAction saveAction:(SEL)saveAction;

@end
