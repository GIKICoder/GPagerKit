//
//  GVerticalPagerController.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/22.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GVerticalPagerController.h"
#import "GBasePagerController.h"
#import "GStretchyHeaderView.h"
@interface GVerticalPagerController ()
@property (nonatomic, strong) GBasePagerController * pagerController;
@property (nonatomic, strong) GStretchyHeaderView * headerView;
@property (nonatomic, strong) UIScrollView * verticalScrollView;
@end

@implementation GVerticalPagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupUI];
}

- (void)__setupUI
{
    [self __setupVerticalScrollView];
    [self __setupHeaderView];
    [self __setupPagerController];
}

- (void)__setupVerticalScrollView
{
    self.verticalScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.verticalScrollView];
    self.verticalScrollView.showsVerticalScrollIndicator = NO;
    self.verticalScrollView.showsHorizontalScrollIndicator = NO;
    self.verticalScrollView.frame = CGRectMake(0,88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
    self.verticalScrollView.backgroundColor = UIColor.blueColor;
}

- (void)__setupHeaderView
{
    self.headerView = [[GStretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
    self.headerView.minimumContentHeight = 10;
    self.headerView.maximumContentHeight = 188;
    self.headerView.contentView.backgroundColor = UIColor.redColor;
    [self.verticalScrollView addSubview:self.headerView];
}

- (void)__setupPagerController
{
    self.pagerController = [[GBasePagerController alloc] init];
    [self addChildViewController:self.pagerController];
    [self.verticalScrollView addSubview:self.pagerController.view];
    self.pagerController.view.backgroundColor = [UIColor yellowColor];
    self.pagerController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
    self.verticalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
}
@end
