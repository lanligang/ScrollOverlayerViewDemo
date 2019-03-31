/*_       _____   __   _   _____   _   _   __    __
 | |     | ____| |  \ | | /  ___/ | | / /  \ \  / /
 | |     | |__   |   \| | | |___  | |/ /    \ \/ /
 | |     |  __|  | |\   | \___  \ | |\ \     \  /
 | |___  | |___  | | \  |  ___| | | | \ \    / /
 |_____| |_____| |_|  \_| /_____/ |_|  \_\  /_/     */

#import "HeaderView.h"

@implementation HeaderView

-(instancetype)init
{
	self = [super init];
	if (self) {
		self.userInteractionEnabled = YES;
		if (@available (iOS 11.0, *)) {
			self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		}
	}
	return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
		UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)otherGestureRecognizer;
	    CGPoint p = [pan velocityInView:pan.view];
		 CGFloat x = ABS(p.x);
		CGFloat y = ABS(p.y);
		if (y > x) {
			//纵向滚动
			return YES;
		}else{
			//横向滚动
			return NO;
		}
	}
	return NO;
}
@end
