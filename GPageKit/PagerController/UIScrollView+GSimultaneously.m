//
//  UIScrollView+GSimultaneously.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/19.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "UIScrollView+GSimultaneously.h"
#import <objc/runtime.h>

@implementation UIScrollView (GSimultaneously)

#pragma mark - Getter/Setter

static char kAssociatedObjectKey_simultaneouslyType;
- (void)setSimultaneouslyType:(GSimultaneouslyType)simultaneouslyType {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_simultaneouslyType, @(simultaneouslyType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GSimultaneouslyType)simultaneouslyType {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_simultaneouslyType)) integerValue];
}

- (void)setSimultaneouslyDelegate:(id<GSimultaneouslyProtocol>)delegate
{
    self.delegate = (id)[GSimultaneouslyGestureINST registerMultiDelegate:delegate type:self.simultaneouslyType];
}

@end
