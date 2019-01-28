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

	_myTableView.tableHeaderView = headerV;

	UIImageView *gifImgV = [UIImageView new];
	gifImgV.image = [UIImage imageNamed:@"refresh_0"];
	gifImgV.frame = CGRectMake(0, 245, 25, 25);
	gifImgV.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2.0f, gifImgV.center.y);
	[headerV addSubview:gifImgV];
	NSMutableArray *animations =[NSMutableArray array];
	for (int i = 0; i<= 40; i++) {
		UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%d",i]];
		[animations addObject:img];
	}
	gifImgV.animationImages = animations;
	gifImgV.animationDuration = animations.count * 0.02;
	gifImgV.animationRepeatCount = 0;
	_stateLable = [UILabel new];
	_stateLable.textAlignment = NSTextAlignmentCenter;
	_stateLable.text = @"下拉刷新";
	_stateLable.font = [UIFont systemFontOfSize:13.0f];
	_stateLable.frame = CGRectMake(0, CGRectGetMaxY(gifImgV.frame) + 5, CGRectGetWidth(self.view.bounds), 15.0f);

	[headerV addSubview:_stateLable];

	_giftImgView = gifImgV;

	[_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	_myTableView.delegate = self;
	_myTableView.dataSource = self;
	_myTableView.frame = self.view.bounds;
	if (@available(iOS 11.0,*)) {
		_myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	MJRefreshHeader *header  = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(regreshAction)];
	_myTableView.mj_header = header;
	[header addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
	
	[header beginRefreshing];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if (self.myTableView.mj_header.state == MJRefreshStateRefreshing) {
		[_giftImgView startAnimating];
		_stateLable.text = @"正在刷新";
	}else{
		if (self.myTableView.mj_header.state == MJRefreshStateIdle) {
			_stateLable.text = @"下拉刷新";
		}else if (self.myTableView.mj_header.state == MJRefreshStatePulling){
			_stateLable.text = @"松手刷新";
		}
		[_giftImgView stopAnimating];
	}
}
-(void)regreshAction
{
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

-(void)dealloc
{
	[self.myTableView.mj_header removeObserver:self forKeyPath:@"state"];
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
