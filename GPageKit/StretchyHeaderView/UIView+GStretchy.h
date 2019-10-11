//
//  UIView+GStretchy.h
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GStretchy)
- (void)gsk_transplantSubviewsToView:(UIView *)newSuperview;
@end

NS_ASSUME_NONNULL_END
