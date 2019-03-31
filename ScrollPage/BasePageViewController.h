

/** 感谢 jyn 提供的思路*/

/*_       _____   __   _   _____   _   _   __    __
 | |     | ____| |  \ | | /  ___/ | | / /  \ \  / /
 | |     | |__   |   \| | | |___  | |/ /    \ \/ /
 | |     |  __|  | |\   | \___  \ | |\ \     \  /
 | |___  | |___  | | \  |  ___| | | | \ \    / /
 |_____| |_____| |_|  \_| /_____/ |_|  \_\  /_/     */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BasePageViewController;

@protocol PageViewControllerDelegate <NSObject>
@required
//加载当前页的控制器
-(UIViewController *)loadSubVcWithPage:(NSInteger)page;
-(NSInteger)numerOfPageWithPageViewController:(BasePageViewController *)pageVc;

@optional
//滚动到第几页
-(void)scrollToPage:(NSInteger)page;

//实现这个代理方法来监听滚动条的位置
-(void)pageScrollCurrentOffset:(CGPoint)offSet;

//用来监听纵向滚动视图滚动到什么位置
-(void)subScrollViewDidScrollOffSet:(CGPoint)offSet;

@end

@interface BasePageViewController : UIViewController



//悬停部分的高度
@property (nonatomic,assign)CGFloat overlayerHeight;
//是否显示顶部 是否让headerView 的 y > 0
@property(nonatomic,assign)BOOL isShowTop;

//初始化函数
-(instancetype)initWithHeaderView:(UIView *)headerView andDelegate:(id<PageViewControllerDelegate>)delegate;

//外部调用滚动到某个位置
-(void)pageScrollToPage:(NSInteger)page;

-(UIScrollView *)containtScrollView;

@end

NS_ASSUME_NONNULL_END
