//
//  UIScrollView+PopScrollView.m
//  TeBrand
//
//  Created by ios2 on 2018/8/23.
//  Copyright © 2018年 SunBo. All rights reserved.
//

#import "UIScrollView+PopScrollView.h"

@implementation UIScrollView (PopScrollView)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

	if (self.contentOffset.x <= 0) {
		CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
		if (self.contentSize.width>screenWidth) {
			if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
				return YES;
			}
		}
	}
	return NO;
}
@end
