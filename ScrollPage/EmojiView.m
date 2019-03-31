//
//  EmojiView.m
//  CutImageDemo
//
//  Created by ios2 on 2019/3/16.
//  Copyright © 2019 LenSkey. All rights reserved.
//

#import "EmojiView.h"

@implementation EmojiView
-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	UIBezierPath *path = [UIBezierPath bezierPath];
	CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
	[[UIColor redColor]setStroke];
	[[UIColor clearColor]setFill];
	path.lineCapStyle = kCGLineCapRound;
	path.lineWidth = 3.0;
	[path addArcWithCenter:center radius:CGRectGetWidth(self.frame)/2 - 5 startAngle:0 endAngle:(2*M_PI *_progress) clockwise:YES];
	[path stroke];
	[path fill];
}
-(void)setProgress:(CGFloat)progress
{
	_progress = progress;
	_progress = MAX(0, _progress);
	_progress = MIN(_progress, 1.0);
	[self setNeedsDisplay];

}



@end
