//
//  GStretchViewHeaderController.m
//  GPagerKitExample
//
//  Created by GIKI on 2021/1/27.
//  Copyright © 2021 GIKI. All rights reserved.
//

#import "GStretchViewHeaderController.h"
#import "Masonry.h"
#import "GPagerImageExampleController.h"
#import "UIView+XCUtils.h"
#import "GStretchyHeaderView.h"
@interface GStretchViewHeaderController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) GStretchyHeaderView * headerView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * customView;
@property (nonatomic, strong) UIView * extendView;
@end

@implementation GStretchViewHeaderController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar removeFromSuperview];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar removeFromSuperview];
}

- (void)setupUI
{
    [self.view addSubview:({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _tableView = tableView;
        tableView;
    })];
    self.tableView.frame = self.view.bounds;
    
    self.headerView = [[GStretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    self.headerView.expansionMode = GStretchyHeaderViewExpansionModeTopOnly;
    self.headerView.backgroundColor = UIColor.blueColor;
    [self.tableView addSubview:self.headerView];
    self.headerView.minimumContentHeight = 88;
    self.headerView.maximumContentHeight = 200;
    self.headerView.contentExpands = YES;
    self.headerView.contentShrinks = NO;
    self.headerView.contentAnchor = GStretchyHeaderViewContentAnchorBottom;
//    self.headerView.manageScrollViewSubviewHierarchy = NO;
    self.customView = [UIView new];
    self.customView.backgroundColor = UIColor.redColor;
    self.customView.frame = CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, 200-88);
    [self.headerView.contentView addSubview:self.customView];
    self.customView.autoresizingMask =UIViewAutoresizingFlexibleTopMargin; // UIViewAutoresizingFlexibleBottomMargin;// UIViewAutoresizingFlexibleTopMargin;
    self.extendView = [UIView new];
    self.extendView.backgroundColor = UIColor.orangeColor;
    [self.customView addSubview:self.extendView];
    [self.extendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 10));
        make.bottom.mas_equalTo(self.customView.mas_bottom);
        make.left.mas_equalTo(0);
    }];
//    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 200-88));
//        make.bottom.mas_equalTo(self.headerView.mas_bottom);
//        make.left.mas_equalTo(0);
////        make.top.mas_equalTo(self.headerView.mas_top);
////        make.width.mas_equalTo(self.headerView.mas_width);
//    }];
}

#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    return cell;
}

#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        self.customView.frame = CGRectMake(0, 78, [UIScreen mainScreen].bounds.size.width, 200-78);
//        [self.headerView updateMaximumContentHeight:300 animation:YES];
//        [self.headerView setMaximumContentHeight:300 resetAnimated:NO];
        [UIView animateWithDuration:0.25 animations:^{
                  
        }];
//        [self.headerView setMaximumContentHeight:300];
        
        
//        [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 300-88));
//        }];
//        [self.extendView layoutIfNeeded];//如果约束还没有生成，要强制约束生成才行，不然动画没用
//
//        [self.extendView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 60));
//        }];
//        [UIView animateWithDuration:0.25 animations:^{
//            [self.extendView layoutIfNeeded];
//        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end
