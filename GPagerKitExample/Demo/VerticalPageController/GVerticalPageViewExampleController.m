//
//  GVerticalPageViewExampleController.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/19.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "GVerticalPageViewExampleController.h"
#import "GStretchyHeaderView.h"
#import "GSimultaneouslyGestureProcessor.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UIScrollView+GSimultaneously.h"
#import "GControllerScrollPager.h"
#import "GVerticalPageListViewController.h"
#import "GPagerMenu.h"
#import "NSObject+GSimultaneously.h"
@interface GVerticalPageViewExampleController ()<GSimultaneouslyProtocol,GStretchyHeaderViewStretchDelegate,GScrollPagerDataSource,GScrollPagerDelegate,GPagerMenuDelegate,GPagerMenuDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * verticalScrollView;
@property (nonatomic, strong) GStretchyHeaderView * stretchyView;
@property (nonatomic, strong) GControllerScrollPager * scrollPager;
@property (nonatomic, strong) GPagerMenu * pagerMenu;
@property (nonatomic, strong) NSArray * items;
@end

@implementation GVerticalPageViewExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gesutreProcessor = [GSimultaneouslyGestureProcessor new];
    [self setupUI];
    [self loadDatas];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [self.stretchyView setMaximumContentHeight:188 resetAnimated:NO];

}

- (void)loadDatas
{
    self.items = @[@"消息",@"推荐哈哈哈",@"最近",@"聊天到这里结束",@"活跃",@"动态",@"广场",@"世界",@"时光",@"北京",@"天气",@"好友"];
    [self.pagerMenu reloadData];
    [self.pagerMenu setSelectIndex:0];
    [self.scrollPager reloadPageScrollView];
}

- (CGSize)calculate:(NSString *)string sizeWithFont:(UIFont *)font
{
    CGSize size;
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}

- (void)setupUI
{
    self.verticalScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.verticalScrollView.backgroundColor = [UIColor redColor];
    self.verticalScrollView.tag = 1008623;
//    [self.verticalScrollView setSimultaneouslyType:GSimultaneouslyType_outer];
//    [self.verticalScrollView setSimultaneouslyDelegate:self];
    self.verticalScrollView.delegate = [self.gesutreProcessor registerMultiDelegate:self type:GSimultaneouslyType_outer];
    [self.view addSubview:self.verticalScrollView];
    
    [self setupStretchyHeaderView];
    [self setupMenu];
    [self setupScrollPager];
    self.verticalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+188);
}

- (void)setupStretchyHeaderView
{
    self.stretchyView = [[GStretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 188)];
    self.stretchyView.minimumContentHeight = 88;
    self.stretchyView.maximumContentHeight = 188;
    self.stretchyView.stretchDelegate = self;
//    self.stretchyView.contentExpands = NO;
    self.stretchyView.contentView.backgroundColor = UIColor.blueColor;
    [self.verticalScrollView addSubview:self.stretchyView];
}

- (void)setupMenu
{
    self.pagerMenu = [[GPagerMenu alloc] initWithFrame:CGRectZero];
    self.pagerMenu.backgroundColor = UIColor.yellowColor;
    self.pagerMenu.delegate = self;
    self.pagerMenu.dataSource = self;
    self.pagerMenu.selectItemScale = 1.2;
    [self.verticalScrollView addSubview:self.pagerMenu];
    [self.pagerMenu mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.right.equalTo(self.view);
          make.top.mas_equalTo(self.stretchyView.mas_bottom);
          make.height.mas_equalTo(45);
      }];
}


- (void)setupScrollPager
{
    self.scrollPager = [[GControllerScrollPager alloc] init];
    self.scrollPager.dataSource = self;
    self.scrollPager.delegate = self;
    self.scrollPager.pageSpacing = 15;
    [self.scrollPager registerPagerClass:GVerticalPageListViewController.class identifier:@"GVerticalPageListViewController"];
    [self.verticalScrollView addSubview:self.scrollPager];
    [self.scrollPager mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.pagerMenu.mas_bottom);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height-88-45);
    }];
}

#pragma mark - <#breif#>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"vertical -- scrollViewDidScroll");
}

#pragma mark - <#breif#>

- (NSInteger)numberOfPagesInPagerView:(__kindof GBaseScrollPager *)pageScrollView
{
    return self.items.count;
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
    [vc configData:[self.items objectAtIndex:pageIndex]];
    if (!vc.gesutreProcessor) {
        vc.gesutreProcessor = self.gesutreProcessor;
    }
    return vc;
}

#pragma mark - GScrollPagerDelegate

- (void)pagerView:(__kindof GBaseScrollPager *)pagerView willJumpToPageAtIndex:(NSInteger)pageIndex
{
    
}

- (void)pagerView:(__kindof GBaseScrollPager *)pagerView didTurnToPageAtIndex:(NSInteger)pageIndex
{
    [self.pagerMenu setSelectIndex:pageIndex];
}

#pragma mark - <#breif#>

- (UIScrollView *)currentScrollView
{
    return self.verticalScrollView;
}

- (CGPoint)fetchCriticalPoint:(UIScrollView *)scrollView
{
    return CGPointMake(0, 20);
}

#pragma mark - <#breif#>

- (void)stretchyHeaderView:(GStretchyHeaderView *)headerView didChangeStretchFactor:(CGFloat)stretchFactor
{
    if (stretchFactor == 0) {
        [self.gesutreProcessor reachOuterScrollToCriticalPoint];
    }
}

#pragma mark - GPagerMenuDataSource

- (NSArray *)pagerMenuItems:(GBasePagerMenu *)menu
{
    return self.items;
}

- (UIView *)pagerMenu:(GBasePagerMenu *)menu itemAtIndex:(NSUInteger)index
{
    UILabel * label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self.items objectAtIndex:index];
    return label;
}

#pragma mark - GPagerMenuDelegate

- (CGSize)pagerMenu:(GBasePagerMenu *)menu itemSizeAtIndex:(NSUInteger)index
{
    NSString * item = [self.items objectAtIndex:index];
    CGSize size = [self calculate:item sizeWithFont:[UIFont systemFontOfSize:15]];
    return CGSizeMake(size.width+10, 45);
}

- (CGFloat)pagerMenu:(GBasePagerMenu *)menu itemSpacingAtIndex:(NSUInteger)index
{
    return 15;
}

- (void)pagerMenu:(GBasePagerMenu *)menu didHighlightAtIndex:(NSUInteger)index
{
    UILabel * label = [menu menuItemAtIndex:index];
    label.textColor = [UIColor redColor];
}

- (void)pagerMenu:(GBasePagerMenu *)menu didUnhighlightAtIndex:(NSUInteger)index
{
    UILabel * label = [menu menuItemAtIndex:index];
    label.textColor = [UIColor blackColor];
}

- (void)pagerMenu:(GBasePagerMenu *)menu didSelectItemAtIndex:(NSUInteger)index
{
    [self.scrollPager turnToPageAtIndex:index animated:YES];
}

@end
