//
//  UIView+Extention.m
//  myWeibo
//
//  Created by MrZhao on 16/2/27.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "UIView+Extention.h"

@implementation UIView (Extention)
- (void)setX:(CGFloat)x {
    
    //OC语法规定结构体内的成员变量是不可直接修改的，必须先拿出来，然后修改在复制回去
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
-(CGFloat)x {
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
-(CGFloat)y {
    return self.frame.origin.y;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(CGFloat)width {
    return self.frame.size.width;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
-(CGFloat)height {
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
-(CGSize) size {
    return self.frame.size;
}
@end
