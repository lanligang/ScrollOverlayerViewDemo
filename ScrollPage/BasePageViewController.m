/*_       _____   __   _   _____   _   _   __    __
 | |     | ____| |  \ | | /  ___/ | | / /  \ \  / /
 | |     | |__   |   \| | | |___  | |/ /    \ \/ /
 | |     |  __|  | |\   | \___  \ | |\ \     \  /
 | |___  | |___  | | \  |  ___| | | | \ \    / /
 |_____| |_____| |_|  \_| /_____/ |_|  \_\  /_/     */

#import "BasePageViewController.h"
#import "BgScrollView.h"
#define SUBVIEW_TAG 1024

@interface BasePageViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)BgScrollView *bgScrollView;
@property (nonatomic,weak)id <PageViewControllerDelegate>delegate;
@property (nonatomic,assign)CGFloat headerMaxHeight;

@end

@implementation BasePageViewController
-(instancetype)initWithHeaderView:(UIView *)headerView andDelegate:(id<PageViewControllerDelegate>)delegate
{
	self = [super init];
	if (self) {
		_headerView = headerView;
		self.delegate = delegate;
	}
	return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

	[self.view addSubview:self.bgScrollView];
	_bgScrollView.delegate = self;
	_bgScrollView.frame = self.view.bounds;
	_bgScrollView.tag = 2000;
	NSInteger pageCount = [self.delegate numerOfPageWithPageViewController:self];
	_bgScrollView.contentSize = (CGSize){CGRectGetWidth(self.view.frame)*pageCount, 0};
	[self.view addSubview:self.headerView];
	self.headerMaxHeight = CGRectGetHeight(_headerView.frame) - self.overlayerHeight;
	if (@available (iOS 11.0, *)) {
		_bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	[_bgScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];

	[self loadSubViewControllerWithPage:0];

	[_bgScrollView addSubview:_headerView];
}

-(void)pageScrollToPage:(NSInteger)page
{
	CGFloat width = CGRectGetWidth(_bgScrollView.bounds);
	NSInteger maxPage = [self.delegate numerOfPageWithPageViewController:self];
	//取绝对值
	page = ABS(page) % maxPage;
	if ([self.delegate respondsToSelector:@selector(scrollToPage:)]){
		[self.delegate scrollToPage:page];
	}
	//动画滚动到某一页
	[_bgScrollView setContentOffset:CGPointMake(page *width, 0) animated:YES];
	[self loadSubViewControllerWithPage:page];
	[_bgScrollView bringSubviewToFront:_headerView];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	NSInteger page = (scrollView.contentOffset.x + CGRectGetWidth(scrollView.bounds)/2.0) / CGRectGetWidth(scrollView.bounds);
	[self loadSubViewControllerWithPage:page];
	if ([self.delegate respondsToSelector:@selector(scrollToPage:)]){
		[self.delegate scrollToPage:page];
	}
	[_bgScrollView bringSubviewToFront:_headerView];
	__weak typeof(self)ws = self;
		//在这里修改手势保留只有一个手势存在
	[self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UIScrollView *ascrollView = [self foundScrollViewWithViewController:obj];
		if (obj.view.tag == page + SUBVIEW_TAG) {
			[ws.bgScrollView addGestureRecognizer:ascrollView.panGestureRecognizer];
		}else {
			[ws.bgScrollView removeGestureRecognizer:ascrollView.panGestureRecognizer];
			[ascrollView addGestureRecognizer:ascrollView.panGestureRecognizer];
		}
	}];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self changeFrame];
}
-(void)changeFrame
{
	_bgScrollView.frame = self.view.bounds;
	
	NSInteger pageCount = [self.delegate numerOfPageWithPageViewController:self];
	
	_bgScrollView.contentSize = (CGSize){CGRectGetWidth(self.view.frame)*pageCount,
		0};
	__weak typeof(self)ws = self;
	[_bgScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj != ws.headerView) {
			obj.frame =(CGRect){obj.frame.origin,ws.view.frame.size};
		}
	}];
}
-(void)pageScrollViewDidScroll:(UIScrollView *)scrollView
{
	NSInteger page = (scrollView.contentOffset.x + CGRectGetWidth(scrollView.bounds)/2.0) / CGRectGetWidth(scrollView.bounds);
	//[self loadSubViewControllerWithPage:page];

	//调用外部
	if ([self.delegate respondsToSelector:@selector(pageScrollCurrentOffset:)]) {
		[self.delegate pageScrollCurrentOffset:scrollView.contentOffset];
	}

	_headerView.frame = CGRectMake(scrollView.contentOffset.x, CGRectGetMinY(_headerView.frame), CGRectGetWidth(_headerView.frame), CGRectGetHeight(_headerView.frame));
	[scrollView bringSubviewToFront:_headerView];
	//调用外部实现滚动到第几页
	__weak typeof(self)ws = self;
		//在这里修改手势保留只有一个手势存在
	[self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UIScrollView *ascrollView = [self foundScrollViewWithViewController:obj];
		if (obj.view.tag == page + SUBVIEW_TAG) {
			[ws.bgScrollView addGestureRecognizer:ascrollView.panGestureRecognizer];
		}else {
			[ws.bgScrollView removeGestureRecognizer:ascrollView.panGestureRecognizer];
			[ascrollView addGestureRecognizer:ascrollView.panGestureRecognizer];
		}
	}];
}

