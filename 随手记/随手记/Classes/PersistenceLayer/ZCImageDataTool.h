//
//  ZCImageDataTool.h
//  随手记
//
//  Created by MrZhao on 16/7/21.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//  数据持久层，用于获取图像数据，供业务逻辑层调用

#import <Foundation/Foundation.h>

@interface ZCImageDataTool : NSObject
+ (NSArray *)readImageDataWithPage:(int)page;
+ (BOOL)deletImageDataWithArray:(NSArray *)imageArray;
+ (BOOL)saveImageWithData:(NSData *)data imageName:(NSString *)imageName;
@end
