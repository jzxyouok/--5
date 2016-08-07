//
//  ZCPicturesShowCollectionViewController.m
//  随手记
//
//  Created by MrZhao on 16/7/22.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCPicturesShowCollectionViewController.h"
#import "ZCImageCollectionViewCell.h"
#import "ZCConst.h"
#import "ZCImageDataBL.h"
#import "ZCImageM.h"
#import "UIBarButtonItem+Extention.h"
#import "ZCViewControllerDispatchMediation.h"
#import "ZCRefresh.h"
#define ZCContentOffset  @"contentOffset"

@interface ZCPicturesShowCollectionViewController ()
/*
 *collectView的数据源，从业务层拿到数据直接展示
 */
@property (nonatomic,strong)NSMutableArray *imagesDatasource;
/*
 *底部View
 */
@property (nonatomic, strong)UIView *bottomView;

@end

static int page = 1;
//记录数据库数据是否取完毕
static BOOL haveData = TRUE;
static NSString * const reuseIdentifier = @"Cell";

@implementation ZCPicturesShowCollectionViewController

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 5;
    CGFloat width = 0;
    if (ScreenW == 320.000000) {
        width = (ScreenW - 3 * margin) / 2;
    }else {
        
        width = (ScreenW - 4 * margin) / 3;
    }
    flowLayout.itemSize = CGSizeMake(width, (width * 4/3)+ 25);
    flowLayout.minimumInteritemSpacing = 5;
    return [self initWithCollectionViewLayout:flowLayout];
}

#pragma mark life cycle
/*在该方法中通常做添加子视图操作，子视图的创建不要在这里面做*/
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //添加一个底部view;
    [self.view addSubview:self.bottomView];

    page = 1;
    
}

/*在该方法中通常配置操作 ，子视图的frame设置不要在这里面做*/
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.bottomView.hidden = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    [self.collectionView registerClass:[ZCImageCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //加载数据,直接从业务层取数据，这个数据是业务层处理好的，是可以直接拿来使用的，这样控制器就不需要做过多的业务处理，代码更简洁
    self.imagesDatasource = (NSMutableArray *)[ZCImageDataBL readImageDataWithPage:page];
    
    //初始化模型为未选中状态
    for (ZCImageM *imagM in self.imagesDatasource) {
        imagM.isSelected = NO;
        imagM.isEditing = NO;
    }
    
    //配置导航
    [self setUpNav];
    
    //在这里添加观察者就一定要在ViewDidDissAppear中移除，注意不要在delloc中移除
    [self.collectionView addObserver:self forKeyPath:ZCContentOffset options:NSKeyValueObservingOptionNew context:nil];
    
    
}

/*在该方法中设置子视图的frame比较准确*/
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.bottomView.frame = CGRectMake(0, ScreenH - 60, ScreenW, 60);
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //注意如果在viewWillApper添加的观察者一定要在这个方法中移除，在delloec移除的话，有时候必须等控制器销毁才调用，此时如果又调用了viewWillApper，观察者将会被添加两次，程序会有意外情况。
    [self.collectionView removeObserver:self forKeyPath:ZCContentOffset];
}

- (void)setUpNav {
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem initWithAction:@selector(back) viewcontroller:self imageNamed:@"back_hight" hightedImageNamed:@"back_hight"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"选择" action:@selector(selectButtonClik) viewcontroller:self textFont:[UIFont systemFontOfSize:17] textNormolColor:[UIColor whiteColor] textDisenbleColor:nil];
    
    
    //设置导航栏为粉色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:231/255.0 green:143/255.0 blue:186/255.0 alpha:1.0];
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.imagesDatasource.count != 0) {
        
        ZCImageM *imageM = self.imagesDatasource[indexPath.row];
        cell.imageM = imageM;
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCViewControllerDispatchMediation *mediaVc = [[ZCViewControllerDispatchMediation alloc] init];
    
    if (self.imagesDatasource.count>0) {
        
        ZCImageM *imageM = self.imagesDatasource[indexPath.row];
        [mediaVc dispatchViewControllerWithVc:self type:KImageShowVc paramers:imageM];
    }
}

