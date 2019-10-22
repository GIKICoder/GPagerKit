//
//  GPagerListController.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/16.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GPagerListController.h"
#import "GStretchyHeaderView.h"

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

@interface GPagerListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) XCCDebugPageListView * tableView;
@property (nonatomic, strong) GStretchyHeaderView * headerView;
@end

@implementation GPagerListController

- (void)viewDidLoad {
    [super viewDidLoad];
    XCCDebugPageListView *tableView = [[XCCDebugPageListView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    self.tableView = tableView;
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
//    self.tableView.scrollEnabled = NO;
//    self.headerView = [[GStretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
//    self.headerView.minimumContentHeight = 120;
//    self.headerView.maximumContentHeight = 160;
//    self.headerView.contentView.backgroundColor = UIColor.redColor;
//    [self.tableView addSubview:self.headerView];
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

- (void)setGestureProcessor:(GSimultaneouslyGestureProcessor *)gestureProcessor
{
    _gestureProcessor = gestureProcessor;
    gestureProcessor.innerScrollView = self.tableView;
}

#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int x = arc4random() % 100;
    return x;
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
    if (!self.gestureProcessor.reachCriticalPoint) {
        [scrollView setContentOffset:CGPointZero animated:NO];
    }
}
@end
