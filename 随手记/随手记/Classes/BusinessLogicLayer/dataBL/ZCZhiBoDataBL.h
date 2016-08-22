//
//  ZCZhiBoDataBL.h
//  随手记
//
//  Created by MrZhao on 16/8/22.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCZhiBoDataBL : NSObject
//获取直播间的最新主播数据
+ (NSArray *)getNewZhiBoDataWithPage:(int)page;

@end
