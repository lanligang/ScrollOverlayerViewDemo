//
//  ScrollNumber.m
//  ScrollPage
//
//  Created by ios2 on 2019/1/29.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "ScrollNumber.h"
#import "UIFont+textFont.h"

@implementation ScrollNumber
//文字滚动
-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		for (int i = 0; i< 8; i++) {
			ScrollNumItem *itemView = [[ScrollNumItem alloc]init];
			itemView.layer.borderWidth = 0.5f;
			itemView.layer.borderColor = [UIColor whiteColor].CGColor;
			itemView.tag = i + 100;
			[self addSubview:itemView];
		}
	}
	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat width = CGRectGetWidth(self.bounds);
	CGFloat height = CGRectGetHeight(self.bounds);
	for (ScrollNumItem *item in self.subviews) {
		item.frame = CGRectMake((item.tag -100) * width/8.0f, 0, width/8.0f, height);
	}
}

-(void)setNumber:(NSInteger)number
{
	_number = number;
	NSString *str = [NSString stringWithFormat:@"%ld",(long)_number];
	NSInteger  lastNum = 0;
	NSMutableArray *array = [NSMutableArray array];
	for (int i = 0; i< 8; i++) {
		if (i<(8-str.length)) {
			[array addObject:@(0)];
			lastNum = 0;
			_number = _number - lastNum*pow(10, 7-i);
		}else{
			 lastNum = _number /pow(10,(7-i));
			_number =_number - lastNum * pow(10, 7-i);
			[array addObject:@(lastNum)];
		}
	}
	for (ScrollNumItem *item in self.subviews) {
		item.number = [array[item.tag - 100] integerValue];
	}
}

@end

@implementation ScrollNumItem

-(instancetype)init
{
	self = [super init];
	if (self) {
		self.userInteractionEnabled = NO;
		[self setPagingEnabled:YES];
		for (int i = 0; i< 10; i++) {
			UILabel *lable = [UILabel new];
			lable.tag = i + 300;
			lable.text = [NSString stringWithFormat:@"%d",i];
			lable.textColor = [UIColor whiteColor];
			lable.font = [UIFont fontWithLocalName:@"UnidreamLED.ttf" andSize:30];
			lable.textAlignment = NSTextAlignmentCenter;
			[self addSubview:lable];
		}
	}
	return self;
}

-(void)setNumber:(NSInteger)number
{
	_number = number;
	CGFloat height = CGRectGetHeight(self.bounds);
	if (number == 0) {
		[self setContentOffset:CGPointMake(0, number * height) animated:NO];
	}else{
		[self setContentOffset:CGPointMake(0, number * height) animated:YES];
	}
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat width = CGRectGetWidth(self.bounds);
	CGFloat height = CGRectGetHeight(self.bounds);
	for (UIView *v  in self.subviews) {
		v.frame = CGRectMake(0, height*(v.tag -300), width, height);
	}
	self.contentSize = CGSizeMake(width, height * 10);
}

@end
