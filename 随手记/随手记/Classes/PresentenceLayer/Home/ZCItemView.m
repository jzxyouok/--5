//
//  ZCItemView.m
//  随手记
//
//  Created by MrZhao on 16/7/4.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCItemView.h"
@interface ZCItemView ()
@property (nonatomic,weak)UIButton *button;
@property (nonatomic,weak)UILabel *label;
@end
@implementation ZCItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpChild];
    }
    return self;
}
- (void)setUpChild {
    
    //添加两个子控件
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    self.button = button;
    
    //文字
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
}
- (void)configItemViewWithImageName:(NSString *)imageName title:(NSString *)title backgroundColor:(UIColor *)color tagert:(id)target action:(SEL)action {
    
    
    [self.button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.label.text = title;
    self.backgroundColor = color;
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.button.frame = CGRectMake((self.frame.size.width- 60) /2, 5, 60, 60);
    CGFloat labelW = 60;
    CGFloat labelH = 20;
    CGFloat labelX = (self.frame.size.width - labelW) /2;
    CGFloat labelY = CGRectGetMaxY(self.button.frame)+ 5;
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
}
@end
