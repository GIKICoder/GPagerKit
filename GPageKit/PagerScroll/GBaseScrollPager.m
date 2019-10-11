//
//  GBaseScrollPager.m
//  GPageKit
//
//  Created by GIKI on 2019/9/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GBaseScrollPager.h"

// Constant Definitions
static NSString * const kGPagerDefaultPageIdentifier = @"__GPagerDefaultPageIdentifier";

@interface GBaseScrollPager ()<CAAnimationDelegate> {
    struct {
        //dataSource flags
        unsigned int dataSourceNumberOfPages;
        unsigned int dataSourcePageForIndex;
        
        //delegate flags
        unsigned int delegateWillInsertHeader;
        unsigned int delegateWillInsertFooter;
        unsigned int delegateWillJumpToIndex;
        unsigned int delegateDidTurnToIndex;
        
    } _pageScrollViewFlags;
}
@property (nonatomic, assign) NSMutableDictionary<NSString *, NSValue *> *pagerClasses;

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id> *visiblePagers;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableSet *> *recycledPageSets;

/* Works out how many slots this pager view has, including accessory views. */
@property (nonatomic, readonly) NSInteger numberOfPageSlots;

/* Returns the view displayed at the front of the pages (Whether it is the header, or headerFooter view) */
@property (nonatomic, nullable, readonly) UIView *leadingAccessoryView;

/* Returns the view displayed at the end of the pages (Whether it is the footer, or headerFooter view) */
@property (nonatomic, nullable, readonly) UIView *trailingAccessoryView;


@end

@implementation GBaseScrollPager

#pragma mark - Init Method

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        [self reloadPageScrollView];
    }
}

- (void)dealloc
{
    [self cleanup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //exit out if there's no content to display
    if (self.numberOfPages == 0) { return; }
    
    //disable the layout code since we'll be manually doing it here
    self.disablePageLayout = YES;
    
    //re-align the scroll view to our new bounds
    self.scrollView.frame           = [self frameForScrollView];
    self.scrollView.contentSize     = [self contentSizeForScrollView];
    self.scrollView.contentOffset   = [self contentOffsetForScrollViewAtIndex:self.scrollIndex];
    
    //resize any visible pages
    __weak typeof(self) weakSelf = self;
    [self.visiblePagers enumerateKeysAndObjectsUsingBlock:^(NSNumber *pageNumber, id page, BOOL *stop) {
        CGRect rect = [weakSelf frameForViewAtIndex:pageNumber.unsignedIntegerValue];
        [weakSelf __setPager:page Frame:rect];
    }];
    
    /* todo by giki
    //place the header/footer views
    if (self.headerFooterView.superview) {
        self.headerFooterView.frame = [self frameForViewAtIndex:self.headerFooterView.tag];
    }
    
    //place the header view
    if (self.headerView) {
        self.headerView.frame = [self frameForViewAtIndex:self.headerView.tag];
    }
    
    //place the footer view
    if (self.footerView) {
        self.footerView.frame = [self frameForViewAtIndex:self.footerView.tag];
    }
    */
    //re-enable the layout code
    self.disablePageLayout = NO;
}


#pragma mark - setup

- (void)setup
{
    // Default view properties
    self.autoresizingMask       = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.clipsToBounds          = YES;
    self.backgroundColor        = [UIColor clearColor];
    
    // Default layout properties
    self.pageSpacing            = 0.0f;
    self.pageScrollDirection    = GPageDirectionTurnRight;
    
    // Create the main scroll view
    self.scrollView                                 = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.pagingEnabled                   = YES;
    self.scrollView.showsHorizontalScrollIndicator  = NO;
    self.scrollView.showsVerticalScrollIndicator    = NO;
    self.scrollView.bouncesZoom                     = NO;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.scrollView];
    
    // Create an observer to monitor when the scroll view offset changes or if a parent controller tries to change
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)cleanup
{
    //remove any currently visible pages from the view
    for (NSNumber *pageIndex in self.visiblePagers.allKeys) {
        id pager = self.visiblePagers[pageIndex];
        [self __removeFromSuperview:pager];
    }
    
    //clean up the page stores
    self.visiblePagers = nil;
    self.recycledPageSets = nil;
    
    //remove the scroll view observer
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
}

