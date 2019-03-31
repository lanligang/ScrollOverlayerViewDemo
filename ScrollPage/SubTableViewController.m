//
//  SubTableViewController.m
//  ScrollPage
//
//  Created by mc on 2019/1/27.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "SubTableViewController.h"
#import "CircleFooter.h"
#import <MJRefresh.h>
@interface SubTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
	UIImageView *_giftImgView;
	UILabel *_stateLable;

}
@property(nonatomic,assign)NSInteger cellCount;
@property (nonatomic,strong)UITableView *myTableView;

@end

@implementation SubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_cellCount = 1;
	[self.view addSubview:self.myTableView];
	UIView *headerV = [UIView new];
	headerV.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300);
	self.scrollHeaderView = headerV;
	self.containtScrollView = self.myTableView;

	[_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	_myTableView.delegate = self;
	_myTableView.dataSource = self;
	_myTableView.frame = self.view.bounds;
	if (@available(iOS 11.0,*)) {
		_myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	[self begainRefresh];

	MJRefreshFooter *footer = [CircleFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadMore)];
	_myTableView.mj_footer = footer;
}

-(void)upLoadMore
{
	__weak typeof(self)ws = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		ws.cellCount += 10;
		[ws.myTableView.mj_footer endRefreshing];
		[ws.myTableView reloadData];
	});
}

-(void)pulldownRefresh
{
	[super pulldownRefresh];
	__weak typeof(self)ws = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[ws.myTableView.mj_header endRefreshing];
		ws.cellCount = 1;
		[ws.myTableView reloadData];
	});
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.cellCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.selectionStyle =  UITableViewCellSelectionStyleNone;
	cell.backgroundColor = [UIColor whiteColor];
	UILabel * v = [cell.contentView viewWithTag:100];
	UILabel *lable = (v!= nil)?v:[UILabel new];
	lable.tag = 100;
	lable.numberOfLines = 0;
	lable.font = [UIFont systemFontOfSize:15];
	NSString *str = @"薏苡种仁是中国传统的食品资源之一，可做成粥、饭、各种面食供人们食用。尤其对老弱病者更为适宜。味甘、淡，性微寒。其中以蕲春四流山村为原产地的最为出名，有健脾利湿、清热排脓、美容养颜功能。";

	CGFloat maxW = [UIScreen mainScreen].bounds.size.width - 50;
	lable.frame = CGRectMake(25, 0, maxW, 100);
	[cell.contentView addSubview:lable];
	lable.text = str;
	return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	Class aclass = objc_getClass([@"HeaderViewController" UTF8String]);
	id vc = [[aclass alloc]init];
	if (vc&&[vc isKindOfClass:[UIViewController class]]) {

		UIViewController *viewController = (UIViewController *)vc;

		[self.navigationController pushViewController:viewController animated:YES];
	}

}

#pragma mark viewWillLayoutSubviews
-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	_myTableView.frame = self.view.bounds;
}
-(UITableView *)myTableView
{
	if (!_myTableView)
	{
		_myTableView = [[UITableView alloc]init];
	}
	return _myTableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
