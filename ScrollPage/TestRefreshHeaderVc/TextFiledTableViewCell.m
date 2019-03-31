//
//  TextFiledTableViewCell.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/26.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "TextFiledTableViewCell.h"

@implementation TextFiledTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.inputTextFiled.delegate = self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if (_myTbaleView) {
		NSIndexPath *indexPath = [_myTbaleView indexPathForCell:self];
		[_myTbaleView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
	return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
