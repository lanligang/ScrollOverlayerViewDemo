//
//  TextViewTableViewCell.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/25.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "TextViewTableViewCell.h"

@implementation TextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_noteTextView.delegate = self;
}
- (void)textViewDidChange:(UITextView *)textView
{
	if (textView.text.length >0) {
		self.placeLable.hidden = YES;
	}else{
		self.placeLable.hidden = NO;
	}
	if (textView.markedTextRange) {
		return;
	}
	if (_tableView) {
			if (@available(iOS 11.0, *)) {
				[self.tableView performBatchUpdates:^{
				} completion:^(BOOL finished) {
					if (finished) {
						NSIndexPath *aIndexPath =  [self.tableView indexPathForCell:self];
						[self.tableView scrollToRowAtIndexPath:aIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
						[textView scrollRangeToVisible:NSMakeRange(0, textView.text.length)];
					}
				}];
			} else {
				[self.tableView beginUpdates];
				[self.tableView endUpdates];
				NSIndexPath *aIndexPath =  [self.tableView indexPathForCell:self];
				[self.tableView scrollToRowAtIndexPath:aIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
				[textView scrollRangeToVisible:NSMakeRange(0, textView.text.length)];
			}
	}
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if (_tableView) {
		[self performSelector:@selector(scrrooToBottom) withObject:nil afterDelay:0.2];
	}
	return YES;
}
-(void)scrrooToBottom
{
	NSIndexPath *aIndexPath =  [self.tableView indexPathForCell:self];
	[self.tableView scrollToRowAtIndexPath:aIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


+(CGFloat)getHeightWithString:(UITextView *)textView
{
	CGFloat width = CGRectGetWidth(textView.bounds);
	CGSize size = [textView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
	return size.height + 60 + 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
