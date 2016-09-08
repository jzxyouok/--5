//
//  ZCLinLiveEndView.m
//  随手记
//
//  Created by MrZhao on 16/8/24.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCLinLiveEndView.h"
@interface ZCLinLiveEndView ()
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *careButton;
@property (weak, nonatomic) IBOutlet UIButton *lookOtherButton;

@end
@implementation ZCLinLiveEndView
+ (instancetype)linLiveEndView {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    
}

- (void)awakeFromNib {
    //设置一些圆角效果
    [super awakeFromNib];
    [self maskRadius:self.exitButton];
    [self maskRadius:self.careButton];
    [self maskRadius:self.lookOtherButton];
}
- (IBAction)lookOtherButtonClik:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(lookOtherButtonClik:)]) {
        [self.delegate lookOtherButtonClik:self];
    }
    
}
- (IBAction)careButtonClik:(id)sender {
    
    [sender setTitle:@"关注成功" forState:UIControlStateNormal];
}


//设置圆角效果
- (void)maskRadius:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.frame.size.height * 0.5;
    btn.layer.masksToBounds = YES;
    if (btn != self.careButton) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithRed:216/255.0 green:41/255.0 blue:116/255.0 alpha:1.0].CGColor;
    }
}
- (IBAction)exitButtonClik:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(exitButtonClik:)]) {
        [self.delegate exitButtonClik:self];
    }
    
}

@end