#pragma mark - Observe Method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self layoutPages];
        return;
    }
    
    if ([keyPath isEqualToString:@"contentInset"]) {
        [self resetScrollViewVerticalContentInset];
        return;
    }
}

#pragma mark - Public Method

- (void)reloadPageScrollView
{
    if (!self.dataSource) {
        return;
    }
    
    /// Initialize the containers
    if(!self.pagerClasses) {
        self.pagerClasses = [NSMutableDictionary dictionary];
    }
    if (!self.visiblePagers) {
        self.visiblePagers = [NSMutableDictionary dictionary];
    }
    if (!self.recycledPageSets) {
        self.recycledPageSets = [NSMutableDictionary dictionary];
    }
    //start getting information from the data source
    self.numberOfPages = 0;
    if (_pageScrollViewFlags.dataSourceNumberOfPages) {
        self.numberOfPages = [self.dataSource numberOfPagesInPagerView:self];
    }
    /// set scrollview configure
    self.scrollView.frame = [self frameForScrollView];
    self.scrollView.contentSize = [self contentSizeForScrollView];
    self.scrollView.contentOffset = [self contentOffsetForScrollViewAtIndex:self.scrollIndex];
    
    //reset the pages
    [self resetPageLayout];
}

- (void)registerPagerClass:(Class)pagerClass
{
    NSString *identifier = kGPagerDefaultPageIdentifier;
    if ([pagerClass respondsToSelector:@selector(pageIdentifier)]) {
        identifier = [pagerClass pageIdentifier];
    }
    
    NSValue *encodedStruct = [NSValue valueWithBytes:&pagerClass objCType:@encode(Class)];
    self.pagerClasses[identifier] = encodedStruct;
}

- (nullable __kindof id)dequeueReusablePager
{
    return [self dequeueReusablePagerForIdentifier:kGPagerDefaultPageIdentifier];
}

- (nullable __kindof id)dequeueReusablePagerForIdentifier:(NSString *)identifier
{
    NSMutableSet *recycledPagesSet = self.recycledPageSets[identifier];
    id pager = recycledPagesSet.anyObject;
    
    if (pager) {
        [self __setPager:pager Frame:self.bounds];
        [recycledPagesSet removeObject:pager];
    } else if (self.pagerClasses[identifier]) {
        Class pageClass;
        [self.pagerClasses[identifier] getValue:&pageClass];
        pager = [self __constructPager:pageClass];
    }
    
    return pager;
}

/** The currently visible primary view on screen. Can be a page or accessories. */
- (nullable __kindof UIView *)visibleView
{
    // If it's an accessory view, return it
    UIView *page = self.leadingAccessoryView;
    if (page && self.scrollIndex == 0) {
        return page;
    }
    
    page = self.trailingAccessoryView;
    if (page && self.scrollIndex >= self.numberOfPageSlots-1) {
        return page;
    }
    
    //if it's a standard page, return it
    page = [self.visiblePagers objectForKey:@(self.scrollIndex)];
    if (page) {
        return page;
    }
    
    return nil;
}

- (nullable __kindof id)visiblePager
{
    return [self pagerForIndex:self.pageIndex];
}

/** The currently visible primary page view on screen. Will be nil if an acessory is visible. */
- (nullable __kindof UIView *)visiblePageView
{
    return [self pagerForIndex:self.pageIndex];
}

/** Returns the page view currently assigned to the provided index, or nil otherwise. */
- (nullable __kindof id)pagerForIndex:(NSInteger)pageIndex
{
    // Skip leading accessory view
    if (self.leadingAccessoryView && pageIndex == 0) {
        return nil;
    }
    
    // Skip trailing accessory view
    if (self.trailingAccessoryView && pageIndex >= self.numberOfPageSlots-1) {
        return nil;
    }
    
    // Return page
    id page = [self.visiblePagers objectForKey:@(pageIndex)];
    return page;
}

/** Page Navigation Checking */
- (BOOL)canGoForward
{
    return self.scrollIndex > 0;
}

- (BOOL)canGoBack
{
    return self.scrollIndex < self.numberOfPageSlots-1;
}

