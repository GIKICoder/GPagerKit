//
//  GVerticalPageViewExampleController.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/19.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "GVerticalPageViewExampleController.h"
#import "GBasePagerController.h"
#import "GStretchyHeaderView.h"
#import "GSimultaneouslyGestureProcessor.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UIScrollView+GSimultaneously.h"
#import "GControllerScrollPager.h"
#import "GVerticalPageListViewController.h"
@interface GVerticalPageViewExampleController ()<GSimultaneouslyProtocol,GStretchyHeaderViewStretchDelegate,GScrollPagerDataSource,GScrollPagerDataSource>
@property (nonatomic, strong) UIScrollView * verticalScrollView;
@property (nonatomic, strong) GStretchyHeaderView * stretchyView;
@property (nonatomic, strong) GControllerScrollPager * scrollPager;
@end

@implementation GVerticalPageViewExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.verticalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+188);
}
- (void)setupUI
{
    self.verticalScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.verticalScrollView.backgroundColor = [UIColor redColor];
    self.verticalScrollView.tag = 10086;
    [self.verticalScrollView setSimultaneouslyType:GSimultaneouslyType_outer];
    [self.verticalScrollView setSimultaneouslyDelegate:self];
    [self.view addSubview:self.verticalScrollView];
    
    [self setupStretchyHeaderView];
    [self setupScrollPager];
}

- (void)setupStretchyHeaderView
{
     self.stretchyView = [[GStretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 188)];
      self.stretchyView.minimumContentHeight = 0;
      self.stretchyView.maximumContentHeight = 188;
      self.stretchyView.stretchDelegate = self;
      self.stretchyView.contentView.backgroundColor = UIColor.blueColor;
      [self.verticalScrollView addSubview:self.stretchyView];
}

- (void)setupScrollPager
{
       self.scrollPager = [[GControllerScrollPager alloc] init];
       self.scrollPager.dataSource = self;
       self.scrollPager.delegate = self;
       self.scrollPager.pageSpacing = 15;
       [self.scrollPager registerPagerClass:GVerticalPageListViewController.class identifier:@"GVerticalPageListViewController"];
       [self.view addSubview:self.scrollPager];
       [self.scrollPager mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.equalTo(self.view);
           make.top.mas_equalTo(self.stretchyView.mas_bottom);
           make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height-88);
       }];
}


#pragma mark - <#breif#>

- (NSInteger)numberOfPagesInPagerView:(__kindof GBaseScrollPager *)pageScrollView
{
    return 10;
}

/**
 返回index下的pageView or pageController
 
 @param pagerView pagerView description
 @param pageIndex pageIndex description
 @return return value description
 */
- (GVerticalPageListViewController *)pagerView:(__kindof GBaseScrollPager *)pagerView pagerForIndex:(NSInteger)pageIndex
{
    GVerticalPageListViewController * vc = [pagerView dequeueReusablePagerForIdentifier:@"GVerticalPageListViewController"];
    return vc;
}


#pragma mark - <#breif#>

- (UIScrollView *)currentScrollView
{
    return self.verticalScrollView;
}

- (CGPoint)fetchCriticalPoint:(UIScrollView *)scrollView
{
    return CGPointZero;
}

#pragma mark - <#breif#>

- (void)stretchyHeaderView:(GStretchyHeaderView *)headerView didChangeStretchFactor:(CGFloat)stretchFactor
{
    if (stretchFactor == 0) {
        [self.verticalScrollView reachOuterScrollToCriticalPoint];
    }
}
@end
