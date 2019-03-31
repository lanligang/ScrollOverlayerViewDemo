//
//  RefreshCircleView.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/20.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "RefreshCircleView.h"
//来自mjrefresh中
#define AARefreshDispatchAsyncOnMainQueue(x) \
__weak typeof(self) weakSelf = self; \
dispatch_async(dispatch_get_main_queue(), ^{ \
typeof(weakSelf) self = weakSelf; \
{x} \
});

@implementation RefreshCircleView
-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		_circleColor = [UIColor redColor];
		_lineWidth = 3.0;
		self.transform = CGAffineTransformMakeRotation(-M_PI_2);
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	UIBezierPath *path = [UIBezierPath bezierPath];
	CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
	[_circleColor setStroke];
	[[UIColor clearColor]setFill];
	path.lineCapStyle = kCGLineCapRound;
	path.lineWidth = _lineWidth;
	[path addArcWithCenter:center radius:CGRectGetWidth(self.frame)/2 - 5 startAngle:0 endAngle:(2*M_PI *_progress) clockwise:YES];
	[path stroke];
	[path fill];
}
-(void)setProgress:(CGFloat)progress
{
	_progress = progress;
	_progress = MAX(0, _progress);
	_progress = MIN(_progress, 1.0);
	AARefreshDispatchAsyncOnMainQueue([self setNeedsDisplay];);
}

-(void)setCircleColor:(UIColor *)circleColor
{
	_circleColor = circleColor;
	AARefreshDispatchAsyncOnMainQueue([self setNeedsDisplay];);
}

-(void)setLineWidth:(CGFloat)lineWidth
{
	_lineWidth = lineWidth;
	AARefreshDispatchAsyncOnMainQueue([self setNeedsDisplay];);
}

@end
