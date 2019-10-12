//
//  UIScrollView+GStretchy.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "UIScrollView+GStretchy.h"
#import "GStretchyHeaderView.h"
#import "GStretchHeaderViewInternal.h"
@interface UIView (GStretchyHeaderViewArrangement)
- (BOOL)gsk_shouldBeBelowStretchyHeaderView;
@end

@implementation UIView (GStretchyHeaderViewArrangement)

- (BOOL)gsk_shouldBeBelowStretchyHeaderView {
    return [self isKindOfClass:[UITableViewCell class]] ||
    [self isKindOfClass:[UITableViewHeaderFooterView class]] ||
    [self isKindOfClass:[UICollectionReusableView class]];
}

@end

@implementation UIScrollView (GStretchy)
- (void)g_fixZPositionsForStretchyHeaderView:(GStretchyHeaderView *)headerView {
    headerView.layer.zPosition = 1;
    for (UIView *subview in self.subviews) {
        if (![subview gsk_shouldBeBelowStretchyHeaderView] && (subview.layer.zPosition == 0 || subview.layer.zPosition == 1)) {
            subview.layer.zPosition = 2;
        }
    }
}

- (void)g_arrangeStretchyHeaderView:(GStretchyHeaderView *)headerView {
    NSAssert(headerView.superview == self, @"The provided header view must be a subview of %@", self);
    NSUInteger stretchyHeaderViewIndex = [self.subviews indexOfObjectIdenticalTo:headerView];
    NSUInteger stretchyHeaderViewNewIndex = stretchyHeaderViewIndex;
    for (NSUInteger i = stretchyHeaderViewIndex + 1; i < self.subviews.count; ++i) {
        UIView *subview = self.subviews[i];
        if ([subview gsk_shouldBeBelowStretchyHeaderView]) {
            stretchyHeaderViewNewIndex = i;
        }
    }
    
    if (stretchyHeaderViewIndex != stretchyHeaderViewNewIndex) {
        [self exchangeSubviewAtIndex:stretchyHeaderViewIndex
                  withSubviewAtIndex:stretchyHeaderViewNewIndex];
    }
}

- (void)g_layoutStretchyHeaderView:(GStretchyHeaderView *)headerView
                       contentOffset:(CGPoint)contentOffset
               previousContentOffset:(CGPoint)previousContentOffset {
    // First of all, move the header view to the top of the visible part of the scroll view,
    // update its width if needed
    CGRect headerFrame = headerView.frame;
    headerFrame.origin.y = contentOffset.y;
    if (CGRectGetWidth(headerFrame) != CGRectGetWidth(self.bounds)) {
        headerFrame.size.width = CGRectGetWidth(self.bounds);
    }
    
    if (!headerView.manageScrollViewInsets) {
        CGFloat offsetAdjustment = headerView.maximumHeight - headerView.minimumHeight;
        contentOffset.y -= offsetAdjustment;
        previousContentOffset.y -= offsetAdjustment;
    }
    
    CGFloat headerViewHeight = CGRectGetHeight(headerView.bounds);
    switch (headerView.expansionMode) {
        case GStretchyHeaderViewExpansionModeTopOnly: {
            if (contentOffset.y + headerView.maximumHeight <= 0) { // bigger than default
                headerViewHeight = -contentOffset.y;
            } else {
                headerViewHeight = MIN(headerView.maximumHeight, MAX(-contentOffset.y, headerView.minimumHeight));
            }
            break;
        }
        case GStretchyHeaderViewExpansionModeImmediate: {
            CGFloat scrollDelta = contentOffset.y - previousContentOffset.y;
            if (contentOffset.y + headerView.maximumHeight <= 0) { // bigger than default
                headerViewHeight = -contentOffset.y;
            } else {
                headerViewHeight -= scrollDelta;
                headerViewHeight = MIN(headerView.maximumHeight, MAX(headerViewHeight, headerView.minimumHeight));
            }
            break;
        }
    }
    headerFrame.size.height = headerViewHeight;
    
    // Adjust the height of the header view depending on the content offset
    
    // If the size of the header view changes, we will need to adjust its content view
    if (!CGSizeEqualToSize(headerView.frame.size, headerFrame.size)) {
        [headerView setNeedsLayoutContentView];
    }
    headerView.frame = headerFrame;
    
    [headerView layoutContentViewIfNeeded];
}
@end
