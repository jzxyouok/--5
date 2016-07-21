//
//  ZCCamererBottonView.h
//  随手记
//
//  Created by MrZhao on 16/7/6.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCCamererBottonView : UIView
- (void)configBottonViewWith:(UIViewController *)target imageViewButtonAction:(SEL)imageViewAction takePhotoButtonAction:(SEL)takePhotoAction faceBeautifullAction:(SEL)faceBeautifullAction cancelAction:(SEL)cancelAction saveAction:(SEL)saveAction;

- (void)configBottonViewSubViewcancelHidden:(BOOL)cancelHidden imageViewButton:(BOOL)imageViewHidden
                takePhotoButtonHidden:(BOOL)takePhotoHidden faceBeautifulHidden:(BOOL)faceBeautifulHidden saveButtonHidden:(BOOL)saveButtonHiddem;
- (void)configLeftImageViewWithImage:(UIImage *)image;
@end
