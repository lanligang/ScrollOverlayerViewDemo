//
//  RootViewController.m
//  ScrollPage
//
//  Created by ios2 on 2019/1/28.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "ScrollNumber.h"

@interface RootViewController ()
{
	ScrollNumber *_numView;
	NSInteger _endTimeLine;
}
@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"细思及恐之距离2080年还有";
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setTitle:@"强迫症治愈系" forState:UIControlStateNormal];
	btn.backgroundColor = [UIColor orangeColor];
	[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
	btn.bounds = CGRectMake(0, 0, 300, 60);
	btn.center = CGPointMake(self.view.center.x, self.view.center.y - 80.0f);
	[self.view addSubview:btn];

	ScrollNumber *numView = [[ScrollNumber alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 80, 40)];
	numView.layer.cornerRadius = 5.0f;
	numView.backgroundColor = [UIColor blackColor];
	numView.layer.borderWidth = 0.5f;
	numView.layer.borderColor = [UIColor blackColor].CGColor;
	numView.layer.masksToBounds = YES;
	_numView = numView;
	numView.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, 180);
	[self.view addSubview:numView];

	NSString *str = @"2080-01-01 00:00:00";
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	NSDate *beginDate=[formatter dateFromString:str];
	_endTimeLine = [beginDate timeIntervalSince1970]/1;

	UILabel *s = [UILabel new];
	s.text = @"s";
	s.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:s];
	s.frame = CGRectMake(CGRectGetMaxX(numView.frame), CGRectGetMinY(numView.frame), 20, CGRectGetHeight(numView.frame));
	NSTimer *timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ontimer) userInfo:nil repeats:YES];
	[timer fire];

	UITextView *tfV = [UITextView new];
	tfV.textColor = [UIColor redColor];
	tfV.font = [UIFont systemFontOfSize:20.0f];
	tfV.text = @"亲爱的朋友:\n  假设我能活到2080年那么我至少活了90年,你看到的时间就只要那么一点这是你能看到的流逝平时不觉得什么,但是真正显示出来的时候\n却又觉得可怕！\n珍惜当下的每一分每一秒吧！";
	[self.view addSubview:tfV];
	tfV.frame = CGRectMake(10, CGRectGetMaxY(btn.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 300.0f);
	tfV.editable = NO;
	[self.view addSubview:tfV];

}
-(void)ontimer
{
	NSInteger num = MAX(_endTimeLine - ( [[NSDate date] timeIntervalSince1970]/1), 0);
	_numView.number = num;
}

-(void)onClicked:(id)sender
{
	ViewController *vc = [[ViewController alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
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
