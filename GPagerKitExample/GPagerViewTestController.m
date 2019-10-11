//
//  GPagerViewTestController.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GPagerViewTestController.h"
#import "GViewScrollPager.h"
#define XCColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XCColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define XCRandomColor XCColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface GPagerViewTestController ()<GScrollPagerDataSource>
@property (nonatomic, strong) GViewScrollPager * pager;
@end

@implementation GPagerViewTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.pager = [[GViewScrollPager alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 500)];
    self.pager.dataSource = self;
    [self.view addSubview:self.pager];
    self.pager.pageSpacing = 10;
    [self.pager registerPagerClass:UIView.class];
}


- (NSInteger)numberOfPagesInPagerView:(__kindof GBaseScrollPager *)pageScrollView;
{
    return 5;
}

- (id)pagerView:(__kindof GBaseScrollPager *)pagerView pagerForIndex:(NSInteger)pageIndex
{
    UIView * view = [pagerView dequeueReusablePager];
    if (!view) {
        view = [UIView new];
        view.backgroundColor = XCRandomColor;
    }
    return view;
}


@end
