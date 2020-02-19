//
//  GPagerListController.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/16.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GPagerListController.h"
#import "GStretchyHeaderView.h"
#import "GSimultaneouslyGestureProcessor.h"
#import "MJRefresh.h"
@interface  XCCDebugPageListView : UITableView

@end

@implementation XCCDebugPageListView

/**
 同时识别多个手势
 
 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (otherGestureRecognizer.view.tag == 10086) {
        return YES;
    }
    return NO;
}

@end

@interface GPagerListController ()<UITableViewDelegate,UITableViewDataSource,GSimultaneouslyProtocol>
@property (nonatomic, strong) XCCDebugPageListView * tableView;
@property (nonatomic, strong) GStretchyHeaderView * headerView;
@property (nonatomic, strong) MJRefreshHeader * refreshHeader;
@end

@implementation GPagerListController

- (void)viewDidLoad {
    [super viewDidLoad];
    XCCDebugPageListView *tableView = [[XCCDebugPageListView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;// (id)[GSimultaneouslyGestureINST registerMultiDelegate:self type:GSimultaneouslyType_inner];
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
 
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.refreshHeader endRefreshing];
        });
    }];
    self.tableView.mj_header = self.refreshHeader;
    self.refreshHeader.ignoredScrollViewContentInsetTop = 188;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)configWithDatas:(NSArray * )datas
{
    [self.tableView reloadData];
}


- (UIScrollView *)currentScrollView
{
    return self.tableView;
}

- (BOOL)reachCritical:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        return NO;
    }
    return YES;
}

- (CGPoint)fetchCriticalPoint:(UIScrollView *)scrollView
{
    return CGPointMake(0,0);
}

#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int x = arc4random() % 100;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll pagelist");
//    if (!self.gestureProcessor.reachCriticalPoint) {
//        [scrollView setContentOffset:CGPointZero animated:NO];
//    }
}
@end
