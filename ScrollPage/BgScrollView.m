//
//  BgScrollView.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/14.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "BgScrollView.h"

@implementation BgScrollView
- (instancetype)init
{
	self = [super init];
	if (self) {
		
	}
	return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return NO;
}

-(void)dealloc
{
	NSLog(@"同样释放");
}


@end