/** Advance/Retreat the page by one (including accessory views) */
- (void)turnToNextPageAnimated:(BOOL)animated
{
    if ([self canGoForward] == NO) {
        return;
    }
    
    NSInteger index = self.scrollIndex;
    if (self.leadingAccessoryView) {
        index--;
    }
    
    [self turnToPageAtIndex:index+1 animated:YES];
}

- (void)turnToPreviousPageAnimated:(BOOL)animated
{
    if ([self canGoBack] == NO) {
        return;
    }
    
    NSInteger index = self.scrollIndex;
    if (self.leadingAccessoryView) {
        index--;
    }
    
    [self turnToPageAtIndex:index-1 animated:YES];
}

/* Jump to a specific page (-1 for header, self.numberOfPages for footer) */
- (void)turnToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
    //verify index is valid (Still in page space and not scroll space)
    if (self.leadingAccessoryView) {
        index = MAX(-1, index);
    } else {
        index = MAX(0, index);
    }
    
    if (self.trailingAccessoryView) {
        index = MIN(self.numberOfPages, index);
    } else {
        index = MIN(self.numberOfPages-1, index);
    }
    
    //convert to scroll space
    if (self.leadingAccessoryView) {
        index++;
    }
    
    // Inform the delegate
    if (_pageScrollViewFlags.delegateWillJumpToIndex) {
        [self.delegate pagerView:self willJumpToPageAtIndex:index];
    }
    
    // If not animated, just change the offset and relayout
    if (animated == NO) {
        self.scrollView.contentOffset = [self contentOffsetForScrollViewAtIndex:index];
        [self layoutPages];
        return;
    }
    
    // Kill any existing animations
    [self.scrollView.layer removeAllAnimations];
    
    // Re-enable layouts after the animation has been killed so we can update the current state
    self.disablePageLayout = NO;
    [self layoutPages];
    
    // Before animating, disable page layout (We'll manually handle placement from here)
    self.disablePageLayout = YES;
    
    // If we're turning more than one page away, move the current page right up
    // to the side of the target page so we can have a seamless jump animation
    if (labs(index - self.scrollIndex) > 1) {
        id page = [self visibleView];
        NSInteger newIndex = 0;
        if (index > self.scrollIndex) {
            newIndex = index - 1;
        }
        else {
            newIndex = index + 1;
        }
        
        //jump to the position just before
        [UIView performWithoutAnimation:^{
            CGRect rect = [self frameForViewAtIndex:newIndex];
            [self __setPager:page Frame:rect];
            self.scrollView.contentOffset = [self contentOffsetForScrollViewAtIndex:newIndex];
        }];
    }
    
    // Update the scroll index to match the new value
    self.scrollIndex = index;
    
    // Layout the target cell
    [self layoutViewAtScrollIndex:index];
    
    // Trigger the did move to page index delegate
    if (_pageScrollViewFlags.delegateDidTurnToIndex) {
        [self.delegate pagerView:self didTurnToPageAtIndex:self.pageIndex];
    }
    
    // Set up the animation block
    id animationBlock = ^{
        self.scrollView.contentOffset = [self contentOffsetForScrollViewAtIndex:index];
    };
    
    // Set up the completion block
    id completionBlock = ^(BOOL complete) {
        // Don't relayout if we intentionally killed the animation
        if (complete == NO) { return; }
        
        //re-enable the page layout and perform a refresh
        self.disablePageLayout = NO;
        [self layoutPages];
        
        // Inform the scroll view delegate (if there is one) that the scrolling animation completed
        if (self.scrollView.delegate && [self.scrollView.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
            [self.scrollView.delegate scrollViewDidEndScrollingAnimation:self.scrollView];
        }
    };
    
    // Perform the animation
    [UIView animateWithDuration:0.35f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.3f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:animationBlock
                     completion:completionBlock];
}

#pragma mark - Private Method

- (void)resetPageLayout
{
    // Remove all pages from the hierarchy so they can be recalculated from scratch again
    [self.visiblePagers enumerateKeysAndObjectsUsingBlock: ^(NSNumber *key, id  page, BOOL *stop) {
        [self __removeFromSuperview:page];
        [[self recycledPagesSetForPage:page] addObject:page];
    }];
    [self.visiblePagers removeAllObjects];
    // Remove all accessory views
    [self.leadingAccessoryView removeFromSuperview];
    [self.trailingAccessoryView removeFromSuperview];
    
    // Perform relayout calculation
    [self layoutPages];
    
    // Inform the delegate on first run
    if (_pageScrollViewFlags.delegateDidTurnToIndex) {
        [self.delegate pagerView:self didTurnToPageAtIndex:self.pageIndex];
    }
}

