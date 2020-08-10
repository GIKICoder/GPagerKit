//
//  GStretchyHeaderView.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//
//  This code reference from GStretchyHeaderView! Thanks!
//  github: http://github.com/gskbyte

#import "GStretchyHeaderView.h"
#import "GStretchHeaderViewInternal.h"
#import "UIScrollView+GStretchy.h"
#import "UIView+GStretchy.h"

static const CGFloat kNibDefaultMaximumContentHeight = 240;

@interface GStretchyHeaderView ()

@property (nonatomic) BOOL needsLayoutContentView;
@property (nonatomic) BOOL arrangingSelfInScrollView;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic) BOOL observingScrollView;
@property (nonatomic, weak) id<GStretchyHeaderViewStretchDelegate> stretchDelegate;
@property (nonatomic) CGFloat stretchFactor;

@end

@interface GStretchyHeaderContentView : UIView
@end

@implementation GStretchyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(frame.size.height > 0, @"Initial height MUST be greater than 0");
    self = [super initWithFrame:frame];
    if (self) {
        self.maximumContentHeight = self.frame.size.height;
        [self setupView];
        [self setupContentView];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
        [self setupContentView];
    }
    return self;
}

- (void)setupView {
    self.clipsToBounds = YES;
    self.minimumContentHeight = 0;
    self.contentAnchor = GStretchyHeaderViewContentAnchorTop;
    self.contentExpands = YES;
    self.contentShrinks = YES;
    self.manageScrollViewInsets = YES;
    self.manageScrollViewSubviewHierarchy = YES;
}

- (void)setupContentView {
    _contentView = [[GStretchyHeaderContentView alloc] initWithFrame:self.bounds];
    [self g_transplantSubviewsToView:_contentView];
    [self addSubview:_contentView];
    [self setNeedsLayoutContentView];
}

#pragma mark - Public properties

- (void)setExpansionMode:(GStretchyHeaderViewExpansionMode)expansionMode {
    _expansionMode = expansionMode;
    [self.scrollView g_layoutStretchyHeaderView:self
                                    contentOffset:self.scrollView.contentOffset
                            previousContentOffset:self.scrollView.contentOffset];
}

- (void)setMaximumContentHeight:(CGFloat)maximumContentHeight {
    if (maximumContentHeight == _maximumContentHeight) {
        return;
    }
    
    _maximumContentHeight = maximumContentHeight;
    [self setupScrollViewInsetsIfNeeded];
    [self.scrollView g_layoutStretchyHeaderView:self
                                    contentOffset:self.scrollView.contentOffset
                            previousContentOffset:self.scrollView.contentOffset];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setupScrollViewInsetsIfNeeded];
}

#pragma mark - Public methods

/// 设置HeaderView 高度, 并且重置ScrollView的offset
/// @param maximumContentHeight HeaderView 高度
/// @param animated <#animated description#>
- (void)setMaximumContentHeight:(CGFloat)maximumContentHeight
                  resetAnimated:(BOOL)animated {
    self.maximumContentHeight = maximumContentHeight;
    [self.scrollView setContentOffset:CGPointMake(0, -(self.maximumContentHeight + self.contentInset.top)) animated:animated];
}


/// 只更新headerView 高度. 不改变相对位置.
/// @param maximumContentHeight 需要更新的headerView高度
/// @param animated animated description
- (void)updateMaximumContentHeight:(CGFloat)maximumContentHeight animation:(BOOL)animated
{
    CGFloat diff = self.maximumContentHeight - maximumContentHeight;
    CGPoint offset = self.scrollView.contentOffset;
    self.maximumContentHeight = maximumContentHeight; //
    [self.scrollView setContentOffset:CGPointMake(offset.x, (diff+offset.y)) animated:animated];
}

/// 只更新headerView 高度. 不改变相对位置.
/// @param maximumContentHeight 需要更新的headerView高度
/// @param diffOffset 内部控件需要改变的相对位置,增加- 减少+
/// @param animated <#animated description#>
- (void)updateMaximumContentHeight:(CGFloat)maximumContentHeight offset:(CGFloat)diffOffset animation:(BOOL)animated
{
    CGPoint offset = self.scrollView.contentOffset;
    self.maximumContentHeight = maximumContentHeight; //diff+
    [self.scrollView setContentOffset:CGPointMake(offset.x, (diffOffset+offset.y)) animated:animated];
}

#pragma mark - Overriden methods

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.maximumContentHeight == 0) {
        NSLog(@"'maximumContentHeight' not defined for %@, setting default (%@)",
              NSStringFromClass(self.class),
              @(kNibDefaultMaximumContentHeight));
        self.maximumContentHeight = kNibDefaultMaximumContentHeight;
    }
}

