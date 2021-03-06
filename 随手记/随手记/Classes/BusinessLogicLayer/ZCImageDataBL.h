//
//  ZCImageDataBL.h
//  随手记
//
//  Created by MrZhao on 16/7/21.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//   业务逻辑层，专门负责获取图像数据，供展示层调用，自身则调用数据持久层获取数据，将从数据层获取的数据转化成展示层可以直接使用的数据
//   这样展示层就不需要做业务逻辑

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZCImageDataBL : NSObject
/*
 *读取数据，page指定读取的页数
 */
+ (NSArray *)readImageDataWithPage:(int)page;

/*
 *删除指定的数据
 */
+ (BOOL)deletImageDataWithArray:(NSArray *)imageDataArray;
/*
 *保存数据
 */
+ (BOOL)saveImageData:(UIImage *)image;
/*
 *更新数据
 */
+ (BOOL)updataImageWithImage:(UIImage *)image imageName:(NSString *)imageName;

/*
 *获取最新一张图，放入左下角
 */
+ (UIImage *)readOneImageData;
@end
