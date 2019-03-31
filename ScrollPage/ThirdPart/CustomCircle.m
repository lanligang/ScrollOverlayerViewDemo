//
//  CustomCircle.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/20.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "CustomCircle.h"
#import "RefreshCircleView.h"

@implementation CustomCircle {
	RefreshCircleView *_circleView;
	BOOL _isAnimation; //是否正在执行动画
}

-(instancetype)init
{
	self = [super init];
	if (self) {
		[self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
		_animationProgress = 0.5;
		_circleView = [[RefreshCircleView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
		[self addSubview:_circleView];
	}
	return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	if ([keyPath isEqualToString:@"contentOffset"]) {
		if ([object isKindOfClass:[UIScrollView class]]) {
			UIScrollView *scrollView = (UIScrollView *)object;
			CGFloat offSetY = - scrollView.contentOffset.y;
			if (self.state == MJRefreshStatePulling) {
				if (!_isAnimation) {
					_circleView.progress = 1.0;
				}
			}else if (self.state == MJRefreshStateRefreshing){
				if (!_isAnimation) {
						_circleView.progress = 0.5;
				}
			}else{
				if (!_isAnimation) {
					_circleView.progress = offSetY /(MJRefreshHeaderHeight + 10);
				}
			}
		}
	}
	if ([keyPath isEqualToString:@"state"]) {
		if (self.state == MJRefreshStateRefreshing){
			if (_isAnimation) return;
			_isAnimation = YES;
			_circleView.progress = _animationProgress;
			[_circleView.layer removeAllAnimations];
			CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
			animation.keyPath = @"transform.rotation";
			animation.values = @[@(0),@(2*M_PI)];
			animation.duration = 0.8;
			animation.repeatCount  = NSIntegerMax;
			[_circleView.layer addAnimation:animation forKey:nil];
		}else if (self.state == MJRefreshStateIdle){
			[_circleView.layer removeAllAnimations];
			_isAnimation = NO;
			_circleView.progress = 1.0;
		}
	}
}
-(void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat height = self.bounds.size.height;
	CGFloat width = self.bounds.size.width;
	_circleView.center = CGPointMake(width/2.0, height - _circleView.bounds.size.height /2.0);
}
-(void)dealloc
{
	[self removeObserver:self forKeyPath:@"state"];
	
}

-(void)setAnimationProgress:(CGFloat)animationProgress
{
	_animationProgress = animationProgress;
	_animationProgress = MAX(_animationProgress, 0.1);
	_animationProgress = MIN(_animationProgress,0.9);
	_circleView.progress = _animationProgress;

}

-(RefreshCircleView *)circleView
{
	return _circleView;
}



@end
