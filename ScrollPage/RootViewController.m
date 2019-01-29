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

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"距离放假还有:";

	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setTitle:@"强迫症治愈系" forState:UIControlStateNormal];
	btn.backgroundColor = [UIColor orangeColor];
	[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
	btn.bounds = CGRectMake(0, 0, 300, 60);
	btn.center = self.view.center;
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

	NSString *str = @"2019-02-01 15:00:00";

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
