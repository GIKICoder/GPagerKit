//
//  GPagerViewExampleController.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/19.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "GPagerViewExampleController.h"
#import "GViewScrollPager.h"
#import "Masonry.h"
@interface GPagerViewExampleController ()<GScrollPagerDataSource,GScrollPagerDelegate>
@property (nonatomic, strong) GViewScrollPager * scrollPager;
@property (nonatomic, strong) NSArray * itemDatas;
@end

@implementation GPagerViewExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.scrollPager = [[GViewScrollPager alloc] init];
    self.scrollPager.dataSource = self;
    self.scrollPager.delegate = self;
    self.scrollPager.pageSpacing = 15;
    [self.scrollPager registerPagerClass:UIImageView.class identifier:@"GBaseScrollPagerKey"];
    [self.view addSubview:self.scrollPager];
    [self.scrollPager mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(200);
    }];
    self.itemDatas = @[@"demo_001.jpg",@"demo_002.jpg",@"demo_003.jpg",@"demo_004.jpg"];
    [self.scrollPager reloadPageScrollView];
}

- (NSInteger)numberOfPagesInPagerView:(__kindof GBaseScrollPager *)pageScrollView
{
    return self.itemDatas.count;
}

/**
 返回index下的pageView or pageController
 
 @param pagerView pagerView description
 @param pageIndex pageIndex description
 @return return value description
 */
- (UIView *)pagerView:(__kindof GBaseScrollPager *)pagerView pagerForIndex:(NSInteger)pageIndex
{
    UIImageView * imageView = [pagerView dequeueReusablePagerForIdentifier:@"GBaseScrollPagerKey"];
    NSString * imageName = [self.itemDatas objectAtIndex:pageIndex];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}



@end
