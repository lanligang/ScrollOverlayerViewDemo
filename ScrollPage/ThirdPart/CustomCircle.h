//
//  CustomCircle.h
//  ScrollPage
//
//  Created by ios2 on 2019/3/20.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "MJRefreshHeader.h"
#import "RefreshCircleView.h"

@interface CustomCircle : MJRefreshHeader

@property (nonatomic,readonly)RefreshCircleView *circleView;

//进行动画的百分比 默认 0.5
@property(nonatomic,assign)CGFloat animationProgress;

@end

