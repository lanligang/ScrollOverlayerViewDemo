//
//  ScrollNumber.h
//  ScrollPage
//
//  Created by ios2 on 2019/1/29.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollNumber : UIView
//设置大的数字
@property (nonatomic,assign)NSInteger number;

@end


@interface ScrollNumItem : UIScrollView

@property(nonatomic,assign)NSInteger number;


@end

