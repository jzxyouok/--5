//
//  ZCImageDataTool.h
//  随手记
//
//  Created by MrZhao on 16/7/21.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//  数据持久层，用于获取图像数据，供业务逻辑层调用

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZCImageDataTool : NSObject
/*
 *读取数据，page指定读取的页数
 */
+ (NSArray *)readImageDataWithPage:(int)page;
/*
 *删除指定的数据
 */
+ (BOOL)deletImageDataWithArray:(NSArray *)imageArray;
/*
 *保存数据
 */
+ (BOOL)saveImageWithData:(NSData *)data imageName:(NSString *)imageName;
/*
 *更新数据
 */
+ (BOOL)updataImageWithData:(NSData *)data imageName:(NSString *)imageName;

/*
 *获取最新一张图，放入左下角
 */
+ (UIImage *)readOneImageData;
@end
