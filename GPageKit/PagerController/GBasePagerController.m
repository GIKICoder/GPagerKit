//
//  GBasePagerController.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/16.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GBasePagerController.h"
#import "GControllerScrollPager.h"
#import "GPagerMenu.h"
#import "GPagerListController.h"
@interface GBasePagerController ()<GPagerMenuDelegate,GPagerMenuDataSource,GScrollPagerDelegate,GScrollPagerDataSource>
@property (nonatomic, strong) GPagerMenu * pagerMenu;
@property (nonatomic, strong) GControllerScrollPager * scrollPager;

@property (nonatomic, strong) NSArray * items;
@end

@implementation GBasePagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupUI];
    [self loadDatas];
}

- (void)__setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupMenu];
    [self setupScrollPager];
}

- (void)setupMenu
{
    self.pagerMenu = [[GPagerMenu alloc] initWithFrame:CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, 45)];
    self.pagerMenu.delegate = self;
    self.pagerMenu.dataSource = self;
    self.pagerMenu.selectItemScale = 1.2;
    [self.view addSubview:self.pagerMenu];
}

- (void)setupScrollPager
{
    self.scrollPager = [[GControllerScrollPager alloc] init];
    self.scrollPager.frame = CGRectMake(0, CGRectGetMaxY(self.pagerMenu.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-CGRectGetMaxY(self.pagerMenu.frame));
    self.scrollPager.dataSource = self;
    self.scrollPager.delegate = self;
    [self.view addSubview:self.scrollPager];
    [self.scrollPager registerPagerClass:GPagerListController.class];
}

- (void)loadDatas
{
    self.items = @[@"消息",@"推荐哈哈哈",@"最近",@"聊天到这里结束",@"活跃",@"动态",@"广场",@"世界",@"时光",@"北京",@"天气",@"好友"];
    [self.pagerMenu reloadData];
    [self.pagerMenu setSelectIndex:0];
}

- (CGSize)calculate:(NSString *)string sizeWithFont:(UIFont *)font
{
    CGSize size;
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
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

- (void)pagerMenu:(GBasePagerMenu *)menu didselectItemAtIndex:(NSUInteger)index
{
    [self.scrollPager turnToPageAtIndex:index animated:YES];
    UILabel * label = [menu menuItemAtIndex:index];
    label.textColor = [UIColor redColor];
}

- (void)pagerMenu:(GBasePagerMenu *)menu deselectItemAtIndex:(NSUInteger)index
{
    UILabel * label = [menu menuItemAtIndex:index];
    label.textColor = [UIColor blackColor];
}
#pragma mark - GScrollPagerDataSource

/**
 返回PageView数量
 */
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
- (UIViewController *)pagerView:(__kindof GBaseScrollPager *)pagerView pagerForIndex:(NSInteger)pageIndex
{
    GPagerListController * listController = [pagerView dequeueReusablePager];
    listController.view.frame = self.scrollPager.bounds;
    return listController;
}

#pragma mark - GScrollPagerDelegate

- (void)pagerView:(__kindof GBaseScrollPager *)pagerView willJumpToPageAtIndex:(NSInteger)pageIndex
{
    
}

- (void)pagerView:(__kindof GBaseScrollPager *)pagerView didTurnToPageAtIndex:(NSInteger)pageIndex
{

}
@end
