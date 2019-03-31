//
//  ViewController.m
//  ScrollPage
//
//  Created by mc on 2019/1/27.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "ViewController.h"
#import "BasePageViewController.h"
#import "SubTableViewController.h"
#import "HeaderView.h"
#import "SDCycleScrollView.h"
#import "SubCollectionViewController.h"
#import <JXCategoryView/JXCategoryView.h>


@interface ViewController ()<PageViewControllerDelegate,JXCategoryViewDelegate>
{
	UIView *_pageView;
	BasePageViewController *_pageVc;
	UIVisualEffectView *_topNavView;
	JXCategoryTitleView *segmentedControl;
}
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

}
- (void)viewDidLoad {
	[super viewDidLoad];
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
	self.navigationItem.leftBarButtonItem = backItem;
	// =======================================
	HeaderView *headerView = [HeaderView new];
	UIView *pageView = [UIView new];
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	pageView.frame = CGRectMake(0, 300 - 40.0f, screenWidth, 40.0f);
	pageView.backgroundColor = [UIColor whiteColor];
	[headerView addSubview:pageView];
	_pageView = pageView;
	headerView.frame = CGRectMake(0, 0, screenWidth, 300);
	BasePageViewController *pageVc = [[BasePageViewController alloc]initWithHeaderView:headerView andDelegate:self];
	_pageVc = pageVc;

	pageVc.isShowTop = NO;   //设置是否显示每个tableView 的最顶部部分

	CGFloat topHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44.0f;
	pageVc.overlayerHeight = topHeight + 40.0f; //设置悬停高度

	[self addChildViewController:pageVc];

	pageVc.view.frame = [UIScreen mainScreen].bounds;

	[self.view addSubview:pageVc.view];
	// =======================================

	SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300 - 40.0f) imageURLStringsGroup:@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548669791927&di=e3c3c33b4df7b8af4cc717d61bf68c62&imgtype=0&src=http%3A%2F%2Fseopic.699pic.com%2Fphoto%2F50080%2F5511.jpg_wh1200.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548669791927&di=2fb9b372bd252a2570338855f67f193e&imgtype=0&src=http%3A%2F%2Fpic16.nipic.com%2F20110421%2F468957_140932500145_2.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548669791926&di=f5435bb841f8f815901efe795320a924&imgtype=0&src=http%3A%2F%2Fimg05.tooopen.com%2Fimages%2F20141121%2Fsy_75465683182.jpg"]];

	[headerView addSubview:scrollView];
//@[@"倚天屠龙记",@"神雕侠侣",@"射雕英雄传",@"雪山飞狐"]
//	FSSegmentTitleView *segmentBar = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(scrollView.frame), CGRectGetWidth(self.view.bounds),40) titles:@[@"倚天屠龙记",@"神雕侠侣",@"射雕英雄传",@"雪山飞狐",@"倚天屠龙记",@"神雕侠侣",@"射雕英雄传",@"雪山飞狐"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];

//	JXCategoryDotView *mlSegementHead = [[MLMSegmentHead alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(scrollView.frame), CGRectGetWidth(self.view.bounds),40) titles:@[@"倚天屠龙记",@"神雕侠侣",@"射雕英雄传射雕英雄传射雕英雄传",@"雪山飞狐",@"倚天屠龙记",@"神雕侠侣",@"射雕英雄传",@"雪山飞狐"] headStyle:SegmentHeadStyleLine];
	JXCategoryTitleView *segement = [[JXCategoryTitleView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(scrollView.frame), CGRectGetWidth(self.view.bounds),40)];
	segement.titles = @[@"倚天屠龙记",@"神雕侠侣",@"射雕英雄传射雕英雄传射雕英雄传",@"雪山飞狐",@"倚天屠龙记",@"神雕侠侣",@"射雕英雄传",@"雪山飞狐"];
	segement.cellSpacing = 10;
	segement.titleFont = [UIFont systemFontOfSize:16];
	segement.separatorLineColor = [UIColor redColor];
	segement.titleColor = [UIColor grayColor];
	segement.titleSelectedColor = [UIColor redColor];
	segement.contentScrollView = [pageVc containtScrollView];
	JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
	lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
	segement.indicators = @[lineView];
	segement.delegate = self;
	segmentedControl = segement;
	[headerView addSubview:segmentedControl];
	UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
	UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
	_topNavView = effectView;
	_topNavView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), topHeight);
	_topNavView.backgroundColor  = [[UIColor redColor]colorWithAlphaComponent:0];

	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	CGFloat topY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
	backBtn.frame = CGRectMake(10.0f, topY, 40, 40);
	[backBtn setImage:[UIImage imageNamed:@"activity_back_icon"] forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_topNavView];
	[self.view addSubview:backBtn];

	UILabel *titleLable = [UILabel new];

	titleLable.textColor = [UIColor blackColor];
	titleLable.text = @"时光不休，武侠不散";
	[self.view addSubview:titleLable];
	titleLable.frame = CGRectMake(0, topY, CGRectGetWidth(self.view.frame), 40.0f);
	titleLable.textAlignment = NSTextAlignmentCenter;
	self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)backAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numerOfPageWithPageViewController:(BasePageViewController *)pageVc
{
	return 8;
}
-(UIViewController *)loadSubVcWithPage:(NSInteger)page
{
	if (page %2 == 1) {
		SubCollectionViewController *vc = [[SubCollectionViewController alloc]init];
		return vc;
	}
	SubTableViewController *vc = [[SubTableViewController alloc]init];
	return vc;
}
//滚动到第几页了
-(void)scrollToPage:(NSInteger)page
{

}
//横向偏移到什么位置了
-(void)pageScrollCurrentOffset:(CGPoint)offSet
{

}
//用来监听纵向滚动视图滚动到什么位置
-(void)subScrollViewDidScrollOffSet:(CGPoint)offSet
{
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
	[_pageVc pageScrollToPage:index];
}

-(void)dealloc
{
	NSLog(@"viewController释放");
	segmentedControl.contentScrollView = nil;
}


@end
