//
//  GBaseScrollPager.h
//  GPageKit
//
//  Created by GIKI on 2019/9/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GPageDirection) {
    GPageDirectionTurnRight,
    GPageDirectionTurnLeft,
};

@class GBaseScrollPager;

@interface NSObject (PageIdentifier)
@property (nonatomic, copy) NSString * pageIdentifier;
@end

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

/**  move to another page */
- (void)pagerView:(__kindof GBaseScrollPager *)pagerView willJumpToPageAtIndex:(NSInteger)pageIndex;

/** completed turning to a new page */
- (void)pagerView:(__kindof GBaseScrollPager *)pagerView didTurnToPageAtIndex:(NSInteger)pageIndex;

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
- (void)registerPagerClass:(Class)pagerClass identifier:(NSString *)identifier;

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
