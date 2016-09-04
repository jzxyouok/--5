//
//  ZCLinLiveUserView.m
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCLinLiveUserView.h"
#import "UIImageView+WebCache.h"
@interface ZCLinLiveUserView ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *careNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumberLabel;

@end
@implementation ZCLinLiveUserView

+ (instancetype)linLiveUserView {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    
    self.coverImageView.layer.cornerRadius = self.coverImageView.frame.size.height * 0.5;
    self.coverImageView.layer.masksToBounds = YES;
    
}
- (void)configlinLiveUserViewWithImageViewURLStr:(NSString *)urlStr nikName:(NSString *)nikeName {
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.nickNameLabel.text = nikeName;
    
    self.careNumberLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(5000) + 500];
    self.fansNumberLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(30000) + 500];
}
//举报
- (IBAction)tipoffs {
    
    if ([self.delegate respondsToSelector:@selector(tipsClik:)]) {
        [self.delegate tipsClik:self];
    }
}

- (IBAction)closeBUttonClik {
    
    if ([self.delegate respondsToSelector:@selector(closeButtonClik:)]) {
        [self.delegate closeButtonClik:self];
    }
}

@end
