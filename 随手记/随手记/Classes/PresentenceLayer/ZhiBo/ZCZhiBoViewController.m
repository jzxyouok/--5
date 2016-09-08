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
#import "UIBarButtonItem+Extention.h"
#import "MJRefresh.h"
#import "MJRefreshGifHeader.h"
#import "ZCLinLive.h"
#import "ZCViewControllerDispatchMediation.h"
#import "ZCRefresh.h"

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
    
    [super viewWillAppear:animated];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 去掉滚动条
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    
    //设置导航栏
    [self setUpNav];
    
    //注册cell
    [self.collectionView registerClass:[ZCZhiboCollectionViewCell class] forCellWithReuseIdentifier:CELL];
    
    //设置刷新控件
    [self  setUpRefresh];
    
    //发送网络请求获取数据
    
    [self loadData];
    
}
//在这里设置子控件的布局
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
}
#pragma mark 导航栏相关设置
- (void)setUpNav {
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem initWithAction:@selector(back) viewcontroller:self imageNamed:@"back_hight" hightedImageNamed:@"back_hight"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithAction:@selector(rankingList) viewcontroller:self imageNamed:@"head_crown_24x24" hightedImageNamed:@"head_crown_24x24"];
    
    //设置导航栏为粉色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:231/255.0 green:143/255.0 blue:186/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"直播间";
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
}
- (void)rankingList {
    
}
- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma 刷新控件设置
- (void)setUpRefresh {
    
     //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //添加动画图片
    NSMutableArray *arrayImages = [NSMutableArray array];
    UIImage *image1 = [UIImage imageNamed:@"reflesh1_60x55"];
    [arrayImages addObject:image1];
    
    UIImage *image2 = [UIImage imageNamed:@"reflesh2_60x55"];
    [arrayImages addObject:image2];
    
    UIImage *image3 = [UIImage imageNamed:@"reflesh3_60x55"];
    [arrayImages addObject:image3];
    
    // 设置普通状态的动画图片
    [header setImages:arrayImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:arrayImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:arrayImages forState:MJRefreshStateRefreshing];
    
    // 设置header
    self.collectionView.mj_header = header;
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
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
#pragma mark collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count>0) {
        
        ZCLiveUser *user = self.dataSource[indexPath.item];
        ZCLinLive *live = [[ZCLinLive alloc] init];
        live.bigpic = user.photo;
        live.myname = user.nickname;
        live.smallpic = user.photo;
        live.gps = user.position;
        live.useridx = user.useridx;
        live.allnum = arc4random_uniform(2000);
        live.flv = user.flv;
        
        ZCViewControllerDispatchMediation *dispatchMediaVc = [ZCViewControllerDispatchMediation shareViewControllerDispatchMediation];
        
        [dispatchMediaVc dispatchViewControllerWithVc:self type:kLinLiveVc paramers:live];
    }
    
}
#pragma 网络请求方法
- (void)loadMoreData{
    
    page++;
    [self loadData];
}
- (void)loadNewData {
    
    page = 1;
    [self.dataSource removeAllObjects];
    [self loadData];
}
- (void)loadData {
    
    NSString *url = [NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=%ld",(unsigned long)page];
    
    ZCNetWorkingTool *tool = [ZCNetWorkingTool shareNetWorking];
    
    [tool GETWithURL:url parameters:nil sucess:^(id reponseBody) {
        NSArray *array = reponseBody[@"data"][@"list"];
        //将字典数组转成模型数组
        NSArray *arrayM =[ZCLiveUser objectArrayWithKeyValuesArray:array];
        if (arrayM.count>0) {
            
            [self.dataSource addObjectsFromArray:arrayM];
            [self.collectionView reloadData];
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
           
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