- (void)layoutPages
{
    if (self.disablePageLayout || self.numberOfPages == 0) {
        return;
    }
    //Determine which pages are currently visible on screen
    CGPoint contentOffset       = self.scrollView.contentOffset;
    CGFloat scrollViewWidth     = self.scrollView.bounds.size.width;
    
    //Work out the number of slots the scroll view has (eg, pages + accessories)
    NSInteger numberOfPageSlots = self.numberOfPageSlots;
    
    //Determine the origin page on the far left
    NSRange visiblePagesRange   = NSMakeRange(0, 1);
    visiblePagesRange.location  = MAX(0, floor(contentOffset.x / scrollViewWidth));
    
    //Based on the delta between the offset of that page from the current offset, determine if the page after it is visible
    CGFloat pageOffsetDelta     = contentOffset.x - (visiblePagesRange.location * scrollViewWidth);
    visiblePagesRange.length    = fabs(pageOffsetDelta) > (self.pageSpacing * 0.5f) ? 2 : 1;
    
    //cap the values to ensure we don't go past the absolute bounds
    visiblePagesRange.location  = MAX(visiblePagesRange.location, 0);
    visiblePagesRange.location  = MIN(visiblePagesRange.location, numberOfPageSlots-1);
    
    visiblePagesRange.length    = contentOffset.x < 0.0f + FLT_EPSILON ? 1 : visiblePagesRange.length;
    visiblePagesRange.length    = (visiblePagesRange.location == numberOfPageSlots-1) ? 1 : visiblePagesRange.length;
    
    //Capture the current index we're on
    NSInteger oldPageIndex = self.pageIndex;
    
    //Work out at which index we are scrolled to (Whichever one is overlapping the middle
    self.scrollIndex = floor((self.scrollView.contentOffset.x + (scrollViewWidth * 0.5f)) / scrollViewWidth);
    self.scrollIndex = MIN(self.scrollIndex, numberOfPageSlots-1);
    self.scrollIndex = MAX(self.scrollIndex, 0);
    
    //if we're in reversed mode, swap the origin
    if (self.pageScrollDirection == GPageDirectionTurnLeft) {
        visiblePagesRange.location = (numberOfPageSlots - 1) - visiblePagesRange.location - (visiblePagesRange.length > 1 ? visiblePagesRange.length - 1 : 0);
        self.scrollIndex = (numberOfPageSlots - 1) - self.scrollIndex;
    }
    
    // Check if the page index has changed now, and if it has, inform the delegate
    NSInteger newPageIndex = self.pageIndex;
    if (oldPageIndex != newPageIndex && _pageScrollViewFlags.delegateDidTurnToIndex) {
        [self.delegate pagerView:self didTurnToPageAtIndex:newPageIndex];
    }
    
    //-------------------------------------------------------------------
    
    //work out if any visible pages need to be removed, and remove as necessary
    __block NSInteger visiblePagesCount = 0;
    NSSet *keysToRemove = [self.visiblePagers keysOfEntriesWithOptions:0 passingTest:^BOOL (NSNumber *pageNumber, id page, BOOL *stop) {
        if ([pageNumber isKindOfClass:[NSNumber class]] == NO) { return NO; }
        if (NSLocationInRange(pageNumber.unsignedIntegerValue, visiblePagesRange) == NO)
        {
            //move the page back into the recycle pool
            id page = self.visiblePagers[pageNumber];
            //give it a chance to clear itself before we remove it
            if ([page respondsToSelector:@selector(prepareForReuse)]) {
                [page performSelector:@selector(prepareForReuse)];
            }
            NSMutableSet *recycledPagesSet = [self recycledPagesSetForPage:page];
            [recycledPagesSet addObject:page];
            [self __removeFromSuperview:page];
            return YES;
        }
        
        visiblePagesCount++;
        return NO;
    }];
    [self.visiblePagers removeObjectsForKeys:[keysToRemove allObjects]];
    /*
    //if there are any accessory views, work out if they need to be removed
    //remove either headerFooter view
    if (self.headerFooterView.superview) {
        if (visiblePagesRange.location > 0 && (NSMaxRange(visiblePagesRange)-1) < numberOfPageSlots-1) {
            [self.headerFooterView removeFromSuperview];
        }
        else {
            visiblePagesCount++;
        }
    }
    
    //remove header view if necessary
    if (self.headerView.superview) {
        if (visiblePagesRange.location > 0) {
            [self.headerView removeFromSuperview];
        }
        else {
            visiblePagesCount++;
        }
    }
    
    //remove footer view if necessary
    if (self.footerView.superview)
    {
        if ((NSMaxRange(visiblePagesRange)-1) < numberOfPageSlots-1) {
            [self.footerView removeFromSuperview];
        }
        else {
            visiblePagesCount++;
        }
    }
     */
    
    //-------------------------------------------------------------------
    
    //if the number of visible pages is what we were expecting, there's no need to continue
    if (visiblePagesCount == visiblePagesRange.length)
        return;
    
    //go through and insert all new pages necessary
    for (NSInteger i = visiblePagesRange.location; i < NSMaxRange(visiblePagesRange); i++) {
        [self layoutViewAtScrollIndex:i];
    }
}

