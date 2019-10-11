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

@interface GBasePagerMenu ()
@property (nonatomic, strong) GPagerMenuScrollView * scrollView;
@property (nonatomic, strong) NSArray * menuItems;
@property (nonatomic, strong) NSArray * menuViews;
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
    [self __setupUI];
}

- (void)__setupUI
{
    self.scrollView = [[GPagerMenuScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.scrollView];
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
