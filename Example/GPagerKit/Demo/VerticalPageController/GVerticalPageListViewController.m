//
//  GVerticalPageListViewController.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/19.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "GVerticalPageListViewController.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "GVerticalSubViewController.h"
@interface GVerticalPageListView : UITableView

@end

@implementation GVerticalPageListView

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    if (contentSize.height < 20) {
        NSLog(@"string");
    }
}
/**
 同时识别多个手势
 
 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (otherGestureRecognizer.view.tag == 1008623) {
        return YES;
    }

    return NO;
}


@end

@interface GVerticalPageListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) GVerticalPageListView * tableView;
@property (nonatomic, strong) MJRefreshHeader * refreshHeader;
@property (nonatomic, assign) NSInteger  dataCount;
@end

@implementation GVerticalPageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataCount = 10;
    self.view.backgroundColor = UIColor.yellowColor;
    GVerticalPageListView *tableView = [[GVerticalPageListView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.dataSource = self;
//    [tableView setSimultaneouslyType:GSimultaneouslyType_inner];
//    [tableView setSimultaneouslyDelegate:self];
    tableView.delegate = self;
    tableView.rowHeight = 0;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    __weak typeof(self) weakSelf = self;
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.refreshHeader endRefreshing];
        });
    }];
//    self.tableView.mj_header = self.refreshHeader;
//    self.refreshHeader.ignoredScrollViewContentInsetTop = 188;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.tableView.frame = self.view.bounds;
}

- (void)configData:(NSString *)data
{
    self.dataCount = [self getRandomNumber:3 to:30];
    if ([data isEqualToString:@"广场"]) {
        self.dataCount = 1;
    }
    [self.tableView reloadData];
}

- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % ((to-from) + 1)));
}

- (UIScrollView *)currentScrollView
{
    return self.tableView;
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
    return self.dataCount;
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
    GVerticalSubViewController * VC = [GVerticalSubViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll pagelist");
    //    if (!self.gestureProcessor.reachCriticalPoint) {
    //        [scrollView setContentOffset:CGPointZero animated:NO];
    //    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScrollToTop222222");
}

@end
