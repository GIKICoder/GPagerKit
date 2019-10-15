//
//  GPagerMenu.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/15.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GPagerMenu.h"

@interface GPagerMenu ()
@property (nonatomic, strong) UIImageView * divideLine;
@end

@implementation GPagerMenu


- (UIImageView *)divideLine
{
    if (!_divideLine) {
        _divideLine = [[UIImageView alloc] init];
    }
    return _divideLine;
}

@end
