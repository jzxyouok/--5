//
//  UIImage+ZCExtention.m
//  随手记
//
//  Created by MrZhao on 16/9/3.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "UIImage+ZCExtention.h"

@implementation UIImage (ZCExtention)

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize )size {
    if (color) {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
    }
    return nil;
}
@end
