//
//  ViewController.m
//  GPageKit
//
//  Created by GIKI on 2019/9/10.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = @[
        @{@"title":@"ViewScrollPager-Example",@"controller":@"GPagerViewExampleController"},
        @{@"title":@"ControllerScrollPager-Example",@"controller":@"GControllerPagerExampleController"},
        @{@"title":@"PageListController-Example",@"controller":@"GPageListExampleViewController"},
        @{@"title":@"VerticalPageListController-Example",@"controller":@"GVerticalPageViewExampleController"},
        @{@"title":@"StretchyView",@"controller":@"GStretchyDemoViewController"},
    ];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    self.tableView = tableView;
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
}

#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    NSDictionary * param = self.datas[indexPath.row];
    cell.textLabel.text = param[@"title"];
    return cell;
}

#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * param = self.datas[indexPath.row];
    NSString * clas = param[@"controller"];
    Class clazz = NSClassFromString(clas);
    UIViewController * vc = [[clazz alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


@end