- (void)layoutViewAtScrollIndex:(NSInteger)scrollIndex
{
    NSInteger numberOfPageSlots = self.numberOfPageSlots;
    scrollIndex = MAX(0, scrollIndex);
    scrollIndex = MIN(numberOfPageSlots, scrollIndex);
    
    //add the header view
    UIView *headerView = self.leadingAccessoryView;
    if (headerView && scrollIndex == 0) {
        if (headerView.superview == nil) {
            //configure frame to match
            headerView.frame    = [self frameForViewAtIndex:0];
            headerView.tag      = 0;
            
            //inform the delegate in case it needs to update itself
            if (_pageScrollViewFlags.delegateWillInsertHeader) {
                [self.delegate pagerView:self willInsertHeaderView:headerView];
            }
            
            [self.scrollView addSubview:headerView];
        }
        
        return;
    }
    
    UIView *footerView = self.trailingAccessoryView;
    if (footerView && scrollIndex >= numberOfPageSlots-1) { //add the footer view
        if (footerView.superview == nil) {
            //configure frame to match
            footerView.frame    = [self frameForViewAtIndex:numberOfPageSlots-1];
            footerView.tag      = numberOfPageSlots-1;
            
            //inform the delegate in case it needs to update itself
            if (_pageScrollViewFlags.delegateWillInsertFooter) {
                [self.delegate pagerView:self willInsertFooterView:footerView];
            }
            
            [self.scrollView addSubview:footerView];
        }
        
        return;
    }
    
    //add as a page
    if ([self.visiblePagers objectForKey:@(scrollIndex)]) {
        return;
    }
    
    id page = nil;
    NSInteger publicIndex = self.leadingAccessoryView ? scrollIndex - 1 : scrollIndex;
    if (_pageScrollViewFlags.dataSourcePageForIndex) {
        page = [self.dataSource pagerView:self pagerForIndex:publicIndex];
    }
    if (page == nil) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Page from data source cannot be nil!" userInfo:nil];
    }
    CGRect rect = [self frameForViewAtIndex:scrollIndex];
    [self __setPager:page Frame:rect];
    [self __addSubview:page target:self.scrollView];
    [self.visiblePagers setObject:page forKey:@(scrollIndex)];
}

- (void)resetScrollViewVerticalContentInset
{
    UIEdgeInsets insets = self.scrollView.contentInset;
    if (insets.top == 0.0f && insets.bottom == 0.0f) { return; }
    
    insets.top = 0.0f;
    insets.bottom = 0.0f;
    self.scrollView.contentInset = insets;
}

- (NSMutableSet *)recycledPagesSetForPage:(UIView *)pageView
{
    // See if the page implemented an identifier, but defer to the default if not
    NSString *identifier = kGPagerDefaultPageIdentifier;
    if ([[pageView class] respondsToSelector:@selector(pageIdentifier)]) {
        identifier = [[pageView class] pageIdentifier];
    }
    
    // See if a set object already exists for that identifier. Create a new one if not
    NSMutableSet *set = self.recycledPageSets[identifier];
    if (set == nil) {
        set = [NSMutableSet set];
        self.recycledPageSets[identifier] = set;
    }
    return set;
}

