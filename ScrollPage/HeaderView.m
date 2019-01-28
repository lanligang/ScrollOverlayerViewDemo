//
//  HeaderView.m
//  ScrollPage
//
//  Created by mc on 2019/1/27.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
		UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)otherGestureRecognizer;
	    CGPoint p = [pan velocityInView:pan.view];
		 CGFloat x = ABS(p.x);
		CGFloat y = ABS(p.y);
		if (y>x) {
			return YES;
		}else{
			return NO;
		}
	}
	return YES;
}

@end
