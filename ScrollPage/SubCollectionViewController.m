//
//  SubCollectionViewController.m
//  ScrollPage
//
//  Created by ios2 on 2019/1/29.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "SubCollectionViewController.h"
#import <MJRefresh.h>
#import "CircleFooter.h"

@interface SubCollectionViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,assign)NSInteger itemCount;
@property (nonatomic,strong)UICollectionView *collectionView;
@end

@implementation SubCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_itemCount = 0;
	UIView *headerV = [UIView new];
	headerV.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300);
	self.scrollHeaderView = headerV;
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
	flowLayout.itemSize = CGSizeMake(80, 90);
	flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
	UICollectionView *collectionView =[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
	collectionView.backgroundColor = [UIColor whiteColor];
	[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
	collectionView.delegate = self;
	collectionView.dataSource = self;
	self.containtScrollView = collectionView;
	_collectionView = collectionView;
	[self.view addSubview:collectionView];
	if (@available(iOS 11.0,*)) {
		collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	[self begainRefresh];
	collectionView.mj_footer = [CircleFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadMoreAction)];
}
-(void)upLoadMoreAction
{
	__weak typeof(self)ws = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[ws.containtScrollView.mj_footer endRefreshing];
		ws.itemCount += 5;
		[ws.collectionView reloadData];
	});
}
-(void)pulldownRefresh
{
	[super pulldownRefresh];
	__weak typeof(self)ws = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[ws.containtScrollView.mj_header endRefreshing];
		ws.itemCount = 1;
		[ws.collectionView reloadData];
	});
}
-(void)viewWillLayoutSubviews
{
	self.containtScrollView.frame = self.view.bounds;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return  self.itemCount;
}

	// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	cell.backgroundColor = [self randomColor];
	return cell;
}
#pragma mark 随机色 测试使用
-(UIColor *)randomColor
{
    int r =	5 + arc4random() %250;
	int g = 5 + arc4random() %250;
	int b = 5 + arc4random() %250;
	return  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];
}


@end