-(void)loadSubViewControllerWithPage:(NSInteger)page
{
	UIView *subV = [_bgScrollView viewWithTag:SUBVIEW_TAG + page];
	if (subV != nil) return;
	if ([self.delegate respondsToSelector:@selector(loadSubVcWithPage:)]) {
		UIViewController *vc = [self.delegate loadSubVcWithPage:page];
		UIScrollView *scrollView = [self foundScrollViewWithViewController:vc];
		if (scrollView != nil) {
			vc.view.tag = SUBVIEW_TAG + page;
			[self addChildViewController:vc];
			[_bgScrollView addSubview:vc.view];
			if (page == 0) {
				[_bgScrollView addGestureRecognizer:scrollView.panGestureRecognizer];
			}else {
			      UIViewController *firstVc =  self.childViewControllers.firstObject;
				UIScrollView *firstScrollView = [self foundScrollViewWithViewController:firstVc];
				CGFloat offSetY = firstScrollView.contentOffset.y;

				if (offSetY >= self.headerMaxHeight) {
					if (scrollView.contentOffset.y < self.headerMaxHeight)
						scrollView.contentOffset = CGPointMake(0, self.headerMaxHeight);
				}else if (offSetY >= 0 && offSetY < self.headerMaxHeight) {
					if(scrollView.contentOffset.y != offSetY){
						scrollView.contentOffset = CGPointMake(0, offSetY);
					}
				}else if (offSetY < 0) {
					if (scrollView.contentOffset.y > 0)
						scrollView.contentOffset = CGPointMake(0, 0);
				}
				
			}
			CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
			vc.view.frame = CGRectMake(page * screenWidth,0,screenWidth,CGRectGetHeight(_bgScrollView.bounds));
			//移除监听 添加监听
			[scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
		}
	}
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if (_bgScrollView == object) {
		[self pageScrollViewDidScroll:_bgScrollView];
		return;
	}
	if ([keyPath isEqualToString:@"contentOffset"]) {
		UIScrollView *scrollView = (UIScrollView *)object;
		CGFloat offSetY = scrollView.contentOffset.y;
		if (offSetY >= self.headerMaxHeight) {
			if (self.headerView.frame.origin.y != -self.headerMaxHeight) {
				self.headerView.frame = CGRectMake(_headerView.frame.origin.x, - self.headerMaxHeight, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
			}
		}else if (offSetY >= 0 && offSetY <(self.headerMaxHeight - 0.1)) {
			self.headerView.frame = CGRectMake(_headerView.frame.origin.x, - offSetY, CGRectGetWidth(self.headerView.frame),CGRectGetHeight(self.headerView.frame));
		}else if (offSetY < 0){
			if (self.isShowTop) {
				  self.headerView.frame = CGRectMake(_headerView.frame.origin.x, -offSetY, CGRectGetWidth(self.headerView.frame),CGRectGetHeight(self.headerView.frame));
			}
		}
		//通过代理告知外部滚动结果
		if ([self.delegate respondsToSelector:@selector(subScrollViewDidScrollOffSet:)]) {
			[self.delegate subScrollViewDidScrollOffSet:scrollView.contentOffset];
		}
		__weak typeof(self)ws = self;
		[self.childViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			UIViewController* childVC = (UIViewController *)obj;
			UIScrollView * scrollView = [ws foundScrollViewWithViewController:childVC];
			if (offSetY >= ws.headerMaxHeight) {
				if (scrollView.contentOffset.y < ws.headerMaxHeight)
					scrollView.contentOffset = CGPointMake(0, ws.headerMaxHeight);
			}else if (offSetY >= 0 && offSetY < ws.headerMaxHeight) {
				if(scrollView.contentOffset.y != offSetY)
					scrollView.contentOffset = CGPointMake(0, offSetY);
			}else if (offSetY < 0) {
				if (scrollView.contentOffset.y > 0)
					scrollView.contentOffset = CGPointMake(0, 0);
			}
		}];
	}
}

//查找当前View 当中的滚动试图
-(UIScrollView *)foundScrollViewWithViewController:(UIViewController *)vc
{
	__block UIScrollView *scrollView = nil;
	[vc.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj isKindOfClass:[UIScrollView class]]) {
			*stop = YES;
			scrollView  = obj;
		}
	}];
	return scrollView;
}

-(void)dealloc
{
	NSLog(@"内存释放了");
	//移除监听
	[_bgScrollView removeObserver:self forKeyPath:@"contentOffset"];

	for (UIViewController *vc  in self.childViewControllers) {
		UIScrollView *scrollView =  [self foundScrollViewWithViewController:vc];
		if (scrollView) {
			[scrollView removeObserver:self forKeyPath:@"contentOffset"];
		}
	}
	_bgScrollView = nil;
}

//lazy load
-(BgScrollView *)bgScrollView
{
	if (!_bgScrollView)
	{
		_bgScrollView = [[BgScrollView alloc]init];
		_bgScrollView.pagingEnabled = YES;
	   [_bgScrollView setBounces:NO];
		_bgScrollView.showsHorizontalScrollIndicator = NO;
		_bgScrollView.showsVerticalScrollIndicator = NO;
	}
	return _bgScrollView;
}
-(UIScrollView *)containtScrollView
{
	__weak UIScrollView *scrollView = self.bgScrollView;
	return scrollView;
}



@end
