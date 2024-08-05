//
//  GVerticalSubViewController.m
//  GPagerKitExample
//
//  Created by GIKI on 2021/1/26.
//  Copyright © 2021 GIKI. All rights reserved.
//

#import "GVerticalSubViewController.h"

@interface GVerticalSubViewController ()

@end

@implementation GVerticalSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [button setTitle:@"string" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    {
        CGFloat left = 100;
        CGFloat top = 120;
        CGFloat width = 100;
        CGFloat height = 100;
        button.frame = CGRectMake(left, top, width, height);
    }
}


- (void)buttonClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVerticalHeader" object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
