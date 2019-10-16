//
//  GPagerMenuViewController.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/12.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GPagerMenuViewController.h"
#import "GBasePagerMenu.h"
#import "GPagerMenu.h"
#define XCColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XCColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define XCRandomColor XCColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface GPagerMenuViewController ()<GPagerMenuDataSource,GPagerMenuDelegate>
@property (nonatomic, strong) GPagerMenu * pagerMenuView;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, assign) NSInteger  selectIndex;
@end

@implementation GPagerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.pagerMenuView = [[GPagerMenu alloc] init];
    self.pagerMenuView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50);
    [self.view addSubview:self.pagerMenuView];
    self.pagerMenuView.backgroundColor = UIColor.whiteColor;
    self.pagerMenuView.dataSource = self;
    self.pagerMenuView.delegate = self;
    self.pagerMenuView.selectItemScale = 1.45;
    self.items = @[@"消息",@"推荐",@"最近",@"聊天到这里结束",@"活跃",@"动态",@"广场",@"世界",@"时光",@"北京",@"天气",@"好友"];
   
    [self.pagerMenuView reloadData];
    [self.pagerMenuView setSelectIndex:0];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:XCRandomColor forState:UIControlStateNormal];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, CGRectGetMaxY(self.pagerMenuView.frame)+20, 100, 50);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
   
}

- (void)buttonClick
{
   
    if (self.selectIndex >= self.items.count) {
        self.selectIndex = 0;
    }
    [self.pagerMenuView setSelectIndex:self.selectIndex animated:YES];
    self.selectIndex ++;
    /*
    self.items = @[@"消息",@"推荐哈哈哈",@"最近",@"聊天到这里结束",@"活跃",@"动态",@"广场",@"世界",@"时光",@"北京",@"天气",@"好友"];
    self.selectIndex = 1;
    [self.pagerMenuView reloadWithIndexs:@[@1]];
     */
}

- (NSArray *)pagerMenuItems:(GBasePagerMenu *)menu
{
    return self.items;
}

- (UIView *)pagerMenu:(GBasePagerMenu *)menu itemAtIndex:(NSUInteger)index
{
    NSString * string = [self.items objectAtIndex:index];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button setTitle:string forState:UIControlStateNormal];
//    button.backgroundColor = XCRandomColor;
    return button;
}

- (CGSize)pagerMenu:(GBasePagerMenu *)menu itemSizeAtIndex:(NSUInteger)index
{
    if (index == 3) {
        return CGSizeMake(120, 23);
    }
    if (self.selectIndex >0 && self.selectIndex == index) {
        return CGSizeMake(120, 23);
    }
    NSString * string = [self.items objectAtIndex:index];
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:13]];
    return CGSizeMake(size.width+10, 23);
}

- (CGFloat)pagerMenu:(GBasePagerMenu *)menu itemSpacingAtIndex:(NSUInteger)index
{
    return 10;
}

- (void)pagerMenu:(GBasePagerMenu *)menu didselectItemAtIndex:(NSUInteger)index
{
    NSString * string = [self.items objectAtIndex:index];
    NSLog(@"点击了-- %@",string);
    UIButton * btn = [menu menuItemAtIndex:index];
    [btn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
}

- (void)pagerMenu:(GBasePagerMenu *)menu deselectItemAtIndex:(NSUInteger)index
{
    UIButton * btn = [menu menuItemAtIndex:index];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
}

@end
