//
//  GStretchyDemoView.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/8/7.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "GStretchyDemoView.h"
#import "Masonry.h"
#import "UIView+XCUtils.h"
@interface GStretchyDemoView ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIButton * expand;
@property (nonatomic, assign) BOOL  isExpand;
@property (nonatomic, strong) UILabel * textLabel;
@end
@implementation GStretchyDemoView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    self = [super initWithFrame:rect];
    if (self) {
        self.maximumContentHeight = 200;
        self.minimumContentHeight = 100;
        self.contentView.backgroundColor = UIColor.redColor;
        [self.contentView addSubview:({
            _imageView = [UIImageView new];
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            _imageView.image = [UIImage imageNamed:@"profile_createtag_bg"];
            _imageView;
        })];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.contentView addSubview:({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            [button setTitle:@"expand" forState:UIControlStateNormal];
            button.backgroundColor = UIColor.blueColor;
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
            _expand = button;
            button;
        })];
        
        [self.contentView addSubview:({
            _textLabel = [UILabel new];
            _textLabel.numberOfLines = 0;
            _textLabel;
        })];
        self.textLabel.frame = CGRectMake(0, self.expand.bottom+5, [UIScreen mainScreen].bounds.size.width, 20);
        self.textLabel.text = @"【1】【商业化】七八双月广告模块需求汇总 (玉元)【2】【商业化】信息流机制优化（仅iOS） (玉元)【1】【优化】我的页面结构优化（刘畅）（巩柯）【1】【优化】恶意踩提醒弹窗（刘畅）（吉彬）【1】【审查】话题接入举报 （惠英英）（吉彬【1】【增长】视频片尾分享引导2.0  全量覆盖【iOS】  (城楠)【1】【增长】分享弹窗优化排序3.0-方案2 全量覆盖【iOS】（检峰）";
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
        }];
        [self.expand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 40));
            make.bottom.mas_equalTo(self.textLabel.mas_top).mas_offset(-20);
            make.left.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


- (void)buttonClick
{
    if (!self.isExpand) {
        
//        self.maximumContentHeight = 300;
        CGFloat height = 230;
        self.height = height;
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
        
//        UIEdgeInsets edgeInsets = self.contentInset;
//        self.contentInset = UIEdgeInsetsMake(edgeInsets.top-100, edgeInsets.left, edgeInsets.bottom, edgeInsets.right);
        [self updateMaximumContentHeight:height offset:-30 animation:YES];
    } else {
//        self.maximumContentHeight = 200;
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        [self updateMaximumContentHeight:200 animation:YES];
    }
    self.isExpand = !self.isExpand;
}

@end
