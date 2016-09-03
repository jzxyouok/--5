//
//  ZCLinLiveAnchorView.m
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCLinLiveAnchorView.h"
#import "UIImage+ZCExtention.h"
#import "UIImageView+WebCache.h"
@interface ZCLinLiveAnchorView ()
@property (weak, nonatomic) IBOutlet UIView *informationView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *gifButtom;
/*定时器更新人数**/
@property (strong, nonatomic) NSTimer *timer;
/*记录人数**/
@property (nonatomic, assign)NSUInteger number;
- (IBAction)closeButtonClik;

@end
@implementation ZCLinLiveAnchorView

+ (instancetype)linLiveAnchorView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

//从xib加载进来后就会调用这个方法
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    //设置圆角效果
    [self maskToBunds:self.informationView];
    [self maskToBunds:self.headImageView];
    [self maskToBunds:self.closeButton];
    [self maskToBunds:self.gifButtom];
    
    //设置自己的背景颜色
    self.backgroundColor = [UIColor clearColor];
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.informationView.backgroundColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:0.5];
    
    [self.gifButtom setBackgroundColor:[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:0.5]];
    
    [self.closeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] size:self.closeButton.frame.size] forState:UIControlStateNormal];
    
    [self.closeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:216/255.0 green:41/255.0 blue:116/255.0 alpha:1.0] size:self.closeButton.frame.size] forState:UIControlStateSelected];
    
    
    
}

//设置圆角方法
- (void)maskToBunds:(UIView *)view {
    
    view.layer.cornerRadius = view.frame.size.height * 0.5;
    view.layer.masksToBounds = YES;
}
- (IBAction)closeButtonClik {
    
    self.closeButton.selected = !self.closeButton.selected;
}

- (void)configWithImageString:(NSString *)urlString name:(NSString *)name peopleNumber:(NSUInteger)peopleNumber {
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlString]placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.nameLabel.text = name;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",peopleNumber];
    self.number = peopleNumber;
    
    //设置定时器更新人数
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatdaNum) userInfo:nil repeats:YES];
    
}
static int randomNum = 0;
- (void)updatdaNum {
    
    randomNum += arc4random_uniform(5);
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人", self.number + randomNum];
    
    [self.gifButtom setTitle:[NSString stringWithFormat:@"猫粮:%u  娃娃%u", 1993045 + randomNum,  124593+randomNum] forState:UIControlStateNormal];
}
@end
