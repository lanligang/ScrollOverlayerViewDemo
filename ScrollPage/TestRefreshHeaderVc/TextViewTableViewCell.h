//
//  TextViewTableViewCell.h
//  ScrollPage
//
//  Created by ios2 on 2019/3/25.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextViewTableViewCell : UITableViewCell<UITextViewDelegate>

@property(nonatomic,weak)UITableView *tableView;
//输入的部分
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) IBOutlet UILabel *placeLable;


+(CGFloat)getHeightWithString:(UITextView *)textView;


@end

NS_ASSUME_NONNULL_END
