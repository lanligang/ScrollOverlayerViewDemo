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

@interface ViewController ()<PageViewControllerDelegate>
{
	UIView *_pageView;
	UIView *_lineView;
	BasePageViewController *_pageVc;
	UIView *_topNavView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	HeaderView *headerView = [HeaderView new];
	UIView *pageView = [UIView new];
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	pageView.frame = CGRectMake(0, 200 - 40.0f, screenWidth, 40.0f);
	pageView.backgroundColor = [UIColor whiteColor];
	[headerView addSubview:pageView];
	_pageView = pageView;
	headerView.frame = CGRectMake(0, 0, screenWidth, 200);
	BasePageViewController *pageVc = [[BasePageViewController alloc]initWithHeaderView:headerView andDelegate:self];
	_pageVc = pageVc;

	pageVc.isShowTop = NO;   //设置是否显示每个tableView 的最顶部部分

	CGFloat topHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44.0f;
	pageVc.overlayerHeight = topHeight + 40.0f; //设置悬停高度

	[self addChildViewController:pageVc];

	pageVc.view.frame = self.view.bounds;

	[self.view addSubview:pageVc.view];

	SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 160.0f) imageURLStringsGroup:@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548649186366&di=db14eeade6ddc6453e7faa0fff4f28a0&imgtype=0&src=http%3A%2F%2Fpic2.16pic.com%2F00%2F05%2F01%2F16pic_501154_b.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548649186366&di=960e621b49a76f30e2f2d20fdd68209c&imgtype=0&src=http%3A%2F%2Fpic5.photophoto.cn%2F20071217%2F0008020241208713_b.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548649186364&di=3abc37c3a44aba40224ad03584c7e56a&imgtype=0&src=http%3A%2F%2Fpic9.photophoto.cn%2F20081229%2F0034034885643767_b.jpg"]];
	[headerView addSubview:scrollView];
	NSString *titles[] = {@"倚天屠龙记",@"神雕侠侣",@"射雕英雄传",@"雪山飞狐"};
	CGFloat width = CGRectGetWidth(self.view.frame)/4.0f;
	for (int i = 0; i< 4; i++) {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.tag = 10+ i;
		[_pageView addSubview:btn];
		[btn setTitle:titles[i] forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
		[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		btn.frame = CGRectMake(i*width, 0, width, 40.0f);
		[btn addTarget:self action:@selector(clickedAction:) forControlEvents:UIControlEventTouchUpInside];
		if (i == 0) {
			btn.selected = YES;
			UIView *lineV = [UIView new];
			[_pageView addSubview:lineV];
			_lineView = lineV;
			_lineView.backgroundColor = [UIColor redColor];
			_lineView.bounds = CGRectMake(0, 0, 50, 2);
			_lineView.layer.cornerRadius = 1;
			_lineView.layer.masksToBounds = YES;
			_lineView.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame) - 2);
		}
	}

	UIView *bottomLineV = [UIView new];
	bottomLineV.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5f];
	bottomLineV.frame = CGRectMake(0, 39.0f, CGRectGetWidth(self.view.frame), 1);
	[_pageView addSubview:bottomLineV];


	_topNavView = [UIView new];
	_topNavView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), topHeight);
	_topNavView.backgroundColor  = [[UIColor redColor]colorWithAlphaComponent:0];
	[self.view addSubview:_topNavView];

}
-(NSInteger)numerOfPageWithPageViewController:(BasePageViewController *)pageVc
{
	return 4;
}
-(UIViewController *)loadSubVcWithPage:(NSInteger)page
{
	SubTableViewController *vc = [[SubTableViewController alloc]init];
	return vc;
}

-(void)pageScrollCurrentOffset:(CGPoint)offSet
{
	NSInteger page = (offSet.x + CGRectGetWidth(self.view.bounds)/2.0f)/CGRectGetWidth(self.view.bounds);
	for (int i = 0; i< 4; i++) {
		UIButton *btn = [_pageView viewWithTag:(10 + 	i )];
		if (page == i) {
			btn.selected = YES;
		}else{
			btn.selected = NO;
		}
	}
	[_pageView bringSubviewToFront:_lineView];
	CGFloat width = CGRectGetWidth(self.view.frame)/8.0f;
	_lineView.center = (CGPoint){width + offSet.x/4.0f,_lineView.center.y};
}
//用来监听纵向滚动视图滚动到什么位置
-(void)subScrollViewDidScrollOffSet:(CGPoint)offSet
{
	CGFloat alpa = offSet.y/140.0f;
	alpa = MAX(0, alpa);
	_topNavView.backgroundColor  = [[UIColor redColor]colorWithAlphaComponent:alpa];
}

-(void)clickedAction:(UIButton *)btn
{
	NSInteger page = btn.tag - 10;
	[_pageVc pageScrollToPage:page];
}

@end
