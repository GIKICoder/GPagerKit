//
//  GPagerVCTestViewController.m
//  GPageKit
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GPagerVCTestViewController.h"
#import "GControllerScrollPager.h"
@interface GPagerVCTestViewController ()<GScrollPagerDataSource>
@property (nonatomic, strong) GControllerScrollPager * pager;
@end
#define XCColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XCColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define XCRandomColor XCColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@implementation GPagerVCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
        self.pager = [[GControllerScrollPager alloc] initWithFrame:self.view.bounds];
        self.pager.dataSource = self;
        [self.view addSubview:self.pager];
        [self.pager registerPagerClass:UIViewController.class];
}

- (NSInteger)numberOfPagesInPagerView:(__kindof GBaseScrollPager *)pageScrollView;
{
    return 5;
}

- (id)pagerView:(__kindof GBaseScrollPager *)pagerView pagerForIndex:(NSInteger)pageIndex
{
    UIViewController * vc = [pagerView dequeueReusablePager];
    if (!vc) {
        vc = [UIViewController new];
        vc.view.backgroundColor = XCRandomColor;
    }
    return vc;
}


@end
