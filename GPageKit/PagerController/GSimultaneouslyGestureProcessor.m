//
//  GSimultaneouslyGestureProcessor.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/22.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GSimultaneouslyGestureProcessor.h"

@interface GSimultaneouslyGestureProcessor ()
@property (nonatomic, strong) NSMutableArray * multiDelegates;
@end
@implementation GSimultaneouslyGestureProcessor

+ (instancetype)sharedInstance
{
    static GSimultaneouslyGestureProcessor * INST = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INST = [[GSimultaneouslyGestureProcessor alloc] init];
    });
    return INST;
}

- (GMultiDelegate *)registerMultiDelegate:(id)delegate
{
    GMultiDelegate * multi = [[GMultiDelegate alloc] initWithDelegates:@[self,delegate]];
    [self.multiDelegates addObject:multi];
    return multi;
}

- (void)dealloc
{
    if (_innerScrollView) {
       [_innerScrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
    if (_outerScrollView) {
        [_outerScrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
}
- (void)setOuterScrollView:(UIScrollView *)outerScrollView
{
    if (_outerScrollView) {
        [_outerScrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
    _outerScrollView = outerScrollView;
    [_outerScrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)setInnerScrollView:(UIScrollView *)innerScrollView
{
    if (_innerScrollView) {
        [_innerScrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
    _innerScrollView = innerScrollView;
    [_innerScrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSString *, NSValue *> *)change
                       context:(nullable void *)context {
    if (object == self.outerScrollView) {
        if (![keyPath isEqualToString:@"contentOffset"]) {
            NSAssert(NO, @"keyPath '%@' is not being observed", keyPath);
        }
        
        CGPoint contentOffset = change[NSKeyValueChangeNewKey].CGPointValue;
        CGPoint previousContentOffset = change[NSKeyValueChangeOldKey].CGPointValue;
//        NSLog(@"1111contentOffset - %f, 11111111previousContentOffset - %f",contentOffset,previousContentOffset);
        if (contentOffset.y == previousContentOffset.y) {
            return;
        }
        if (self.reachCriticalPoint) {
//            self.criticalPoint = previousContentOffset;
        }
    } else if (object == self.innerScrollView) {
        if (![keyPath isEqualToString:@"contentOffset"]) {
            NSAssert(NO, @"keyPath '%@' is not being observed", keyPath);
        }
        CGPoint contentOffset = change[NSKeyValueChangeNewKey].CGPointValue;
        CGPoint previousContentOffset = change[NSKeyValueChangeOldKey].CGPointValue;
//        NSLog(@"contentOffset - %f, previousContentOffset - %f",contentOffset.y,previousContentOffset.y);
        if (previousContentOffset.y < 0) {
            self.reachCriticalPoint = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.outerScrollView == scrollView) {
        if (self.reachCriticalPoint) {
            [self.outerScrollView setContentOffset:self.criticalPoint animated:NO];
        }
    }
}


@end


@implementation NSObject  (GestureProcessor)

@end
