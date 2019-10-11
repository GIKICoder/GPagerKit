//
//  GPagerVCTestViewController.m
//  GPageKit
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GPagerVCTestViewController.h"
#import "GControllerScrollPager.h"

#define XCColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XCColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define XCRandomColor XCColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface GPagerVCTestViewController ()<GScrollPagerDataSource>
@property (nonatomic, strong) GControllerScrollPager * pager;
@end

@implementation GPagerVCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pager = [[GControllerScrollPager alloc] initWithFrame:CGRectMake(0, 88+10, self.view.bounds.size.width, self.view.bounds.size.height-88-20)];
    self.pager.dataSource = self;
    self.pager.pageSpacing = 10;
    [self.view addSubview:self.pager];
    [self.pager registerPagerClass:UIViewController.class];
//    for (int i = 0; i < 5; i++) {
//        NSString * key = [NSString stringWithFormat:@"pagerView-%d",i];
//        [self.pager registerPagerClass:UIViewController.class identifier:key];
//    }
}

- (NSInteger)numberOfPagesInPagerView:(__kindof GBaseScrollPager *)pageScrollView;
{
    return 5;
}

- (id)pagerView:(__kindof GBaseScrollPager *)pagerView pagerForIndex:(NSInteger)pageIndex
{
    
    NSString * key = [NSString stringWithFormat:@"pagerView-%ld",pageIndex];
//    UIViewController * vc = [pagerView dequeueReusablePagerForIdentifier:key];
    UIViewController * vc = [pagerView dequeueReusablePager];
    if (!vc) {
        vc = [UIViewController new];
        vc.pageIdentifier = key;
        vc.view.backgroundColor = XCRandomColor;
    }
    return vc;
}


@end
