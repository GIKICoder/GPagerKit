//
//  GStretchHeaderViewInternal.h
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

@interface GStretchyHeaderView ()

@property (nonatomic, readonly) CGFloat verticalInset;
@property (nonatomic, readonly) CGFloat horizontalInset;
@property (nonatomic, readonly) CGFloat maximumHeight;
@property (nonatomic, readonly) CGFloat minimumHeight;

- (void)setNeedsLayoutContentView;
- (void)layoutContentViewIfNeeded;

@end
