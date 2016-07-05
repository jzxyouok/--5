//
//  ZCViewControllerDispatchMediation.m
//  随手记
//
//  Created by MrZhao on 16/7/4.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCViewControllerDispatchMediation.h"
#import "ZCConst.h"
@interface ZCViewControllerDispatchMediation ()

@end
static ZCViewControllerDispatchMediation *_shareViewControllerDispatchMediation;
@implementation ZCViewControllerDispatchMediation
#pragma mark 派遣相关方法
- (void)dispatchViewControllerWithVc:(UIViewController *)Vc type:(int)type paramers:(id)paramers {
    switch (type) {
        case kCamererVc:
            
            [Vc.navigationController presentViewController:nil animated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
}
#pragma mark 单例相关方法
+ (ZCViewControllerDispatchMediation *)shareViewControllerDispatchMediation {
    if (_shareViewControllerDispatchMediation == nil) {
        return [[self alloc] init];
    }
    return _shareViewControllerDispatchMediation;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (_shareViewControllerDispatchMediation == nil) {
        static dispatch_once_t one;
        dispatch_once(&one, ^{
            
            _shareViewControllerDispatchMediation = [super allocWithZone:zone];
        });
    }
    return _shareViewControllerDispatchMediation;
}

//复写init方法，防止重新初始化
- (instancetype)init {
    
    if(_shareViewControllerDispatchMediation == nil){
        static dispatch_once_t one;
        dispatch_once(&one, ^{
            
            _shareViewControllerDispatchMediation = [super init];
        });
    }
     return _shareViewControllerDispatchMediation;
}
@end
