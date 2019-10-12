//
//  GBasePagerMenu.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GBasePagerMenu.h"
@interface GPagerMenuScrollView : UIScrollView
@end

@interface GPagerMenuLayoutInternal : NSObject
@property (nonatomic, strong) UIView * itemView;
@property (nonatomic, assign) CGSize  itemSize;
@property (nonatomic, assign) CGFloat  itemSpace;
@end

@interface GBasePagerMenu () {
    struct {
        //dataSource flags
        unsigned int ds_MenuItems;
        unsigned int ds_MenuItemAtIndex;
        unsigned int ds_MenuItemSizeAtIndex;
        unsigned int ds_MenuItemSpacingAtIndex;
        
        //delegate flags
        unsigned int dg_DidSelectItem;
        
    } _pagerMenuFlags;
}
@property (nonatomic, strong) GPagerMenuScrollView * scrollView;
@property (nonatomic, strong) NSArray * menuItems;
@property (nonatomic, strong) NSMutableArray * menuViewsM;
@end

@implementation GBasePagerMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self __setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self __setup];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)__setup
{
    self.menuViewsM = [NSMutableArray array];
    [self __setupUI];
}

- (void)__setupUI
{
    self.scrollView = [[GPagerMenuScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.scrollView];
}

- (void)__clean
{
    [self.menuViewsM enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:UIView.class]) {
            [obj removeFromSuperview];
        }
    }];
    [self.menuViewsM removeAllObjects];
}

- (void)__reloadLayoutMenuItems
{
    __weak typeof(self) weakSelf = self;
    [self.menuItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self->_pagerMenuFlags.ds_MenuItemAtIndex) {
            UIView * menuItemView  = [weakSelf.dataSource pagerMenu:weakSelf itemAtIndex:idx];
            if (menuItemView) {
                [weakSelf.scrollView addSubview:menuItemView];
                [weakSelf.menuViewsM addObject:menuItemView];
            }
        }
        if (self->_pagerMenuFlags.ds_MenuItemSizeAtIndex) {
            CGSize size = [weakSelf.dataSource pagerMenu:weakSelf itemSizeAtIndex:idx];
        }
    }];
}

#pragma mark - Public Method

- (void)setDelegate:(id<GPagerMenuDelegate>)delegate
{
    _delegate = delegate;
    
    _pagerMenuFlags.dg_DidSelectItem = [delegate respondsToSelector:@selector(pagerMenu:didSelectItemAtIndex:)];
}

- (void)setDataSource:(id<GPagerMenuDataSource>)dataSource
{
    _dataSource = dataSource;
    
    _pagerMenuFlags.ds_MenuItems = [dataSource respondsToSelector:@selector(pagerMenuItems:)];
    _pagerMenuFlags.ds_MenuItemAtIndex = [dataSource respondsToSelector:@selector(pagerMenu:itemAtIndex:)];
    _pagerMenuFlags.ds_MenuItemSizeAtIndex = [dataSource respondsToSelector:@selector(pagerMenu:itemSizeAtIndex:)];
    _pagerMenuFlags.ds_MenuItemSpacingAtIndex = [dataSource respondsToSelector:@selector(pagerMenu:itemSpacingAtIndex:)];
}

- (void)reloadData
{
    [self __clean];
    [self __reloadLayoutMenuItems];
}

- (void)reloadWithIndexs:(NSArray<NSNumber *> *)indexs
{
    
}

- (void)selectMenuItemAtIndex:(NSUInteger)index
{
    
}
@end





@implementation GPagerMenuScrollView
/**
 Fiexd: 当手指长按按钮时无法滑动scrollView的问题
 */
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}
@end

@implementation GPagerMenuLayoutInternal

@end
