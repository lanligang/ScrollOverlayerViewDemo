//
//  SubTableViewController.m
//  ScrollPage
//
//  Created by mc on 2019/1/27.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "SubTableViewController.h"

#import <MJRefresh.h>
@interface SubTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
	UIImageView *_giftImgView;
	UILabel *_stateLable;
}
@property (nonatomic,strong)UITableView *myTableView;

@end

@implementation SubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

-(void)pulldownRefresh
{
	[super pulldownRefresh];
	__weak typeof(self)ws = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[ws.myTableView.mj_header endRefreshing];
	});
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.selectionStyle =  UITableViewCellSelectionStyleNone;
	cell.backgroundColor = [UIColor whiteColor];
	cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row + 1];
	return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0f;
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
