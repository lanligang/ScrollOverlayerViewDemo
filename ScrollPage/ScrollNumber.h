/*_       _____   __   _   _____   _   _   __    __
 | |     | ____| |  \ | | /  ___/ | | / /  \ \  / /
 | |     | |__   |   \| | | |___  | |/ /    \ \/ /
 | |     |  __|  | |\   | \___  \ | |\ \     \  /
 | |___  | |___  | | \  |  ___| | | | \ \    / /
 |_____| |_____| |_|  \_| /_____/ |_|  \_\  /_/     */

#import <UIKit/UIKit.h>

@interface ScrollNumber : UIView
//设置大的数字
@property (nonatomic,assign)NSInteger number;

@end


@interface ScrollNumItem : UIScrollView

@property(nonatomic,assign)NSInteger number;


@end

