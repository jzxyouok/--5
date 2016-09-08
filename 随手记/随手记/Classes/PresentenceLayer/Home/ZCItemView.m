//
//  ZCItemView.m
//  随手记
//
//  Created by MrZhao on 16/7/4.
//  Copyright (c) 2016年 MrZhao. All rights reserved.
//

#import "ZCItemView.h"
#import "Masonry.h"

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
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((self.frame.size.width- 60) /2);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);

    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((self.frame.size.width - 60) /2);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.button.mas_bottom).offset(5);
    }];
}
@end
