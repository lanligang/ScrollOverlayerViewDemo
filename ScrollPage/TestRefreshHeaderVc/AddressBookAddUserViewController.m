//
//  AddressBookAddUserViewController.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/25.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "AddressBookAddUserViewController.h"
#import "AddressBookManager.h"
#import "TextViewTableViewCell.h"
#import "TextFiledTableViewCell.h"
#import "TextFileModel.h"
#import "NSObject+LgObserver.h"

@interface AddressBookAddUserViewController ()<UITableViewDelegate,UITableViewDataSource>
{
	UIButton *_saveButton;         // 保存按钮
}
@property (nonatomic,strong)UITableView *myTbaleView;

@property(nonatomic,weak)UITextView * noteTextView;

//文本输入数组
@property (nonatomic,strong)NSMutableArray<TextFileModel *> *tfInputArray;


@end

@implementation AddressBookAddUserViewController
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwillShowNotification:) name:UIKeyboardWillShowNotification object:nil];

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwillHiddeNotification:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"新建联系人";
	self.tfInputArray = [NSMutableArray array];
	
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.myTbaleView];
	_myTbaleView.delegate = self;
	_myTbaleView.dataSource = self;
	_myTbaleView.estimatedRowHeight = 0;

	[_myTbaleView registerNib:[UINib nibWithNibName:@"TextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

	//输入框
	TextFileModel *model0 = [[TextFileModel alloc]init];
	model0.name = @"姓 名：";
	model0.text = @"";
	TextFileModel *model1 = [[TextFileModel alloc]init];
	model1.name = @"手机号：";
	model1.text = @"";
	[self.tfInputArray addObject:model0];
	[self.tfInputArray addObject:model1];
	[_myTbaleView registerNib:[UINib nibWithNibName:@"TextFiledTableViewCell" bundle:nil] forCellReuseIdentifier:@"textInputCell"];

	if (@available(iOS 11.0,*)) {
		_myTbaleView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	CGFloat top = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44.0;
	_myTbaleView.frame = (CGRect){CGPointMake(0, top),CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - top)};
	UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
	button.tintColor = [UIColor blackColor];
	button.frame = CGRectMake(0, 0, 40, 40);
	[button addTarget:self action:@selector(addNewClick:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = addItem;

	UIView *tableFooterView = [UIView new];
	tableFooterView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 65.0f);
	[self.view addSubview:tableFooterView];
	UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[tableFooterView addSubview:saveBtn];
	saveBtn.backgroundColor = [UIColor lightGrayColor];
	saveBtn.layer.cornerRadius = 20.0f;
	saveBtn.layer.masksToBounds = YES;
	saveBtn.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 50.0, 40);
	saveBtn.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0, 65/2.0);
	[saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
	[saveBtn setTitle:@"保 存" forState:UIControlStateHighlighted];
	[saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[saveBtn addTarget:self action:@selector(saveClicked:) forControlEvents:UIControlEventTouchUpInside];
	_saveButton = saveBtn;
	_myTbaleView.tableFooterView = tableFooterView;
	__weak typeof(self)ws = self;
	[_myTbaleView.lgOberVer.addObserverKey(@"panGestureRecognizer.state") setDidChageMsg:^(id msg) {
		[ws myTableViewDidChangePanState];
	}];
}
//滚动视图手势改变
-(void)myTableViewDidChangePanState
{
	UIPanGestureRecognizer *pan  = _myTbaleView.panGestureRecognizer;
	if (pan.state == UIGestureRecognizerStateBegan||pan.state == UIGestureRecognizerStateEnded) {
		CGPoint vP =  [pan velocityInView:_myTbaleView];
		if (vP.y > 0) {
			[self.view endEditing:YES];
		}
	}
}
-(void)saveClicked:(UIButton *)button
{
	NSMutableArray *phoneArray = [NSMutableArray array];
	NSString *title = @"";
	NSString *note = !_noteTextView? @"":_noteTextView.text;
	for (int i = 0; i< self.tfInputArray.count; i++) {
		TextFileModel *model = self.tfInputArray[i];
		if (i == 0) {
			title = model.text;
		}else{
			BOOL isCanSave = (model.text.length > 6 && model.text.length <= 11 && model.text.length != NSNotFound)?YES:NO;
			if (isCanSave) {
				[phoneArray addObject:model.text];
			}
		}
	}
	BOOL isSucess = [AddressBookManager cracteAddBookRecordBuPhoneArray:phoneArray andTitle:title andNote:note];
	if (isSucess) {
		if (self.addUserSuccess) {
			self.addUserSuccess();
		}
		[self.navigationController popViewControllerAnimated:YES];
	}
}
-(void)addNewClick:(id)sender
{
	TextFileModel *model0 = [[TextFileModel alloc]init];
	model0.name = @"手机号：";
	model0.text = @"";
	[self.tfInputArray addObject:model0];
	[self.myTbaleView reloadData];
	[self updateSaveButtonState];
}
-(void)textFieldTextDidChangeNotification:(NSNotification *)noti
{
	if ([noti.object isKindOfClass:[UITextField class]]) {
		UITextField *tf = (UITextField *)noti.object;
		NSInteger index = tf.tag - 100;
		if (index >0&&(tf.markedTextRange == nil)) {
			if (tf.text.length > 11) {
				tf.text = [tf.text substringToIndex:11];
			}
		}
		TextFileModel *model = (TextFileModel *)self.tfInputArray[index];
		model.text = tf.text;
	}
	[self updateSaveButtonState];
}
-(void)keyBoardwillShowNotification:(NSNotification *)noti
{
	NSDictionary *dic = noti.userInfo;
	CGRect rect =    [(NSValue *)dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGFloat topH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44;
	_myTbaleView.frame = (CGRect){0,topH,CGSizeMake(_myTbaleView.frame.size.width, CGRectGetHeight([UIScreen mainScreen].bounds) - topH - CGRectGetHeight(rect))};
}
-(void)keyBoardwillHiddeNotification:(NSNotification *)noti
{
	CGFloat topH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44;
	_myTbaleView.frame = (CGRect){0,topH,CGSizeMake(_myTbaleView.frame.size.width, CGRectGetHeight([UIScreen mainScreen].bounds) - topH)};
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		TextFiledTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier:@"textInputCell" forIndexPath:indexPath];
		tfCell.myTbaleView = tableView;
		TextFileModel *model = self.tfInputArray[indexPath.row];
		tfCell.topTitleLable.text = model.name;
		if (indexPath.row == 0) {
			tfCell.inputTextFiled.keyboardType = UIKeyboardTypeDefault;
			tfCell.inputTextFiled.placeholder = @"请输入姓名";
		}else{
			tfCell.inputTextFiled.keyboardType = UIKeyboardTypeNumberPad;
			tfCell.inputTextFiled.placeholder = @"请输入手机号";
		}
		tfCell.inputTextFiled.tag = (indexPath.row + 100);
		tfCell.inputTextFiled.text = model.text;
		[tfCell setSelectionStyle:UITableViewCellSelectionStyleNone];
		return tfCell;
	}else{
		TextViewTableViewCell *cell = (TextViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
		self.noteTextView = cell.noteTextView;
		cell.tableView = tableView;
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		return cell;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

	return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		if (indexPath.row == 0||indexPath.row == 1) {
			return NO;
		}else{
			return YES;
		}
	}else{
		return NO;
	}
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
		//删除
	__weak typeof(self)ws = self;
	UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		__strong typeof(ws)ss = ws;
		[ss.tfInputArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		[ss updateSaveButtonState];
	}];
	return @[deleteRowAction];
}
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return self.tfInputArray.count;
	}
	return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 50 + 35;
	}else{
		if (_noteTextView) {
			CGFloat height = [TextViewTableViewCell getHeightWithString:_noteTextView];
			CGFloat maxH = height > 120 ? height : 120;
			return maxH;
		}
		return 120;
	}
}
-(void)updateSaveButtonState
{
	__block BOOL isName = NO;
	__block BOOL isPhone = NO;
	[self.tfInputArray enumerateObjectsUsingBlock:^(TextFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (idx == 0) {
			isName = (obj.text.length >0) ? YES:NO;
		}else {
			if (obj.text) {
				isPhone = (obj.text.length > 6 && obj.text.length <= 11)?YES:NO;
			}else{
				isPhone = NO;
			}
			if (isPhone) {
				*stop = YES;
			}
		}
	}];
	if (isName == YES && isPhone == YES) {
		_saveButton.userInteractionEnabled = YES;
		_saveButton.backgroundColor = [UIColor colorWithRed:131/255.0 green:255/255.0 blue:247/255.0 alpha:1];
		[_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	}else{
		_saveButton.userInteractionEnabled = NO;
		_saveButton.backgroundColor = [UIColor lightGrayColor];
		[_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	}
}
-(UITableView *)myTbaleView
{
	if (!_myTbaleView)
	 {
		_myTbaleView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
	 }
	return _myTbaleView;
}

@end
