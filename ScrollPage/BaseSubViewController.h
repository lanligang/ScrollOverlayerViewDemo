/*_       _____   __   _   _____   _   _   __    __
 | |     | ____| |  \ | | /  ___/ | | / /  \ \  / /
 | |     | |__   |   \| | | |___  | |/ /    \ \/ /
 | |     |  __|  | |\   | \___  \ | |\ \     \  /
 | |___  | |___  | | \  |  ___| | | | \ \    / /
 |_____| |_____| |_|  \_| /_____/ |_|  \_\  /_/     */

#import <UIKit/UIKit.h>

@interface BaseSubViewController : UIViewController
//滚动视图
@property (nonatomic,strong)UIScrollView *containtScrollView;
//表头
@property (nonatomic,strong)UIView *scrollHeaderView;

//开始执行下拉刷新
-(void)begainRefresh;
//需要在子类中实现的方法
-(void)pulldownRefresh;

@end
