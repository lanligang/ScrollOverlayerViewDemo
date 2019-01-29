//
//  BaseSubViewController.h
//  ScrollPage
//
//  Created by ios2 on 2019/1/29.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSubViewController : UIViewController
//滚动视图
@property (nonatomic,strong)UIScrollView *containtScrollView;
//表头
@property (nonatomic,strong)UIView *scrollHeaderView;

//开始执行下拉刷新
-(void)begainRefresh;
//需要在子类中实现的方法
-(void)pulldownRefresh;

@end
