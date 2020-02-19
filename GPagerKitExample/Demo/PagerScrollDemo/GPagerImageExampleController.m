//
//  GPagerImageExampleController.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/19.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "GPagerImageExampleController.h"
#import "Masonry.h"
@interface GPagerImageExampleController ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * descLabel;
@end

@implementation GPagerImageExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.descLabel = [UILabel new];
    self.descLabel.text = @"This is a view controller";
    [self.view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

- (void)setImageName:(NSString *)imageName
{
    self.imageView.image = [UIImage imageNamed:imageName];
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
