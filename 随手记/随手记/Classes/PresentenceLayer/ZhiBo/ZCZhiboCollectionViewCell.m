//
//  ZCZhiboCollectionViewCell.m
//  随手记
//
//  Created by MrZhao on 16/8/22.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCZhiboCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface ZCZhiboCollectionViewCell ()
@property (nonatomic, strong)UIImageView *coverImageView;
@property (nonatomic, strong)UIButton *location;
@property (nonatomic, strong)UIImageView *star;
@property (nonatomic, strong)UILabel *nikeName;
@end

@implementation ZCZhiboCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self setUpChild];
    }
    return self;
}

- (void)setUpChild {
    self.coverImageView = [[UIImageView alloc] init];
    [self addSubview:self.coverImageView];
    
    self.location = [[UIButton alloc] init];
    self.location.titleLabel.font = [UIFont systemFontOfSize:10];
    self.location.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.location];
    
    self.star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flag_new_33x17_"]];
    [self addSubview:self.star];
    
    self.nikeName = [[UILabel alloc] init];
    self.nikeName.textAlignment = NSTextAlignmentCenter;
    self.nikeName.textColor = [UIColor whiteColor];
    self.nikeName.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.nikeName];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(17);
    }];
    

    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.frame.size.width - 38);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(17);
    }];
    
    
    [self.nikeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.frame.size.height - 40);
        make.width.mas_equalTo(self.frame.size.width);
        make.height.mas_equalTo(40);
    }];
    
}
- (void)configCellWithImageURL:(NSString *)url loaction:(NSString *)location isNewStar:(BOOL)isNewStar nikeName:(NSString *)nikeName {
    
    // 设置封面头像
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    // 是否是新主播
    self.star.hidden = isNewStar;
    // 地址
    [self.location setTitle:location forState:UIControlStateNormal];
    // 主播名
    self.nikeName.text = nikeName;
}
@end
