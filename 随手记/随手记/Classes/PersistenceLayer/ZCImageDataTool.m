//
//  ZCImageDataTool.m
//  随手记
//
//  Created by MrZhao on 16/7/21.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCImageDataTool.h"
#import "FMDB.h"

static FMDatabase *_db = nil;
@implementation ZCImageDataTool
+ (void)initialize {
    //数据库名称
    NSString *sqllitePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    sqllitePath = [sqllitePath stringByAppendingPathComponent:@"imagesData.sqlite"];
    
    //创建数据库
    if (_db == nil) {
        
        _db = [[FMDatabase alloc] initWithPath:sqllitePath];
    }
    
    //创建表
    if(![_db open]) return;
    if([_db executeUpdate:@"create table  if not exists t_images(id  integer primary key autoincrement not null,name text not null,data blob not null );"]){
         NSLog(@"创建表格成功");
    }else {
        
        NSLog(@"创建表格失败");
    }
    
}
+ (NSArray *)readImageDataWithPage:(int)page {
    
    return nil;
}
+ (BOOL)deletImageDataWithArray:(NSArray *)imageArray {
    
    return YES;
}

+ (BOOL)saveImageWithData:(NSData *)data imageName:(NSString *)imageName {
    
    if ([_db executeQueryWithFormat:@"insert into t_images (name,data) values(%@,%@);",imageName,data]) {
        NSLog(@"保存成功");
        return YES;
    }else {
        NSLog(@"保存失败");
        return NO;
    }
}
@end
