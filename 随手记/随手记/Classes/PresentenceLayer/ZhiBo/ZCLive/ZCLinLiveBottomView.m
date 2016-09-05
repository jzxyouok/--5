//
//  ZCLinLiveBottomView.m
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCLinLiveBottomView.h"
#import "ZCConst.h"
@interface ZCLinLiveBottomView ()

@property(nonatomic, strong)NSArray *tools;

@end

@implementation ZCLinLiveBottomView

- (NSArray *)tools {
    if (_tools == nil) {
        
        _tools = [[NSArray alloc] initWithObjects:@"talk_public_40x40", @"talk_sendgift_40x40", @"talk_rank_40x40", @"talk_share_40x40", @"talk_close_40x40", nil];
    }
    return _tools;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView {
    //添加5个imageView
    CGFloat imageWH = 40;
    CGFloat margin = (ScreenW - imageWH * 5) / 6;
    CGFloat x = 0;
    for (int i = 1; i<6; i++) {
        
        x =( margin * i ) + ( i-1 ) * imageWH;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, imageWH, imageWH)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:self.tools[i - 1]];
        imageView.tag = i ;
        //添加点击手势
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolsClik:)];
        [imageView addGestureRecognizer:tapGr];
        
        [self addSubview:imageView];
    }
}

//某个图片被点击时调用
- (void)toolsClik:(UITapGestureRecognizer *)tap {
    
    if (self.clikToolBlock) {
        
        self.clikToolBlock(tap.view.tag);
    }
}
@end
