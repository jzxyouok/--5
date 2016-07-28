//
//  main.m
//  随手记
//
//  Created by MrZhao on 16/7/4.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<ZCPicturesShowCollectionViewController: 0x15e0f540>)

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
