//
//  RefreshCircleView.h
//  ScrollPage
//
//  Created by ios2 on 2019/3/20.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshCircleView : UIView
//设置进度
@property(nonatomic,assign)CGFloat progress;
//设置颜色
@property (nonatomic,strong)UIColor *circleColor;
//设置线条宽度
@property(nonatomic,assign)CGFloat lineWidth;

@end




