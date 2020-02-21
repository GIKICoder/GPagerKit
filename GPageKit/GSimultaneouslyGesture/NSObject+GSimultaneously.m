//
//  NSObject+GSimultaneously.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/21.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "NSObject+GSimultaneously.h"
#import <objc/runtime.h>
@implementation NSObject (GSimultaneously)

static char kAssociatedObjectKey_gesutreProcessor;
- (void)setGesutreProcessor:(GSimultaneouslyGestureProcessor *)gesutreProcessor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_gesutreProcessor, gesutreProcessor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GSimultaneouslyGestureProcessor *)gesutreProcessor {
    return (GSimultaneouslyGestureProcessor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_gesutreProcessor);
}
@end