#pragma mark 观察者调用相关方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:  (NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:ZCContentOffset]) {
        [self adjustRefreshView];
    }
}
- (void)adjustRefreshView {
    
    int _lastPosition = 0;
    
    int currentPostion = self.collectionView.contentOffset.y;
    if (currentPostion - _lastPosition > 10) {//上拉
        _lastPosition = currentPostion;
        if((currentPostion + self.collectionView.frame.size.height >= self.collectionView.contentSize.height) )//上拉到最后一个cell后且上拉控件没有完全显示出来
        {
            [self loadMoreDataSource];
            
        }
    }
    else if (_lastPosition - currentPostion > 25)//下拉
    {
        _lastPosition = currentPostion;
        //NSLog(@"ScrollDown now");
    }
}

#pragma 上拉加载更多
- (void)loadMoreDataSource {
    
    if (haveData) {
        page++;
        
        NSArray *dataSoure = [ZCImageDataBL readImageDataWithPage:page];
        
        if(dataSoure.count>0)
        {
            for (ZCImageM *imageM in dataSoure) {
                imageM.isSelected = NO;
                imageM.isEditing = NO;
            }
            
            haveData = TRUE;
            [self.imagesDatasource addObjectsFromArray:dataSoure];
            [self.collectionView reloadData];
            
        }else {
            haveData = FALSE;
        }
    }
}

#pragma mark 导航栏相关按钮点击调用的方法
- (void)selectButtonClik {
    
    //让底部view可见
    [UIView animateWithDuration:1.0 animations:^{
        self.bottomView.hidden = NO;
    }];
    
    //让所有图片进入编辑状态
    for (ZCImageM *imageM in self.imagesDatasource) {
        
        imageM.isEditing = YES;
    }
    
    //让左边按钮变成取消
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithTitle:@"取消" action:@selector(cancel) viewcontroller:self textFont:[UIFont systemFontOfSize:17] textNormolColor:[UIColor whiteColor] textDisenbleColor:nil];
    
    [self.collectionView reloadData];
    
}

- (void)cancel {
    
    //让底部view不可见
    [UIView animateWithDuration:1.0 animations:^{
         self.bottomView.hidden = YES;
    }];
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem initWithAction:@selector(back) viewcontroller:self imageNamed:@"back_hight" hightedImageNamed:@"back_hight"];
    
    //让所有图片变成不可编辑状态
    for (ZCImageM *imageM in self.imagesDatasource) {
        imageM.isEditing = NO;
        imageM.isSelected = NO;
    }
    
    [self.collectionView reloadData];
    
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark删除按钮点击
- (void)deletButtonClik {
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    //删除数据源中选中的数据，开子线程操作，这样不会卡主主线程
    for (ZCImageM *imageM in self.imagesDatasource) {
        if (imageM.isSelected) {
            
            //直接把名字丢过去即可，这样更快
         @autoreleasepool {
                NSString *str = imageM.imagName;
             [arrayM addObject:str];
             
            }
            
        }
    }
    
    //从数据库中删除选中的数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ZCImageDataBL deletImageDataWithArray:(NSArray *)arrayM];
    });
    
    //刷新UI
    NSMutableArray *imageArrayM = [NSMutableArray array];
    for (ZCImageM *imageM in self.imagesDatasource) {
        if (!imageM.isSelected) {
            [imageArrayM addObject:imageM];
        }
    }
    
    self.imagesDatasource = imageArrayM;
    [self.collectionView reloadData];
    
}

#pragma mark 子控件懒加载方法，懒加载方法往后，这样不影响主逻辑
- (NSMutableArray *)imagesDatasource {
    if (_imagesDatasource == nil) {
        
        self.imagesDatasource = [[NSMutableArray alloc] init];
    }
    return _imagesDatasource;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = [UIColor colorWithRed:76/255.0 green:86/255.0 blue:121/255.0 alpha:1.0];
        CGFloat buttonWH = 50;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW -buttonWH)/2 , 5, buttonWH, buttonWH)];
        [button setImage:[UIImage imageNamed:@"wm_icon_deleteaddress_normal"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deletButtonClik) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:button];
    }
    return _bottomView;
}
@end

