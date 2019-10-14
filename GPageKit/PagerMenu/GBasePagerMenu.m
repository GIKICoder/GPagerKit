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

@interface GBasePagerMenu () <UIScrollViewDelegate>{
    struct {
        //dataSource flags
        unsigned int ds_MenuItems;
        unsigned int ds_MenuItemAtIndex;
        unsigned int ds_MenuItemSizeAtIndex;
        unsigned int ds_MenuItemSpacingAtIndex;
        
        //delegate flags
        unsigned int dg_DidSelectItem;
        unsigned int dg_DidSelectIndex;
        
    } _pagerMenuFlags;
}
@property (nonatomic, strong) GPagerMenuScrollView * scrollView;
@property (nonatomic, strong) NSArray * menuItems;
@property (nonatomic, strong) NSArray<GPagerMenuLayoutInternal *> * menuLayouts;
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

- (void)layoutSubviews
{
    self.scrollView.frame = self.bounds;
    [self __reloadLayoutMenuItems];
}

- (void)__setup
{
    [self __setupUI];
    [self __setupGesture];
}

- (void)__setupUI
{
    self.scrollView = [[GPagerMenuScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.scrollView];
    self.scrollView.frame = self.bounds;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
}

- (void)__setupGesture
{
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__tapGesture:)];
    [self.scrollView addGestureRecognizer:gesture];
}

- (void)__tapGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.scrollView];
    __weak typeof(self) weakSelf = self;
    [self.menuLayouts enumerateObjectsUsingBlock:^(GPagerMenuLayoutInternal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL temp = CGRectContainsPoint(obj.itemView.frame,point);
        if (temp) {
            [weakSelf __invokeTapDelegate:obj index:idx];
            *stop = YES;
        }
    }];
}

- (void)__invokeTapDelegate:(GPagerMenuLayoutInternal *)layout index:(NSInteger)index
{
    if (_pagerMenuFlags.dg_DidSelectItem)
        [self.delegate pagerMenu:self didSelectItem:layout.itemView];
    
    if (_pagerMenuFlags.dg_DidSelectIndex)
        [self.delegate pagerMenu:self didSelectItemAtIndex:index];
}

- (void)__clean
{
    [self.menuLayouts enumerateObjectsUsingBlock:^(GPagerMenuLayoutInternal *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj.itemView isKindOfClass:UIView.class]) {
            [obj.itemView removeFromSuperview];
        }
    }];
    self.menuLayouts = nil;
}

- (void)__setupMenuItemLayouts
{
    if (_pagerMenuFlags.ds_MenuItems) {
        self.menuItems = [self.dataSource pagerMenuItems:self];
    } else {
        return;
    }
    __weak typeof(self) weakSelf = self;
    __block NSMutableArray * layoutsM = [NSMutableArray array];
    [self.menuItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GPagerMenuLayoutInternal * layout = [GPagerMenuLayoutInternal new];
        
        if (self->_pagerMenuFlags.ds_MenuItemAtIndex) {
            UIView * menuItemView  = [weakSelf.dataSource pagerMenu:weakSelf itemAtIndex:idx];
            if (menuItemView) {
                [weakSelf.scrollView addSubview:menuItemView];
                layout.itemView = menuItemView;
            }
            if (self->_pagerMenuFlags.ds_MenuItemSizeAtIndex) {
                CGSize size = [weakSelf.dataSource pagerMenu:weakSelf itemSizeAtIndex:idx];
                layout.itemSize = size;
            }
            if (self->_pagerMenuFlags.ds_MenuItemSpacingAtIndex) {
                CGFloat sapcing = [weakSelf.dataSource pagerMenu:weakSelf itemSpacingAtIndex:idx];
                layout.itemSpace = sapcing;
            }
            [layoutsM addObject:layout];
        }
    }];
    self.menuLayouts = layoutsM.copy;
}

- (void)__reloadLayoutMenuItems
{
    __block UIView * preView = nil;
    [self.menuLayouts enumerateObjectsUsingBlock:^(GPagerMenuLayoutInternal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        {
            CGFloat width = obj.itemSize.width;
            CGFloat height = MIN(obj.itemSize.height, self.bounds.size.height);
            CGFloat left = CGRectGetMaxX(preView.frame) + obj.itemSpace;
            CGFloat top = 0.5*(self.frame.size.height-height);
            obj.itemView.frame = CGRectMake(left, top, width, height);
            obj.itemView.userInteractionEnabled = NO;
            preView = obj.itemView;
        }
    }];
    [self __layoutScrollerContentSize];
}

- (void)__layoutScrollerContentSize
{
    GPagerMenuLayoutInternal * lastMenu = [self.menuLayouts lastObject];
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastMenu.itemView.frame),self.scrollView.frame.size.height);
}

