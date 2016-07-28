//
//  ZCImageDataBL.m
//  随手记
//
//  Created by MrZhao on 16/7/21.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCImageDataBL.h"
#import "ZCImageDataTool.h"
@implementation ZCImageDataBL
+ (NSArray *)readImageDataWithPage:(int)page {
    
   return  [ZCImageDataTool readImageDataWithPage:page];
    
}
+ (BOOL)deletImageDataWithArray:(NSArray *)imageDataArray {
    
    return [ZCImageDataTool deletImageDataWithArray:imageDataArray];
}
+(BOOL)saveImageData:(UIImage *)image {
    
    //调用数据持久层保存数据，注意这里要获取系统时间作为图片的名字，系统时间，图片名字应该在这里获取，因为这属于逻辑层的业务，不应该交给数据持久层来做。
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    // 年月日获得
    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                       fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    comps =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit)
                       fromDate:date];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    NSInteger second = [comps second];
    
    NSString *imageNameStr = [NSString stringWithFormat:@"%d/%d/%d/%d/%d/%d",year,month,day,hour,minute,second];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    if ([ZCImageDataTool saveImageWithData:imageData imageName:imageNameStr]) {
        return YES;
        
    }else{
        
        return NO;
    }
    
}
+ (BOOL)updataImageWithImage:(UIImage *)image imageName:(NSString *)imageName {
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
   return  [ZCImageDataTool updataImageWithData:data imageName:imageName];
}

+ (UIImage *)readOneImageData {
    
    return [ZCImageDataTool readOneImageData];
}
@end
