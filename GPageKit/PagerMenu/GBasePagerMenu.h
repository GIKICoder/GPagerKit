//
//  GBasePagerMenu.h
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GBasePagerMenu;
@protocol GPagerMenuDataSource <NSObject>
@required
- (nullable __kindof UIView *)pagerMenu:(GBasePagerMenu *)menu itemAtIndex:(NSUInteger)index;
@optional
- (NSArray *)pagerMenuItems:(GBasePagerMenu *)menu;
- (CGSize)pagerMenu:(GBasePagerMenu *)menu itemSizeAtIndex:(NSUInteger)index;
- (CGFloat)pagerMenu:(GBasePagerMenu *)menu itemSpacingAtIndex:(NSUInteger)index;
@end

@protocol GPagerMenuDelegate <NSObject>
@optional
- (void)pagerMenu:(GBasePagerMenu *)menu didSelectItemAtIndex:(NSUInteger)index;
@end

typedef NS_ENUM(NSInteger, GPagerMenuScrollPosition) {
    GPagerMenuScrollPositionNone,
    GPagerMenuScrollPositionLeft,
    GPagerMenuScrollPositionMiddle,
    GPagerMenuScrollPositionRight
};

@interface GPagerMenuLayoutInternal : NSObject
@property (nonatomic, strong) UIView * itemView;
@property (nonatomic, assign) CGSize  itemSize;
@property (nonatomic, assign) CGFloat  itemSpace;
@property (nonatomic, assign) BOOL  isSelected;
@end

@interface GBasePagerMenu : UIView

@property (nonatomic, strong, readonly) __kindof UIScrollView * scrollView;
@property (nonatomic, strong, readonly) NSArray<id> * menuItems;
@property (nonatomic, strong, readonly) NSArray<GPagerMenuLayoutInternal *> * menuLayouts;
@property (nonatomic, weak  ) id<GPagerMenuDataSource>   dataSource;
@property (nonatomic, weak  ) id<GPagerMenuDelegate>     delegate;

@property (nonatomic, assign) CGFloat    itemSpacing;
@property (nonatomic, assign) CGSize     itemSize;
@property (nonatomic, assign) NSInteger  selectIndex;

- (void)reloadData;
- (void)reloadWithIndexs:(NSArray<NSNumber *> *)indexs;

- (void)reloadMenuLayout;

- (void)scrollToRowAtIndex:(NSUInteger)index
          atScrollPosition:(GPagerMenuScrollPosition)scrollPosition
                  animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