#pragma mark - Public Method

- (void)setDelegate:(id<GPagerMenuDelegate>)delegate
{
    _delegate = delegate;
    
    _pagerMenuFlags.dg_DidSelectIndex = [delegate respondsToSelector:@selector(pagerMenu:didSelectItemAtIndex:)];
    _pagerMenuFlags.dg_DidSelectItem = [delegate respondsToSelector:@selector(pagerMenu:didSelectItem:)];
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
    [self __setupMenuItemLayouts];
    [self __reloadLayoutMenuItems];
}

- (void)reloadWithIndexs:(NSArray<NSNumber *> *)indexs
{
    if (!indexs || indexs.count <= 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableArray * arrayM = self.menuLayouts.mutableCopy;
    [indexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [obj integerValue];
        if (index >= self.menuLayouts.count) {
            return;
        }
        GPagerMenuLayoutInternal * remove = [arrayM objectAtIndex:index];
        [remove.itemView removeFromSuperview];
        [arrayM removeObject:remove];
        
        GPagerMenuLayoutInternal * layout = [GPagerMenuLayoutInternal new];
        if (self->_pagerMenuFlags.ds_MenuItemAtIndex) {
            UIView * menuItemView  = [weakSelf.dataSource pagerMenu:weakSelf itemAtIndex:index];
            if (menuItemView) {
                [weakSelf.scrollView addSubview:menuItemView];
                layout.itemView = menuItemView;
            }
            if (self->_pagerMenuFlags.ds_MenuItemSizeAtIndex) {
                CGSize size = [weakSelf.dataSource pagerMenu:weakSelf itemSizeAtIndex:index];
                layout.itemSize = size;
            }
            if (self->_pagerMenuFlags.ds_MenuItemSpacingAtIndex) {
                CGFloat sapcing = [weakSelf.dataSource pagerMenu:weakSelf itemSpacingAtIndex:index];
                layout.itemSpace = sapcing;
            }
        }
        [arrayM insertObject:layout atIndex:index];
    }];
    self.menuLayouts = arrayM.copy;
    [self __reloadLayoutMenuItems];
}

- (void)scrollToRowAtIndex:(NSUInteger)index
          atScrollPosition:(GPagerMenuScrollPosition)scrollPosition
                  animated:(BOOL)animated
{
    if (index >= self.menuLayouts.count) {
        return;
    }
    switch (scrollPosition) {
        case GPagerMenuScrollPositionNone:
        {
            [self __scrollToMenuDefaultAtIndex:index animated:animated];
        }
            break;
        case GPagerMenuScrollPositionMiddle:
        case GPagerMenuScrollPositionRight:
        case GPagerMenuScrollPositionLeft:
        {
            [self __scrollToMenuPosition:scrollPosition atIndex:index animated:animated];
        }
            break;
        default:
            break;
    }
}

- (void)__scrollToMenuPosition:(GPagerMenuScrollPosition)position atIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index >= self.menuLayouts.count) {
        return;
    }
    GPagerMenuLayoutInternal * layout = [self.menuLayouts objectAtIndex:index];
    CGRect rect = layout.itemView.frame;
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat distance = 0;
    switch (position) {
        case GPagerMenuScrollPositionMiddle:
        {
            distance = (CGRectGetMidX(rect)-offset.x) - CGRectGetMidX(self.scrollView.frame);
        }
            break;
        case GPagerMenuScrollPositionLeft:
        {
            distance = (CGRectGetMinX(rect)-offset.x) - CGRectGetMinX(self.scrollView.frame);
        }
            break;
        case GPagerMenuScrollPositionRight:
        {
            distance = (CGRectGetMaxX(rect)-offset.x) - CGRectGetMaxX(self.scrollView.frame);
        }
            break;
        default:
            break;
    }
    CGFloat newOffset = (offset.x+distance);
    CGFloat maxOffset = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (newOffset >= 0 && newOffset <= maxOffset) {
        offset.x += distance;
    } else {
        if (distance < 0) {
            offset.x = 0;
        } else {
            offset.x = maxOffset;
        }
    }
    
    [self.scrollView setContentOffset:offset animated:animated];
}

- (void)__scrollToMenuDefaultAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index >= self.menuLayouts.count) {
        return;
    }
    GPagerMenuLayoutInternal * layout = [self.menuLayouts objectAtIndex:index];
    CGRect rect = layout.itemView.frame;
    [self.scrollView scrollRectToVisible:rect animated:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    CGPoint offset = self.scrollView.contentOffset;
    //    NSLog(@"offset--%f",offset);
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
