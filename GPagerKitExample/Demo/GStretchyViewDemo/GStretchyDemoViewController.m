//
//  GStretchyDemoViewController.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/8/7.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "GStretchyDemoViewController.h"
#import "GStretchyDemoView.h"
@interface GStretchyDemoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) GStretchyDemoView * headerView;
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation GStretchyDemoViewController

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
        _tableView = tableView;
        tableView;
    })];
    self.tableView.frame = self.view.bounds;
    
    self.headerView = [[GStretchyDemoView alloc] init];
    [self.tableView addSubview:self.headerView];
    
//    self.tableView.bounces = NO;
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end
