//
//  ZCImageDataTool.m
//  随手记
//
//  Created by MrZhao on 16/7/21.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCImageDataTool.h"
#import "FMDB.h"
#import "ZCImageM.h"

static FMDatabase *_db = nil;
@implementation ZCImageDataTool
+ (void)initialize {
    //数据库名称
    NSString *sqllitePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    sqllitePath = [sqllitePath stringByAppendingPathComponent:@"imagesData.sqlite"];
    NSLog(@"%@",sqllitePath);
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
    
    int size = 10;
    int pos = (page - 1) * size;
    //  注意查询为executeQueryWithFormat
    //   @"select * from t_images order by id limit %d,%d;"
    FMResultSet *set = [_db executeQueryWithFormat:@"select * from t_images order by id limit %d,%d;",pos,size];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    while ([set next]) {
        
        ZCImageM *imageM = [[ZCImageM alloc] init];
        NSData *data = [set objectForColumnName:@"data"];
        NSString *name = [set objectForColumnName:@"name"];
        imageM.image = [[UIImage alloc] initWithData:data];
        imageM.imagName = name;
        [array addObject:imageM];
    }
    return array;
    
}
+ (UIImage *)readOneImageData {
    
    int size = 1;
    int pos = 0;
    //  注意查询为executeQueryWithFormat
    FMResultSet *set = [_db executeQueryWithFormat:@"select * from t_images order by id desc limit %d,%d;",pos,size];
    UIImage *image = nil;
    while ([set next]) {
        
        NSData *data = [set objectForColumnName:@"data"];
        image = [[UIImage alloc] initWithData:data];
    }
    return image;

}
+ (BOOL)deletImageDataWithArray:(NSArray *)imageArray {
    
    for (NSString *name in imageArray) {
        
        [_db executeUpdateWithFormat:@"delete from t_images where name = %@;",name];
    }
    
    return YES;
}
+ (BOOL)saveImageWithData:(NSData *)data imageName:(NSString *)imageName {
    //  注意查询为executeUpdateWithFormat
    if ([_db executeUpdateWithFormat:@"insert into t_images (name,data) values(%@,%@);",imageName,data]) {
        
        NSLog(@"保存成功");
        return YES;
    }else {
        NSLog(@"保存失败");
        return NO;
    }
}
+ (BOOL)updataImageWithData:(NSData *)data imageName:(NSString *)imageName {
    
    if ([_db executeUpdateWithFormat:@"update  t_images set data = %@ where name = %@;",data,imageName]) {
        
        return YES;
    }
    return NO;
}
@end
