//
//  TextFiledTableViewCell.h
//  ScrollPage
//
//  Created by ios2 on 2019/3/26.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFiledTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topTitleLable;
@property (weak, nonatomic) IBOutlet UITextField *inputTextFiled;
@property(nonatomic,weak)UITableView *myTbaleView;

@end

