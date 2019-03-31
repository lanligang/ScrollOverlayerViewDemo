//
//  CircleFooter.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/21.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "CircleFooter.h"

@implementation CircleFooter{
	RefreshCircleView *_circleView;
	BOOL _isAnimation; //是否正在执行动画
	CGFloat _animationProgress;
	UIActivityIndicatorView *_loadingView;
}
-(instancetype)init
{
	self = [super init];
	if (self) {
		__weak typeof(self)ws = self;
		[self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if ([obj isKindOfClass:[UIActivityIndicatorView class]]) {
				__strong typeof(ws) ss = ws;
				ss->_loadingView = obj;
				*stop = YES;
			}
		}];
		[self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
		_animationProgress = 0.6;
		_circleView = [[RefreshCircleView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
		_circleView.circleColor = [UIColor greenColor];
		_circleView.hidden = YES;
		[self addSubview:_circleView];
		_loadingView.hidden = YES;
		self.stateLabel.hidden = YES;
		self.arrowView.image = nil;
	}
	return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	if ([keyPath isEqualToString:@"state"]) {
		if (self.state == MJRefreshStateRefreshing){
			if (_isAnimation) return;
			_isAnimation = YES;
			_circleView.hidden = NO;
			_circleView.progress = _animationProgress;
			[_circleView.layer removeAllAnimations];
			CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
			animation.keyPath = @"transform.rotation";
			animation.values = @[@(0),@(2*M_PI)];
			animation.duration = 0.8;
			animation.repeatCount  = NSIntegerMax;
			[_circleView.layer addAnimation:animation forKey:nil];
			_loadingView.hidden = YES;
			self.stateLabel.hidden = YES;
		}else {
			[_circleView.layer removeAllAnimations];
			_isAnimation = NO;
			_circleView.hidden = YES;
			_circleView.progress = 0.0;
			self.stateLabel.hidden = YES;
		}
	}
}

-(void)dealloc
{
	[self removeObserver:self forKeyPath:@"state"];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat height = self.bounds.size.height;
	CGFloat width = self.bounds.size.width;
	_circleView.center = CGPointMake(width/2.0, height/2.0);
}

-(RefreshCircleView *)circleView
{
	return _circleView;
}

@end