#pragma mark - Accessor Method

- (NSInteger)pageIndex
{
    NSInteger pageIndex = self.scrollIndex;
    
    //subtract by one to remove the header
    if (self.leadingAccessoryView && pageIndex > 0) {
        pageIndex--;
    }
    
    //cap to the maximum number of pages (which will remove the footer)
    if (pageIndex >= self.numberOfPages) {
        pageIndex = self.numberOfPages - 1;
    }
    
    return pageIndex;
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    [self turnToPageAtIndex:pageIndex animated:NO];
}

- (void)setDelegate:(id<GScrollPagerDelegate>)delegate
{
    _delegate = delegate;
    _pageScrollViewFlags.delegateWillInsertFooter   = [_delegate respondsToSelector:@selector(pagerView:willInsertFooterView:)];
    _pageScrollViewFlags.delegateWillInsertHeader   = [_delegate respondsToSelector:@selector(pagerView:willInsertHeaderView:)];
    _pageScrollViewFlags.delegateWillJumpToIndex    = [_delegate respondsToSelector:@selector(pagerView:willJumpToPageAtIndex:)];
    _pageScrollViewFlags.delegateDidTurnToIndex     = [_delegate respondsToSelector:@selector(pagerView:didTurnToPageAtIndex:)];
}

- (void)setDataSource:(id<GScrollPagerDataSource>)dataSource
{
    _dataSource = dataSource;
    _pageScrollViewFlags.dataSourceNumberOfPages    = [_dataSource respondsToSelector:@selector(numberOfPagesInPagerView:)];
    _pageScrollViewFlags.dataSourcePageForIndex     = [_dataSource respondsToSelector:@selector(pagerView:pagerForIndex:)];
}

- (NSArray *)visiblePages
{
    return self.visiblePagers.allValues;
}

- (NSInteger)numberOfPageSlots
{
    return self.numberOfPages + (self.leadingAccessoryView ? 1 : 0) + (self.trailingAccessoryView ? 1 : 0);
}

#pragma mark - Override Method

- (void)__addSubview:(id)pager target:(UIView *)target
{}

- (void)__setPager:(id)pager Frame:(CGRect)rect
{}

- (void)__removeFromSuperview:(id)pager
{}

- (__kindof id)__constructPager:(Class)clazz
{
    return [[clazz alloc] init];
}

#pragma mark - Helper Method

- (CGRect)frameForScrollView
{
    CGRect scrollFrame      = CGRectZero;
    scrollFrame.size.width  = CGRectGetWidth(self.bounds) + self.pageSpacing;
    scrollFrame.size.height = CGRectGetHeight(self.bounds);
    scrollFrame.origin.x    = 0.0f - (self.pageSpacing * 0.5f);
    scrollFrame.origin.y    = 0.0f;
    return scrollFrame;
}

- (CGSize)contentSizeForScrollView
{
    CGSize contentSize = CGSizeZero;
    contentSize.height = CGRectGetHeight(self.bounds);
    contentSize.width  = self.numberOfPageSlots * (CGRectGetWidth(self.bounds) + self.pageSpacing);
    return contentSize;
}

- (CGPoint)contentOffsetForScrollViewAtIndex:(NSInteger)index
{
    CGPoint contentOffset = CGPointZero;
    contentOffset.y = 0.0f;
    
    if (self.pageScrollDirection == GPageDirectionTurnLeft) {
        contentOffset.x = ((self.scrollView.contentSize.width) - (CGRectGetWidth(self.scrollView.bounds) * (index+1)));
    } else {
        contentOffset.x = (CGRectGetWidth(self.scrollView.bounds) * index);
    }
    return contentOffset;
}

- (CGRect)frameForViewAtIndex:(NSInteger)index
{
    CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.bounds);
    
    CGRect pageFrame = CGRectZero;
    pageFrame.size.height   = CGRectGetHeight(self.scrollView.bounds);
    pageFrame.size.width    = scrollViewWidth - self.pageSpacing;
    pageFrame.origin        = [self contentOffsetForScrollViewAtIndex:index];
    pageFrame.origin.x      += (self.pageSpacing * 0.5f);
    return pageFrame;
}
@end
