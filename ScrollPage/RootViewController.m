//
//  RootViewController.m
//  ScrollPage
//
//  Created by ios2 on 2019/1/28.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setTitle:@"点我" forState:UIControlStateNormal];
	btn.backgroundColor = [UIColor greenColor];
	[btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
	btn.bounds = CGRectMake(0, 0, 100, 100);
	btn.center = self.view.center;
	[self.view addSubview:btn];
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
