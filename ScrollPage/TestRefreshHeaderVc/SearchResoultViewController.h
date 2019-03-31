//
//  SearchResoultViewController.h
//  ScrollPage
//
//  Created by ios2 on 2019/3/22.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResoultViewController : UIViewController

@property (nonatomic,strong,nullable)NSArray *dataSourceArray;

@property (nonatomic,weak)UISearchBar *searchBar;
@property (nonatomic,copy)void(^didSeletedUserBlock)(id sender);


@end

NS_ASSUME_NONNULL_END
