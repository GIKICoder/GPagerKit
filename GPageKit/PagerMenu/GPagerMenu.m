//
//  GPagerMenu.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/15.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GPagerMenu.h"
#import "GPagerMenuInternal.h"
@interface GPagerMenu ()
@property (nonatomic, strong) UIImageView * divideLine;
@end

@implementation GPagerMenu


- (UIImageView *)divideLine
{
    if (!_divideLine) {
        _divideLine = [[UIImageView alloc] init];
        _divideLine.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:_divideLine];
    }
    return _divideLine;
}

- (void)__didselectItemAtIndex:(NSUInteger)index
{
    GPagerMenuLayoutInternal * layout = [self.menuLayouts objectAtIndex:index];
    CGRect rect = layout.itemView.frame;
    self.divideLine.frame = CGRectMake(rect.origin.x+(rect.size.width-40)*0.5, CGRectGetMaxY(self.scrollView.frame)-2, 40, 2);
}

- (void)__deselectItemAtIndex:(NSUInteger)index
{
    
}

- (CGSize)__itemSizeAtIndex:(NSUInteger)index
{
    return CGSizeZero;
}

- (CGFloat)__itemSpacingAtIndex:(NSUInteger)index
{
    return 0;
}

@end
