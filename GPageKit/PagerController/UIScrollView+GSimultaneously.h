//
//  UIScrollView+GSimultaneously.h
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/19.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSimultaneouslyGestureProcessor.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (GSimultaneously)

@property (nonatomic, assign) GSimultaneouslyType  simultaneouslyType;

- (void)setSimultaneouslyDelegate:(id<GSimultaneouslyProtocol>)delegate;
@end

NS_ASSUME_NONNULL_END
