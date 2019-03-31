//
//  NSObject+LgObserver.m
//  ScrollTableDemo
//
//  Created by ios2 on 2018/12/13.
//  Copyright © 2018 LenSky. All rights reserved.
//

#import "NSObject+LgObserver.h"
#import <objc/runtime.h>

static  char lg_ObserverKey = '\0';

@implementation NSObject (LgObserver)

-(void)setLgOberVer:(LgOberver *)lgOberVer
{
	[self willChangeValueForKey:@"lgOberVer"];
	objc_setAssociatedObject(self, &lg_ObserverKey, lgOberVer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"lgOberVer"];
}
-(LgOberver *)lgOberVer
{
	LgOberver *observer = objc_getAssociatedObject(self, &lg_ObserverKey);
	if (!observer) {
		observer = [[LgOberver alloc]init];
		//设置观察者的被观察对象
		[observer setValue:self forKey:@"observed"];
		self.lgOberVer = observer;
	}
	return objc_getAssociatedObject(self, &lg_ObserverKey);
}

@end

@interface LgOberver ()
@property (nonatomic,weak)id observed;
@end
@implementation LgOberver

-(instancetype)init
{
	self = [super init];
	if (self) {
		_keyCacheArray = [NSMutableArray array];
	}
	return self;
}
//添加观察
-(LgOberver *(^)(NSString *))addObserverKey
{
	__weak typeof(self)ws = self;
	return ^(NSString *key){
		__strong typeof(ws) ss = ws;
		[ss.observed addObserver:ss forKeyPath:key options:NSKeyValueObservingOptionOld |NSKeyValueObservingOptionNew  context:nil];
		[ss->_keyCacheArray addObject:key];
		return self;
	};
}
//移除观察
-(LgOberver *(^)(NSString *))removeObserverKey
{
	__weak typeof(self)ws = self;
	return ^(NSString *key){
		__strong typeof(ws)ss = ws;
		[ss.observed removeObserver:ss forKeyPath:key];
		[ss->_keyCacheArray removeObject:key];
		return self;
	};
}
-(LgOberver*(^)(id))changeObserved
{
	__weak typeof(self)ws = self;
	return ^(id newObj){
		__strong typeof(ws)ss = ws;
		for (NSString *key in ss->_keyCacheArray) {
			[ss.observed removeObserver:ss forKeyPath:key];
		}
		[ss setDidChageMsg:nil];
		ss.observed = newObj;
		return self;
	};
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if (self.observed) {
		if (self.didChageMsg) {
			self.didChageMsg(@{
							  lgMsgKey:keyPath,
							   @"change":change});
		}
	}
}
-(void)dealloc
{
	for (NSString *key in self.keyCacheArray) {
		[self.observed removeObserver:self forKeyPath:key];
	}
}





@end