// we have to stop observing the scroll view before it gets deallocated
// willMoveToSuperview: happens too late
- (void)willMoveToWindow:(nullable UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        [self observeScrollViewIfPossible];
    } else {
        [self stopObservingScrollView];
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (!self.manageScrollViewSubviewHierarchy) {
        return;
    }
    
    if (@available(iOS 11.0, *)) { // it has to be used like this :/
        [self.scrollView g_fixZPositionsForStretchyHeaderView:self];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview != self.scrollView) {
        [self stopObservingScrollView];
        self.scrollView = nil;
    }
    
    if (![self.superview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    self.scrollView = (UIScrollView *)self.superview;
    [self observeScrollViewIfPossible];
    
    [self setupScrollViewInsetsIfNeeded];
}

- (void)observeScrollViewIfPossible {
    if (self.scrollView == nil || self.observingScrollView) {
        return;
    }
    
    [self.scrollView addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(contentOffset))
                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.scrollView.layer addObserver:self
                            forKeyPath:NSStringFromSelector(@selector(sublayers))
                               options:NSKeyValueObservingOptionNew
                               context:nil];
    self.observingScrollView = YES;
}

- (void)removeFromSuperview {
    [self stopObservingScrollView];
    
    [super removeFromSuperview];
}

- (void)stopObservingScrollView {
    if (!self.observingScrollView) {
        return;
    }
    
    [self.scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    [self.scrollView.layer removeObserver:self forKeyPath:NSStringFromSelector(@selector(sublayers))];
    
    self.observingScrollView = NO;
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSString *, NSValue *> *)change
                       context:(nullable void *)context {
    if (object == self.scrollView) {
        if (![keyPath isEqualToString:@"contentOffset"]) {
            NSAssert(NO, @"keyPath '%@' is not being observed", keyPath);
        }
        
        CGPoint contentOffset = change[NSKeyValueChangeNewKey].CGPointValue;
        NSLog(@"observeValueForKeyPath - %@",NSStringFromCGPoint(contentOffset));
        CGPoint previousContentOffset = change[NSKeyValueChangeOldKey].CGPointValue;
        [self.scrollView g_layoutStretchyHeaderView:self
                                        contentOffset:contentOffset
                                previousContentOffset:previousContentOffset];
    } else if (object == self.scrollView.layer) {
        if (![keyPath isEqualToString:@"sublayers"]) {
            NSAssert(NO, @"keyPath '%@' is not being observed", keyPath);
        }
        
        if (!self.arrangingSelfInScrollView && self.manageScrollViewSubviewHierarchy) {
            self.arrangingSelfInScrollView = YES;
            [self.scrollView g_arrangeStretchyHeaderView:self];
            self.arrangingSelfInScrollView = NO;
        }
    }
}

#pragma mark - Private properties and methods

- (CGFloat)verticalInset {
    return self.contentInset.top + self.contentInset.bottom;
}

- (CGFloat)horizontalInset {
    return self.contentInset.left + self.contentInset.right;
}

- (CGFloat)maximumHeight {
    return self.maximumContentHeight + self.verticalInset;
}

- (CGFloat)minimumHeight {
    return self.minimumContentHeight + self.verticalInset;
}

- (void)setupScrollViewInsetsIfNeeded {
    if (self.scrollView && self.manageScrollViewInsets) {
        UIEdgeInsets scrollViewContentInset = self.scrollView.contentInset;
        scrollViewContentInset.top = self.maximumContentHeight + self.contentInset.top + self.contentInset.bottom;
        self.scrollView.contentInset = scrollViewContentInset;
    }
}

- (void)setNeedsLayoutContentView {
    self.needsLayoutContentView = YES;
}

- (void)layoutContentViewIfNeeded {
    if (!self.needsLayoutContentView) {
        return;
    }
    
    const CGFloat ownHeight = CGRectGetHeight(self.bounds);
    const CGFloat ownWidth = CGRectGetWidth(self.bounds);
    const CGFloat contentHeightDif = (self.maximumContentHeight - self.minimumContentHeight);
    const CGFloat maxContentViewHeight = ownHeight - self.verticalInset;
    
    CGFloat contentViewHeight = maxContentViewHeight;
    if (!self.contentExpands) {
        contentViewHeight = MIN(contentViewHeight, self.maximumContentHeight);
    }
    if (!self.contentShrinks) {
        contentViewHeight = MAX(contentViewHeight, self.maximumContentHeight);
    }
    
    CGFloat contentViewTop;
    switch (self.contentAnchor) {
        case GStretchyHeaderViewContentAnchorTop: {
            contentViewTop = self.contentInset.top;
            break;
        }
        case GStretchyHeaderViewContentAnchorBottom: {
            contentViewTop = ownHeight - contentViewHeight;
            if (!self.contentExpands) {
                contentViewTop = MIN(0, contentViewTop);
            }
            break;
        }
    }
    self.contentView.frame = CGRectMake(self.contentInset.left,
                                        contentViewTop,
                                        ownWidth - self.horizontalInset,
                                        contentViewHeight);
    
    CGFloat newStretchFactor = (maxContentViewHeight - self.minimumContentHeight) / contentHeightDif;
    if (newStretchFactor != self.stretchFactor) {
        self.stretchFactor = newStretchFactor;
        [self didChangeStretchFactor:newStretchFactor];
        [self.stretchDelegate stretchyHeaderView:self didChangeStretchFactor:newStretchFactor];
    }
    
    self.needsLayoutContentView = NO;
}

#pragma mark - Stretch factor

- (void)didChangeStretchFactor:(CGFloat)stretchFactor {
    // to be implemented in subclasses
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutContentViewIfNeeded];
}

- (void)contentViewDidLayoutSubviews {
    // default implementation does not do anything
}

@end

@implementation GStretchyHeaderContentView

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self.superview isKindOfClass:[GStretchyHeaderView class]]) {
        [(GStretchyHeaderView *)self.superview contentViewDidLayoutSubviews];
    }
}

@end

