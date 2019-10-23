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
#import "Masonry.h"
#import "GMultiDelegate.h"
#import "MJRefresh.h"
@interface GVerticalPagerCell : UITableViewCell
@property (nonatomic, strong) GBasePagerController * pagerController;
@property (nonatomic, strong) GSimultaneouslyGestureProcessor * gestureProcessor;
@property (nonatomic, weak  ) UIViewController  * weakController;
@end
@implementation GVerticalPagerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pagerController = [[GBasePagerController alloc] init];
//        [self.weakController addChildViewController:self.pagerController];
        //    [self.verticalScrollView addSubview:self.pagerController.view];
        self.pagerController.view.backgroundColor = [UIColor yellowColor];
//        self.pagerController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-10-88);
        [self.contentView addSubview:self.pagerController.view];
        [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)setGestureProcessor:(GSimultaneouslyGestureProcessor *)gestureProcessor
{
    _gestureProcessor = gestureProcessor;
    self.pagerController.gestureProcessor = gestureProcessor;
}

- (void)setWeakController:(UIViewController *)weakController
{
    _weakController = weakController;
    [weakController addChildViewController:self.pagerController];
}

@end

@interface GVerticalPagerController ()<GStretchyHeaderViewStretchDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,GSimultaneouslyProtocol>
@property (nonatomic, strong) GBasePagerController * pagerController;
@property (nonatomic, strong) GStretchyHeaderView * headerView;
@property (nonatomic, strong) UIScrollView * verticalScrollView;
@property (nonatomic, strong) UITableView * verticalTableView;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) BOOL  stretchFactor;
@property (nonatomic, strong) GMultiDelegate * multiDelegate;
@property (nonatomic, strong) GSimultaneouslyGestureProcessor * gestureProcessor;
@property (nonatomic, strong) MJRefreshStateHeader * refreshHeader;
@end

@implementation GVerticalPagerController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self __setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.headerView setMaximumContentHeight:188 resetAnimated:NO];
}

- (void)__setupUI
{
//    [self __setupPagerController];
    [self __setupVerticalScrollView];
    [self __setupHeaderView];
}

- (void)__setupVerticalScrollView
{
    self.verticalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88) style:UITableViewStylePlain];
    self.verticalTableView.delegate = (id)[GSimultaneouslyGestureINST registerMultiDelegate:self type:GSimultaneouslyType_outer];
    self.verticalTableView.dataSource = self;
    self.verticalTableView.tag = 10086;
    [self.view addSubview:self.verticalTableView];
    self.verticalTableView.showsVerticalScrollIndicator = NO;
    self.verticalTableView.showsHorizontalScrollIndicator = NO;
    __weak typeof(self) weakSelf = self;
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.refreshHeader endRefreshing];
        });
    }];
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.refreshHeader.stateLabel.hidden = YES;
    self.verticalTableView.mj_header = self.refreshHeader;
    self.refreshHeader.ignoredScrollViewContentInsetTop = 188;
    
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
    [self.verticalTableView bringSubviewToFront:self.refreshHeader];
}

- (void)__setupPagerController
{
    self.pagerController = [[GBasePagerController alloc] init];
    self.pagerController.gestureProcessor = self.gestureProcessor;
    [self addChildViewController:self.pagerController];
//    [self.verticalScrollView addSubview:self.pagerController.view];
    self.pagerController.view.backgroundColor = [UIColor yellowColor];
    self.pagerController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-10-88);
    self.verticalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88-12);
}

- (void)stretchyHeaderView:(GStretchyHeaderView *)headerView
    didChangeStretchFactor:(CGFloat)stretchFactor
{
//    NSLog(@"stretchFactor-%f",stretchFactor);
//     NSLog(@"contentOffset - %f",self.verticalTableView.contentOffset.y);
    
    if (stretchFactor == 0) {
        self.stretchFactor = YES;
        self.gestureProcessor.reachCriticalPoint = YES;
        self.gestureProcessor.criticalPoint = CGPointMake(0, -10);// self.verticalTableView.contentOffset;
        GSimultaneouslyGestureINST.reachCriticalPoint = YES;
//        GSimultaneouslyGestureINST.criticalPoint = CGPointMake(0, -10);
    } else {
        self.stretchFactor = NO;
    }
//    self.stretchFactor = (stretchFactor < 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll wwwwwwwwwwwwww");
//    if (self.gestureProcessor.reachCriticalPoint) {
//        [scrollView setContentOffset:self.gestureProcessor.criticalPoint animated:NO];
////        [self.gestureProcessor scrollViewDidScroll:scrollView];
//    }
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
    GVerticalPagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[GVerticalPagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    cell.weakController = self;
    cell.gestureProcessor = self.gestureProcessor;
    return cell;
}

- (UIScrollView *)currentScrollView
{
    return self.verticalTableView;
}

#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height-10-88;
}

@end
