//
//  GPagerMenuViewController.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/12.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GPagerMenuViewController.h"
#import "GBasePagerMenu.h"
#define XCColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XCColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define XCRandomColor XCColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface GPagerMenuViewController ()<GPagerMenuDataSource,GPagerMenuDelegate>
@property (nonatomic, strong) GBasePagerMenu * pagerMenuView;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, assign) NSInteger  selectIndex;
@end

@implementation GPagerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.pagerMenuView = [[GBasePagerMenu alloc] init];
    [self.view addSubview:self.pagerMenuView];
    self.pagerMenuView.backgroundColor = UIColor.redColor;
    self.pagerMenuView.dataSource = self;
    self.pagerMenuView.delegate = self;
    self.items = @[@"消息",@"推荐",@"最近",@"聊天到这里结束",@"活跃",@"动态",@"广场",@"世界",@"时光",@"北京",@"天气",@"好友"];
    self.pagerMenuView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50);
    [self.pagerMenuView reloadData];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:XCRandomColor forState:UIControlStateNormal];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, CGRectGetMaxY(self.pagerMenuView.frame)+20, 100, 50);
}

- (void)buttonClick
{
    /*
    self.selectIndex ++;
    if (self.selectIndex >= self.items.count) {
        self.selectIndex = 0;
    }
    [self.pagerMenuView scrollToRowAtIndex:self.selectIndex atScrollPosition:GPagerMenuScrollPositionMiddle animated:YES];
     */
    self.items = @[@"消息",@"推荐哈哈哈",@"最近",@"聊天到这里结束",@"活跃",@"动态",@"广场",@"世界",@"时光",@"北京",@"天气",@"好友"];
    self.selectIndex = 1;
    [self.pagerMenuView reloadWithIndexs:@[@1]];
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
    button.backgroundColor = XCRandomColor;
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
    return CGSizeMake(60, 23);
}

- (CGFloat)pagerMenu:(GBasePagerMenu *)menu itemSpacingAtIndex:(NSUInteger)index
{
    return 12;
}

- (void)pagerMenu:(GBasePagerMenu *)menu didSelectItemAtIndex:(NSUInteger)index
{
    NSString * string = [self.items objectAtIndex:index];
    NSLog(@"点击了-- %@",string);
}

- (void)pagerMenu:(GBasePagerMenu *)menu didSelectItem:(UIButton *)itemView
{
    [itemView setTitle:@"旋涡" forState:UIControlStateNormal];
}

@end
