//
//  SearchResoultViewController.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/22.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "SearchResoultViewController.h"
#import "AddressBookManager.h"
@interface SearchResoultViewController ()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *myTableView;


@end

@implementation SearchResoultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.myTableView];
	_myTableView.dataSource = self;
	_myTableView.delegate = self;
	if (@available(iOS 11.0,*)) {
		_myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	[_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	_myTableView.backgroundColor = [UIColor whiteColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (!_dataSourceArray) {
		return 0;
	}
	return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	cell =  [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	PhoneUser *user = self.dataSourceArray[indexPath.row];
	cell.textLabel.text = user.userName;
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.didSeletedUserBlock) {
		self.didSeletedUserBlock(self.dataSourceArray[indexPath.row]);
	}
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return nil;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.searchBar resignFirstResponder];
}
-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	CGFloat topH =  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 55;
	_myTableView.frame = CGRectMake(0, topH, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - topH);
}
-(UITableView *)myTableView
{
	if (!_myTableView)
	 {
		_myTableView = [[UITableView alloc]init];
	 }
	return _myTableView;
}
-(void)setDataSourceArray:(NSArray *)dataSourceArray
{
	_dataSourceArray = dataSourceArray;
	[self.myTableView reloadData];
}


@end
