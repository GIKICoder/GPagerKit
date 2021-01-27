//
//  GSimultaneouslyGestureProcessor.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/22.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "GSimultaneouslyGestureProcessor.h"

@interface GSimultaneouslyItem : NSObject
@property (nonatomic, strong) GMultiDelegate * delegate;
@property (nonatomic, assign) GSimultaneouslyType  type;
@end
@implementation GSimultaneouslyItem
@end

@interface GSimultaneouslyGestureProcessor ()
@property (nonatomic, strong) NSMutableArray * multiDelegates;
@property (nonatomic, strong) NSMapTable * mapTable;
@property (nonatomic, assign) BOOL  criticalState;
@property (nonatomic, assign) BOOL  beginDrag;
@property (nonatomic, assign) BOOL  outerBounces;
@end
@implementation GSimultaneouslyGestureProcessor

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapTable = [[NSMapTable alloc] initWithKeyOptions:(NSPointerFunctionsWeakMemory) valueOptions:(NSPointerFunctionsStrongMemory) capacity:0];
    }
    return self;
}

- (GMultiDelegate *)registerMultiDelegate:(id<GSimultaneouslyProtocol>)delegate type:(GSimultaneouslyType)type
{
    [self resetStatus];
    GMultiDelegate * multi = [[GMultiDelegate alloc] initWithDelegates:@[self,delegate]];
    GSimultaneouslyItem * item = [[GSimultaneouslyItem alloc] init];
    item.type = type;
    item.delegate = multi;
    UIScrollView * scrollView = [delegate currentScrollView];
    NSAssert(scrollView, @"delegate must be impl currentScrollView");
    [self.mapTable setObject:item forKey:scrollView];
    return multi;
}

- (void)resetStatus
{
    self.criticalState = NO;
    self.outerBounces = NO;
}

- (void)destory
{
    [self.mapTable removeAllObjects];
    [self resetStatus];
}

- (void)dealloc
{
    
}

- (void)reachOuterScrollToCriticalPoint
{
    self.criticalState = YES;
}

- (void)reachInnerScrollToCriticalPoint
{
    self.criticalState = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    GSimultaneouslyItem * item = [self.mapTable objectForKey:scrollView];
    if (item && item.type == GSimultaneouslyType_outer) {
#ifdef DEBUG
        NSLog(@"outer scrollview scrolling ...");
#endif
        GMultiDelegate * m_delegate = item.delegate;
        id<GSimultaneouslyProtocol> delegate = [m_delegate lastDelegate];
        CGPoint criticalPoint = CGPointZero;
        if (delegate && [delegate respondsToSelector:@selector(fetchCriticalPoint:)]) {
            criticalPoint = [delegate fetchCriticalPoint:scrollView];
        }
        if (self.criticalState) {
            [scrollView setContentOffset:criticalPoint animated:NO];
        }
        BOOL can = YES;
        if (delegate && [delegate respondsToSelector:@selector(headerViewCanStretchy)]) {
            can = [delegate headerViewCanStretchy];
        }
        if (!scrollView.bounces) {
            self.outerBounces = YES;
        } else {
            self.outerBounces = can;
        }
        self.outerBounces = !can;
    } else if (item && item.type == GSimultaneouslyType_inner) {
#ifdef DEBUG
         NSLog(@"inner scrollview scrolling ...");
#endif
        GMultiDelegate * m_delegate = item.delegate;
        id<GSimultaneouslyProtocol> delegate = [m_delegate lastDelegate];
        
        CGPoint criticalPoint = CGPointZero;
        if (delegate && [delegate respondsToSelector:@selector(fetchCriticalPoint:)]) {
            criticalPoint = [delegate fetchCriticalPoint:scrollView];
        }
     
        if (scrollView.contentOffset.y <= criticalPoint.y && self.beginDrag) {
            [self reachInnerScrollToCriticalPoint];
        }
        if (!self.criticalState && !self.outerBounces) {
            [scrollView setContentOffset:criticalPoint animated:NO];
        }
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
#ifdef DEBUG
    NSLog(@"scrollViewWillBeginDragging");
#endif
    GSimultaneouslyItem * item = [self.mapTable objectForKey:scrollView];
    if (item && item.type == GSimultaneouslyType_outer) {
        
    } else if (item && item.type == GSimultaneouslyType_inner) {
        self.beginDrag = YES;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
#ifdef DEBUG
    NSLog(@"scrollViewDidEndDragging");
#endif
    GSimultaneouslyItem * item = [self.mapTable objectForKey:scrollView];
    if (item && item.type == GSimultaneouslyType_outer) {
        
    } else if (item && item.type == GSimultaneouslyType_inner) {
        self.beginDrag = NO;
    }
}

@end
