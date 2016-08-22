//
//  ZCZhiboCollectionViewCell.m
//  随手记
//
//  Created by MrZhao on 16/8/22.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCZhiboCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface ZCZhiboCollectionViewCell ()
@property (nonatomic,strong)UIImageView *coverImageView;
@property (nonatomic,strong)UIButton *location;
@property (nonatomic,strong)UIImageView *star;
@property (nonatomic,strong)UILabel *nikeName;
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
    
    CGFloat margin = 5;
    //coverImage
    self.coverImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.location.frame = CGRectMake(margin, margin, 50, 17);
    
    CGFloat x = self.frame.size.width - 33 - margin;
    self.star.frame = CGRectMake(x, margin, 33, 17);
    
    
    CGFloat y = self.frame.size.height - 40;
    self.nikeName.frame = CGRectMake(0, y, self.frame.size.width, 40);
    
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
