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
#import "GSimultaneouslyGestureProcessor.h"
@interface GVerticalPagerController ()<GStretchyHeaderViewStretchDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) GBasePagerController * pagerController;
@property (nonatomic, strong) GStretchyHeaderView * headerView;
@property (nonatomic, strong) UIScrollView * verticalScrollView;
@property (nonatomic, strong) UITableView * verticalTableView;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) BOOL  stretchFactor;
@property (nonatomic, strong) GSimultaneouslyGestureProcessor * gestureProcessor;
@end

@implementation GVerticalPagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gestureProcessor = [[GSimultaneouslyGestureProcessor alloc] init];
    [self __setupUI];
    self.gestureProcessor.outerScrollView = self.verticalScrollView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.headerView setMaximumContentHeight:188 resetAnimated:NO];
}

- (void)__setupUI
{
    [self __setupPagerController];
    [self __setupVerticalScrollView];
    [self __setupHeaderView];
}

- (void)__setupVerticalScrollView
{
    self.verticalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88) style:UITableViewStylePlain];
    self.verticalTableView.delegate = self;
    self.verticalTableView.dataSource = self;
    self.verticalTableView.tag = 10086;
    [self.view addSubview:self.verticalTableView];
}

- (void)__setupVerticalScrollView1
{
    self.verticalScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.verticalScrollView];
    self.verticalScrollView.delegate = self;
    self.verticalScrollView.tag = 10086;
    self.verticalScrollView.showsVerticalScrollIndicator = NO;
    self.verticalScrollView.showsHorizontalScrollIndicator = NO;
    self.verticalScrollView.frame = CGRectMake(0,88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
    self.verticalScrollView.backgroundColor = UIColor.blueColor;
}

- (void)__setupHeaderView
{
    self.headerView = [[GStretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 188)];
    self.headerView.minimumContentHeight = 10;
    self.headerView.maximumContentHeight = 188;
    self.headerView.stretchDelegate = self;
    self.headerView.contentView.backgroundColor = UIColor.redColor;
    [self.verticalTableView addSubview:self.headerView];
}

- (void)__setupPagerController
{
    self.pagerController = [[GBasePagerController alloc] init];
    self.pagerController.gestureProcessor = self.gestureProcessor;
    [self addChildViewController:self.pagerController];
//    [self.verticalScrollView addSubview:self.pagerController.view];
    self.pagerController.view.backgroundColor = [UIColor yellowColor];
    self.pagerController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
    self.verticalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88-12);
}

- (void)stretchyHeaderView:(GStretchyHeaderView *)headerView
    didChangeStretchFactor:(CGFloat)stretchFactor
{
    NSLog(@"stretchFactor-%f",stretchFactor);
    
    if (stretchFactor == 0) {
        NSLog(@"contentOffset - %f",self.verticalScrollView.contentOffset.y);
        self.contentOffset = self.verticalScrollView.contentOffset;
        self.stretchFactor = YES;
        self.gestureProcessor.reachCriticalPoint = YES;
    } else {
        self.stretchFactor = NO;
    }
//    self.stretchFactor = (stretchFactor < 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.gestureProcessor.reachCriticalPoint) {
        [scrollView setContentOffset:self.contentOffset animated:NO];
//        [self.gestureProcessor scrollViewDidScroll:scrollView];
    }
}

#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
        [cell.contentView addSubview:self.pagerController.view];
    }
    
    return cell;
}

#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.pagerController.view.frame.size.height;
}

@end
