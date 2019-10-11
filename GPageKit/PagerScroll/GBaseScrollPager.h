//
//  GBaseScrollPager.h
//  GPageKit
//
//  Created by GIKI on 2019/9/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GPageDirection) {
    GPageDirectionTurnRight,
    GPageDirectionTurnLeft,
};

@class GBaseScrollPager;

@protocol GViewPagerProtocol <NSObject>
@optional
/**
 页面重用标识
 用于页面重用
 @return Identifier
 */
+ (NSString *)pageIdentifier;

/**
 页面被重用前调用
 可在此方法中重置Datasource
 */
- (void)prepareForReuse;
@end

@protocol GScrollPagerDataSource <NSObject>

@required
/**
 返回PageView数量
 */
- (NSInteger)numberOfPagesInPagerView:(__kindof GBaseScrollPager *)pageScrollView;

/**
 返回index下的pageView or pageController
 
 @param pagerView pagerView description
 @param pageIndex pageIndex description
 @return return value description
 */
- (id)pagerView:(__kindof GBaseScrollPager *)pagerView pagerForIndex:(NSInteger)pageIndex;

@end

@protocol GScrollPagerDelegate <NSObject>
@optional

/** Informs the delegate when the page scroll view is about to move to another page, possibly far away. */
- (void)pagerView:(__kindof GBaseScrollPager *)pagerView willJumpToPageAtIndex:(NSInteger)pageIndex;

/** Informs the delegate that the page completed turning to a new  */
- (void)pagerView:(__kindof GBaseScrollPager *)pagerView didTurnToPageAtIndex:(NSInteger)pageIndex;

/** Informs the delegate that the header view is about to be inserted into the scroll view */
- (void)pagerView:(__kindof GBaseScrollPager *)pagerView willInsertHeaderView:(UIView *)headerView;

/** Informs the delegate that the footer view is about to be inserted into the scroll view */
- (void)pagerView:(__kindof GBaseScrollPager *)pagerView willInsertFooterView:(UIView *)footerView;

@end

@interface GBaseScrollPager : UIView

@property (nonatomic, weak  ) id<GScrollPagerDataSource>   dataSource;
@property (nonatomic, weak  ) id<GScrollPagerDelegate>   delegate;
@property (nonatomic, assign) CGFloat  pageSpacing;
@property (nonatomic, assign) GPageDirection  pageScrollDirection;
@property (nonatomic, assign) NSInteger  pageIndex;
@property (nonatomic, assign) NSInteger  scrollIndex;
/* A flag to temporarily disable laying out pages during animations */
@property (nonatomic, assign) BOOL disablePageLayout;
/** The number of pages in the scroll view */
@property (nonatomic, assign) NSInteger numberOfPages;

- (NSArray *)visiblePages;

/// reload all pager layouts
- (void)reloadPageScrollView;

/// registers a pager class
- (void)registerPagerClass:(Class)pagerClass;

/// return a recycled pager
- (nullable __kindof id)dequeueReusablePager;

/// return a recycled pager by identifier
- (nullable __kindof id)dequeueReusablePagerForIdentifier:(NSString *)identifier;

/** The currently visible primary view on screen. Can be a page or accessories. */
- (nullable __kindof id)visiblePager;

/** The currently visible primary page view on screen. Will be nil if an acessory is visible. */
- (nullable __kindof UIView *)visiblePageView;

/// return a recycled pager with pageindex
- (nullable __kindof id)pagerForIndex:(NSInteger)pageIndex;


- (BOOL)canGoForward;
- (BOOL)canGoBack;

/** Advance/Retreat the page by one (including accessory views) */
- (void)turnToNextPageAnimated:(BOOL)animated;
- (void)turnToPreviousPageAnimated:(BOOL)animated;

/* Jump to a specific page (-1 for header, self.numberOfPages for footer) */
- (void)turnToPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
