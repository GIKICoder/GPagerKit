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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapTable = [[NSMapTable alloc] initWithKeyOptions:(NSPointerFunctionsWeakMemory) valueOptions:(NSPointerFunctionsStrongMemory) capacity:0];
        self.criticalPoint = CGPointZero;
    }
    return self;
}

- (GMultiDelegate *)registerMultiDelegate:(id<GSimultaneouslyProtocol>)delegate type:(GSimultaneouslyType)type
{
    GMultiDelegate * multi = [[GMultiDelegate alloc] initWithDelegates:@[self,delegate]];
    GSimultaneouslyItem * item = [[GSimultaneouslyItem alloc] init];
    item.type = type;
    item.delegate = multi;
    UIScrollView * scrollView = [delegate currentScrollView];
    NSAssert(scrollView, @"delegate must be impl currentScrollView");
    [self.mapTable setObject:item forKey:scrollView];
    return multi;
}

- (void)destory
{
    [self.mapTable removeAllObjects];
    self.reachCriticalPoint = NO;
    self.criticalPoint = CGPointZero;
}

- (void)dealloc
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    GSimultaneouslyItem * item = [self.mapTable objectForKey:scrollView];
    if (item && item.type == GSimultaneouslyType_outer) {
        NSLog(@"outer scrollview scrolling ...");
        if (self.reachCriticalPoint) {
            [scrollView setContentOffset:self.criticalPoint animated:NO];
        }
    } else if (item && item.type == GSimultaneouslyType_inner) {
         NSLog(@"inner scrollview scrolling ...");
        if (scrollView.contentOffset.y < 0) {
            self.reachCriticalPoint = NO;
        }
        if (!self.reachCriticalPoint) {
            [scrollView setContentOffset:CGPointZero animated:NO];
        }
        
    }
}


@end
