//
//  LGCustomNavBar.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/28.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "LGCustomNavBar.h"

@implementation LGCustomNavBar{
	UIView *_bottomLineView;
}
-(instancetype)init
{
	self = [super init];
	if (self) {
		_isHiddenLine = @(NO);
		_bottomLineView = [UIView new];
		[self addSubview:_bottomLineView];
		_bottomLineView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
	}
	return self;
}
-(void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat h = 1;
	CGFloat y =	CGRectGetHeight(self.bounds) - h;
	CGFloat w = CGRectGetWidth(self.bounds);
	_bottomLineView.frame = CGRectMake(0, y, w, h);
}
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	for (UIView *v  in self.subviews) {
		if ([v isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
			v.backgroundColor = [UIColor clearColor];
		}
		if ([v isKindOfClass:NSClassFromString(@"_UINavigationBarLargeTitleView")]) {
			v.backgroundColor = [UIColor clearColor];
		}
		if ([v isKindOfClass:NSClassFromString(@"_UINavigationBarModernPromptView")]) {
			v.backgroundColor = [UIColor clearColor];
		}
		if ([v isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
			v.backgroundColor = [UIColor clearColor];
		}
	}
	if ([_isHiddenLine boolValue]) {
		_bottomLineView.hidden = YES;
	}else{
		_bottomLineView.hidden = NO;
	}

}

-(void)setIsHiddenLine:(NSNumber *)isHiddenLine
{
	_isHiddenLine = isHiddenLine;
	[self setNeedsDisplay];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView * v = [super hitTest:point withEvent:event];
	if ([v isKindOfClass:[LGCustomNavBar class]]) {
		return nil;
	}
	if ([v isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
		return nil;
	}
	if ([v isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
		return nil;
	}
	return v;
}

@end
