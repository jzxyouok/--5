//
//  ZCZhiBoViewController.m
//  随手记
//
//  Created by MrZhao on 16/8/21.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCZhiBoViewController.h"
#import "ZCZhiboCollectionViewCell.h"
#import "ZCConst.h"
#import "MJExtension.h"
#import "ZCNetWorkingTool.h"
#import "ZCLiveUser.h"
#import "AFNetworking.h"
@interface ZCZhiBoViewController ()
@property (nonatomic, strong)NSMutableArray *dataSource;
@end
static NSString *CELL = @"CELL";
static NSUInteger page = 1;
@implementation ZCZhiBoViewController
- (instancetype)init {
    
    //设置流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenW -3)/3.0, (ScreenW -3)/3.0);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;

    return [self initWithCollectionViewLayout:layout];
    
}
#pragma life style
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//在该方法中做相关配置
- (void)viewWillAppear:(BOOL)animated {
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册cell
    [self.collectionView registerClass:[ZCZhiboCollectionViewCell class] forCellWithReuseIdentifier:CELL];
    
    //发送网络请求获取数据
    
    [self getNewData];
    
}
//在这里设置子控件的布局
- (void)viewDidLayoutSubviews {
    
}
#pragma mark collectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCZhiboCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL forIndexPath:indexPath];
    if (self.dataSource.count>0) {
        
        ZCLiveUser *user = self.dataSource[indexPath.row];
        [cell configCellWithImageURL:user.photo loaction:user.position isNewStar:user.newStar nikeName:user.nickname];
        
    }
    return cell;
}
#pragma 网络请求方法
- (void)getNewData {
    
    NSString *url = [NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=%ld",(unsigned long)page];
    
    ZCNetWorkingTool *tool = [ZCNetWorkingTool shareNetWorking];
    
    [tool GETWithURL:url parameters:nil sucess:^(id reponseBody) {
        NSArray *array = reponseBody[@"data"][@"list"];
        //将字典数组转成模型数组
        NSArray *arrayM =[ZCLiveUser objectArrayWithKeyValuesArray:array];
        if (arrayM.count>0) {
            [self.dataSource addObjectsFromArray:arrayM];
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"数据加载失败");
        
    }];
    
}
#pragma 懒加载相关
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
