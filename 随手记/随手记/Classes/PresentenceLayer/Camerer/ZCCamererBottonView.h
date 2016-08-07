//
//  ZCCamererBottonView.h
//  随手记
//
//  Created by MrZhao on 16/7/6.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCCamererBottonView : UIView
/*
 *配置照相页面底部View各按钮的点击事件
 */
- (void)configBottonViewWith:(UIViewController *)target imageViewButtonAction:(SEL)imageViewAction takePhotoButtonAction:(SEL)takePhotoAction faceBeautifullAction:(SEL)faceBeautifullAction cancelAction:(SEL)cancelAction saveAction:(SEL)saveAction;

/*
 *配置照相页面底部View各按钮是否隐藏
 */
- (void)configBottonViewSubViewcancelHidden:(BOOL)cancelHidden imageViewButton:(BOOL)imageViewHidden
                takePhotoButtonHidden:(BOOL)takePhotoHidden faceBeautifulHidden:(BOOL)faceBeautifulHidden saveButtonHidden:(BOOL)saveButtonHiddem;
/*
 *配置照相页面底部View最左边的图片
 */
- (void)configLeftImageViewWithImage:(UIImage *)image;

@end
