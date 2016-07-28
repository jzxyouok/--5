//
//  ZCImageM.h
//  随手记
//
//  Created by MrZhao on 16/7/22.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
@interface ZCImageM : NSObject
/*
 *图片名
 */
@property (nonatomic,copy)NSString *imagName;
/*
 *图片的二进制数据
 */
@property (nonatomic,strong)UIImage *image;
/*
 *用于记录图片有没被选中
 */
@property (nonatomic, assign,getter = isSelected)BOOL isSelected;
/*
 *用于记录图片进入编辑状态
 */
@property (nonatomic, assign,getter = isEditing)BOOL isEditing;

@end
