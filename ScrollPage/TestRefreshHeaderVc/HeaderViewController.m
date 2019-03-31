//
//  HeaderViewController.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/20.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "HeaderViewController.h"
#import "CustomCircle.h"
#import "CircleFooter.h"
#import "AddressBookManager.h" //
#import "BMChineseSort.h"
#import "SearchResoultViewController.h"
//这里调起发送短信的控制器
#import <MessageUI/MessageUI.h>

#import "AddressBookAddUserViewController.h"

#import "UINavigationController+FDFullscreenPopGesture.h"



#define SYSTEM_VERSION_GRETER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface HeaderViewController ()
<UITableViewDataSource,
UITableViewDelegate,
MFMessageComposeViewControllerDelegate,
UISearchBarDelegate>
{
	UIView *_topSearchView;
	UILabel *_topTitleLable;
	UIView *_topSuperView;
	CGRect _topRect;
	BOOL _isSearch;
}
@property (nonatomic,strong)NSArray *allPhoneInfos;
@property (nonatomic,strong)NSArray *indexKeys;

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)UISearchBar *searchBar;
//没有处理之前的数组
@property (nonatomic,strong)NSArray *userAllArray;

@end

@implementation HeaderViewController

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHiddenNotification:) name:UIKeyboardWillHideNotification object:nil];
	[self.navigationController.navigationBar setValue:@(YES) forKey:@"isHiddenLine"];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.navigationController.navigationBar setValue:@(NO) forKey:@"isHiddenLine"];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	self.fd_interactivePopDisabled = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	self.fd_interactivePopDisabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.myTableView];
	if (@available(iOS 11.0,*)) {
		_myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	_myTableView.dataSource = self;
	_myTableView.delegate = self;
	_myTableView.sectionIndexColor = [UIColor blackColor];
	_myTableView.sectionIndexBackgroundColor =[UIColor clearColor];
	_myTableView.mj_header = [CustomCircle headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
	CustomCircle *circleView = (CustomCircle *)_myTableView.mj_header;
	circleView.circleView.circleColor = [UIColor lightGrayColor];
	circleView.circleView.lineWidth = 4.0;
	circleView.animationProgress = 0.45;
	[circleView beginRefreshing];
	CircleFooter *footer = [CircleFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh)];
	footer.circleView.circleColor = [UIColor lightGrayColor];
	footer.hidden = NO;
	_myTableView.mj_footer  = footer;

	CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
	UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 90)];
	_myTableView.tableHeaderView = headerView;
	UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
	titleLable.textColor = [UIColor blackColor];
	titleLable.text = @"通讯录";
	titleLable.font = [UIFont systemFontOfSize:30];
	_topTitleLable = titleLable;
	[headerView addSubview:titleLable];
	_topSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, screenWidth, 50)];
	_topSearchView.backgroundColor = [UIColor whiteColor];
	[headerView addSubview:_topSearchView];
	[_myTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
	UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:_topSearchView.bounds];
	//设置搜索控制器
	[_topSearchView addSubview:searchBar];
	searchBar.placeholder = @"请输入姓名、手机号";
	[searchBar setBackgroundImage:[UIImage new]];
	searchBar.searchBarStyle = UISearchBarStyleMinimal;
	//设置搜索框文字偏移
	searchBar.searchTextPositionAdjustment = UIOffsetMake(3, 0);
	//设置搜索图标偏移
	CGFloat offSetX = (CGRectGetWidth(self.view.bounds) - 200 - 32)/2;
	[searchBar setPositionAdjustment:UIOffsetMake(offSetX, 0) forSearchBarIcon:UISearchBarIconSearch];
	//设置光标颜色
	searchBar.tintColor = [UIColor blackColor];
	//设置搜索文本框背景图片
	[searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"搜索_03"] forState:UIControlStateNormal];
	[searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
	searchBar.showsCancelButton = NO;
	searchBar.delegate = self;
	self.searchBar = searchBar;

	SearchResoultViewController *resultVc = [[SearchResoultViewController alloc]init];
	resultVc.searchBar = searchBar;
	[self addChildViewController:resultVc];
	resultVc.view.frame = self.view.bounds;
	resultVc.view.hidden = YES;
	[self.view addSubview:resultVc.view];
	[self creactBackNavBarItem];
	__weak typeof(self)ws = self;
	[resultVc setDidSeletedUserBlock:^(id  _Nonnull sender) {
		__strong typeof(ws) ss = ws;
		if ([sender isKindOfClass:[PhoneUser class]]) {
			ss-> _isSearch = NO;
			[ss downSearchBarFrame];
			ws.searchBar.text = @"";
			ws.searchBar.showsCancelButton = NO;
			[ws.searchBar resignFirstResponder];
			[ws didSeletedUser:sender];
		}
	}];
	UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addUserAction:)];
	[addItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
	[addItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateHighlighted];
	self.navigationItem.rightBarButtonItem = addItem;
}
-(void)addUserAction:(id)sender {
	//点击了添加用户
	AddressBookAddUserViewController *addressBookVc = [[AddressBookAddUserViewController alloc]init];
	[self.navigationController pushViewController:addressBookVc animated:YES];
}
-(void)didSeletedUser:(PhoneUser *)user {
	__weak typeof(self)ws = self;
	UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *callAction =  [UIAlertAction actionWithTitle:@"打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[ws callWithUser:user];
	}];
	UIAlertAction *smsAction =  [UIAlertAction actionWithTitle:@"发短息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[ws smsWithUser:user];
	}];
	UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	[controller addAction:callAction];
	[controller addAction:smsAction];
	[controller addAction:cancelAction];
	[self presentViewController:controller animated:YES completion:nil];
}
-(void)callWithUser:(PhoneUser *)user
{
	if (user.userPhones.count > 1) {
		UIAlertController *aleteController =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
		for (int i = 0; i< user.userPhones.count; i++) {
			UIAlertAction *action = [UIAlertAction actionWithTitle:user.userPhones[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				[[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",action.title]]];
			}];
			[aleteController addAction:action];
		}
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
		[aleteController addAction:cancelAction];
		[self presentViewController:aleteController animated:YES completion:nil];
	}else{
		if (user.userPhones.firstObject) {
			[[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",user.userPhones.firstObject]]];
		}
	}
}

-(void)smsWithUser:(PhoneUser *)user
{
	if (user.userPhones.count > 1) {
		UIAlertController *aleteController =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
		__weak typeof(self)ws = self;
		for (int i = 0; i< user.userPhones.count; i++) {
			UIAlertAction *action = [UIAlertAction actionWithTitle:user.userPhones[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				[ws sendSMSWithPhone:@[action.title] andMessage:@"早上好!"];
			}];
			[aleteController addAction:action];
		}
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
		[aleteController addAction:cancelAction];
		[self presentViewController:aleteController animated:YES completion:nil];
	}else{
		[self sendSMSWithPhone:user.userPhones andMessage:@"早上好!"];
	}
}

-(void)creactBackNavBarItem
{
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"activity_back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedBackAction:)];
	self.navigationItem.leftBarButtonItem = item;
}
-(void)didClickedBackAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)keyBoardWillShowNotification:(NSNotification *)notification
{
	[self.navigationController setNavigationBarHidden:YES animated:YES];

	if (_isSearch)return;
	_isSearch = YES;
	self.myTableView.hidden = YES;
	SearchResoultViewController *resultVc = (SearchResoultViewController *)self.childViewControllers.firstObject;
	resultVc.dataSourceArray = nil;
	resultVc.view.hidden = NO;
	if (!_topSuperView) {
		_topSuperView = _topSearchView.superview;
		_topRect = _topSearchView.frame;
	}
	[self.view addSubview:_topSearchView];
	self.searchBar.showsCancelButton = YES;
	CGFloat topH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
	[self.searchBar setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
	[UIView animateWithDuration:0.2 animations:^{
		self->_topSearchView.frame = CGRectMake(0, topH, CGRectGetWidth(self->_topSearchView.frame), CGRectGetHeight(self->_topSearchView.frame));
	}];
}
-(void)keyBoardWillHiddenNotification:(NSNotification *)notification
{
	[self downSearchBarFrame];
}
-(void)downSearchBarFrame
{
	if (_isSearch)return;
	SearchResoultViewController *resultVc = (SearchResoultViewController *)self.childViewControllers.firstObject;
	resultVc.view.hidden = YES;
	[self.navigationController setNavigationBarHidden:NO animated:YES];

	self.myTableView.hidden = NO;
	self.searchBar.showsCancelButton = NO;
	[_topSuperView addSubview:_topSearchView];
	[UIView animateWithDuration:0.2 animations:^{
		self->_topSearchView.frame = self->_topRect;
	}];
	CGFloat offSetX = (CGRectGetWidth(self.view.bounds) - 200 - 32)/2;
	[self.searchBar setPositionAdjustment:UIOffsetMake(offSetX, 0) forSearchBarIcon:UISearchBarIconSearch];
	_topSuperView = nil;
}

//KVO的使用
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	//如果是在搜索状态下
	if (_isSearch)return;
	if ([keyPath isEqualToString:@"contentOffset"]) {
		if ([object isKindOfClass:[UIScrollView class]]) {
			UIScrollView *scrollView = (UIScrollView *)object;
			CGFloat offSetY = scrollView.contentOffset.y;
			if (offSetY >= 40) {
				self.navigationItem.title = @"通讯录";
			}else{
				self.navigationItem.title = @"";
			}
			if (offSetY >= 40) {
					[self.view addSubview:_topSearchView];
					CGFloat topH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44.0;
					_topSearchView.frame = CGRectMake(0, topH, CGRectGetWidth(_topSearchView.bounds), CGRectGetHeight(_topSearchView.bounds));
				}else{
					[_myTableView.tableHeaderView addSubview:_topSearchView];
					_topSearchView.frame = CGRectMake(0, 40, CGRectGetWidth(_topSearchView.bounds), CGRectGetHeight(_topSearchView.bounds));
			}
		}
	}
}
-(void)pullDownRefresh
{
	__weak typeof(self)ws = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[ws.myTableView.mj_footer endRefreshing];
		[ws.myTableView reloadData];
	});
}
//下拉刷新
-(void)refreshAction {
	__weak typeof(self)ws = self;
		[AddressBookManager requestAddressBookInfos:^(NSArray * array,NSArray *userNames) {
			ws.allPhoneInfos = [BMChineseSort sortObjectArray:array Key:@"userName"];
			ws.indexKeys = [BMChineseSort IndexWithArray:array Key:@"userName"];
			ws.userAllArray = array;
			[ws.myTableView.mj_header endRefreshing];
			[ws.myTableView reloadData];
		}];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return self.indexKeys[section];
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return self.indexKeys;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (!self.allPhoneInfos) {
		return 0;
	}
	return self.allPhoneInfos.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.allPhoneInfos[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	cell.selectionStyle =  UITableViewCellSelectionStyleGray;
	cell.backgroundColor = [UIColor whiteColor];
	PhoneUser *user = self.allPhoneInfos[indexPath.section][indexPath.row];
	cell.textLabel.text = user.userName;
	cell.detailTextLabel.text = user.userPhones.firstObject;
	return cell;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak typeof(self)ws = self;
	UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[ws actionCallWithIndexPath:indexPath];
	}];
	UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[ws actionSMSWithIndexPath:indexPath];
	}];
	action2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
	action1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
	return @[action2,action1];
}
//发短信
-(void)actionSMSWithIndexPath:(NSIndexPath *)indexPath
{
	PhoneUser *user =  (PhoneUser *)self.allPhoneInfos[indexPath.section][indexPath.row];
	[self smsWithUser:user];
}
//打电话  ---
-(void)actionCallWithIndexPath:(NSIndexPath *)indexPath
{
	PhoneUser *user =  (PhoneUser *)self.allPhoneInfos[indexPath.section][indexPath.row];
	[self callWithUser:user];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	PhoneUser *user  = self.allPhoneInfos[indexPath.section][indexPath.row];
	[self didSeletedUser:user];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.indexPath = indexPath;
	[self.view setNeedsLayout];
}
-(void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	[self configSwipeButtons];
}
//这里是向左滑动图片的
- (void)configSwipeButtons
{
	//这里只有发短信和打电话 所以只有两个
	if (SYSTEM_VERSION_GRETER_THAN(@"11.0")) {
		for (UIView *subView in _myTableView.subviews) {
			if ([subView isKindOfClass:objc_getClass([@"UISwipeActionPullView" UTF8String])]&& subView.subviews.count >=2) {
				UIButton *btn = subView.subviews[0];
				UIButton *btn2 = subView.subviews[1];
				[btn setImage:[UIImage imageNamed:@"dadianhua"] forState:UIControlStateNormal];
				[btn2 setImage:[UIImage imageNamed:@"faduanxin"] forState:UIControlStateNormal];
				break;
			}
		}
	}else{
		// 8~ 10 的 系统
		if (self.indexPath) {
			UITableViewCell *cell = (UITableViewCell *)[_myTableView cellForRowAtIndexPath:self.indexPath];
			if (cell) {
				for (UIView *subView in cell.subviews) {
					if ([subView isKindOfClass:objc_getClass([@"UITableViewCellDeleteConfirmationView" UTF8String])]&&[subView.subviews count]>=2) {
						UIButton *btn = subView.subviews[1];
						UIButton *btn2 = subView.subviews[0];
						[btn setImage:[UIImage imageNamed:@"dadianhua"] forState:UIControlStateNormal];
						[btn2 setImage:[UIImage imageNamed:@"faduanxin"] forState:UIControlStateNormal];
						return;
					}
				}
			}
		}
	}
}
#pragma mark viewWillLayoutSubviews
-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	CGFloat top = [[UIApplication sharedApplication] statusBarFrame].size.height + 44.0;
	_myTableView.frame = (CGRect){CGPointMake(0, top),self.view.bounds.size.width,self.view.bounds.size.height - top};
}
-(UITableView *)myTableView
{
	if (!_myTableView)
 {
	_myTableView = [[UITableView alloc]init];
 }
	return _myTableView;
}
-(void)sendSMSWithPhone:(NSArray *)phoneNumbers andMessage:(NSString *)msg
{
	MFMessageComposeViewController *messageVc = [[MFMessageComposeViewController alloc]init];
	messageVc.body = msg;
	messageVc.recipients = phoneNumbers;
	messageVc.messageComposeDelegate = self;
	[self presentViewController:messageVc animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[controller dismissViewControllerAnimated:YES completion:nil];
	if (result == MessageComposeResultCancelled) {
		NSLog(@"用户取消发送");
	}else if (result == MessageComposeResultFailed){
		NSLog(@"用户发送失败");
	}else if (result == MessageComposeResultSent){
		NSLog(@"用户发送成功");
	}else{
		NSLog(@"未知状态");
	}
}
-(void)dealloc
{
	[_myTableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark SearchBar 代理
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if (!self.userAllArray)return;
	NSArray *array = nil;
	if ((searchText != nil)&&(![searchText isEqualToString:@""])) {
		NSString *str = searchText;
		NSString *upPinYin = [str uppercaseString];
		upPinYin = [upPinYin stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *predStr = [NSString stringWithFormat:@"userName like '*%@*' OR firstPhone contains '%@' OR namepinyin like '*%@*'",str,str,upPinYin];
		NSPredicate *pred = [NSPredicate predicateWithFormat:predStr];
		array =  [self.userAllArray filteredArrayUsingPredicate:pred];
	}
	SearchResoultViewController *resultVc = (SearchResoultViewController *)self.childViewControllers.firstObject;
	resultVc.dataSourceArray = array;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	_isSearch = NO;
	[self downSearchBarFrame];
	self.searchBar.text = @"";
	[self.searchBar resignFirstResponder];

}

@end





