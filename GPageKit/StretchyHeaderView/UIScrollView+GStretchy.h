//
//  UIScrollView+GStretchy.h
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GStretchyHeaderView;
@interface UIScrollView (GStretchy)

- (void)g_fixZPositionsForStretchyHeaderView:(GStretchyHeaderView *)headerView;

- (void)g_arrangeStretchyHeaderView:(GStretchyHeaderView *)headerView;
- (void)g_layoutStretchyHeaderView:(GStretchyHeaderView *)headerView
                       contentOffset:(CGPoint)contentOffset
               previousContentOffset:(CGPoint)previousContentOffset;
@end

NS_ASSUME_NONNULL_END
