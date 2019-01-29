//
//  BaseSubViewController.m
//  ScrollPage
//
//  Created by ios2 on 2019/1/29.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "BaseSubViewController.h"
#import <MJRefresh.h>

@interface BaseSubViewController ()

@property (nonatomic,strong)UILabel *stateLable;

@property (nonatomic,strong)UIImageView *gifImgView;

@end

@implementation BaseSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setScrollHeaderView:(UIView *)scrollHeaderView
{
	_scrollHeaderView = scrollHeaderView;
	[_scrollHeaderView addSubview:self.gifImgView];
	[_scrollHeaderView addSubview:self.stateLable];
	self.gifImgView.image = [UIImage imageNamed:@"refresh_0"];
	self.gifImgView.frame = CGRectMake(0, CGRectGetHeight(_scrollHeaderView.frame) - 55, 25, 25);
	self.gifImgView.center = CGPointMake(CGRectGetWidth(_scrollHeaderView.bounds)/2.0f, self.gifImgView.center.y);
	NSMutableArray *animations =[NSMutableArray array];
	for (int i = 0; i<= 40; i++) {
		UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%d",i]];
		[animations addObject:img];
	}
	self.gifImgView.animationImages = animations;
	self.gifImgView.animationDuration = animations.count * 0.02;
	self.gifImgView.animationRepeatCount = 0;
	_stateLable.textAlignment = NSTextAlignmentCenter;
	_stateLable.text = @"下拉刷新";
	_stateLable.font = [UIFont systemFontOfSize:13.0f];
	_stateLable.frame = CGRectMake(0, CGRectGetMaxY(self.gifImgView.frame) + 5, CGRectGetWidth(self.view.bounds), 15.0f);

	if (_containtScrollView) {
		if ([_containtScrollView isKindOfClass:[UITableView class]]) {
			UITableView *tableView = (UITableView *)_containtScrollView;
			tableView.tableHeaderView = _scrollHeaderView;
		}else if ([_containtScrollView isKindOfClass:[UICollectionView class]]){
			UICollectionView *colllectionView = (UICollectionView *)_containtScrollView;
			UICollectionViewLayout *layout =colllectionView.collectionViewLayout;
			if ([layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
				UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
				flowLayout.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(scrollHeaderView.frame) + flowLayout.sectionInset.top, flowLayout.sectionInset.left,  flowLayout.sectionInset.bottom,  flowLayout.sectionInset.right);
				[colllectionView addSubview:_scrollHeaderView];
			}
		}
	}
}
-(void)setContaintScrollView:(UIScrollView *)containtScrollView
{
	_containtScrollView = containtScrollView;

	if (_scrollHeaderView) {
		if ([_containtScrollView isKindOfClass:[UITableView class]]) {
			UITableView *tableView = (UITableView *)_containtScrollView;
			tableView.tableHeaderView = _scrollHeaderView;
		}else if ([_containtScrollView isKindOfClass:[UICollectionView class]]){
			UICollectionView *colllectionView = (UICollectionView *)_containtScrollView;
			UICollectionViewLayout *layout =colllectionView.collectionViewLayout;
			if ([layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
				UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
				flowLayout.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(_scrollHeaderView.frame) + flowLayout.sectionInset.top, flowLayout.sectionInset.left,  flowLayout.sectionInset.bottom,  flowLayout.sectionInset.right);
				[colllectionView addSubview:_scrollHeaderView];
			}
		}
	}

	if (_containtScrollView.mj_header ==nil) {
		_containtScrollView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefresh)];
		[_containtScrollView.mj_header addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
	}
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	//使用kvo 监听
	if ([object isKindOfClass:[MJRefreshHeader class]]&&[keyPath isEqualToString:@"state"]) {
		if (self.containtScrollView.mj_header.state == MJRefreshStateRefreshing) {
			[self.gifImgView startAnimating];
			_stateLable.text = @"正在刷新";
		}else{
			if (self.containtScrollView.mj_header.state == MJRefreshStateIdle) {
				_stateLable.text = @"下拉刷新";
			}else if (self.containtScrollView.mj_header.state == MJRefreshStatePulling){
				_stateLable.text = @"松手刷新";
			}
			[self.gifImgView stopAnimating];
		}
	}
}
//需要在子类中实现的方法
-(void)pulldownRefresh {}

-(void)begainRefresh
{
	[self.containtScrollView.mj_header beginRefreshing];
}

-(void)dealloc
{
	if (_containtScrollView) {
		[_containtScrollView.mj_header removeObserver:self forKeyPath:@"state"];
	}
}

-(UILabel *)stateLable
{
	if (!_stateLable)
	 {
		_stateLable = [[UILabel alloc]init];
		_stateLable.textColor = [UIColor lightGrayColor];
	 }
	return _stateLable;
}
-(UIImageView *)gifImgView
{
	if (!_gifImgView)
	 {
		_gifImgView = [[UIImageView alloc]init];
	 }
	return _gifImgView;
}

@end
