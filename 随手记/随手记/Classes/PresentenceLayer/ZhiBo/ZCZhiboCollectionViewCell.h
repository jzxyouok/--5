//
//  ZCZhiboCollectionViewCell.h
//  随手记
//
//  Created by MrZhao on 16/8/22.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCZhiboCollectionViewCell : UICollectionViewCell

- (void)configCellWithImageURL:(NSString *)url loaction:(NSString *)location isNewStar:(BOOL)isNewStar nikeName:(NSString *)nikeName;

@end
