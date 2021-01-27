//
//  GSimultaneouslyGestureProcessor.h
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/22.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GMultiDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@protocol GSimultaneouslyProtocol <NSObject>
@optional
- (UIScrollView *)currentScrollView;
- (CGPoint)fetchCriticalPoint:(UIScrollView *)scrollView;
- (BOOL)headerViewCanStretchy;
@end

typedef NS_ENUM(NSUInteger, GSimultaneouslyType) {
    GSimultaneouslyType_outer,
    GSimultaneouslyType_inner,
};

@interface GSimultaneouslyGestureProcessor : NSObject

- (GMultiDelegate *)registerMultiDelegate:(id<GSimultaneouslyProtocol>)delegate type:(GSimultaneouslyType)type;
- (void)reachOuterScrollToCriticalPoint;
- (void)reachInnerScrollToCriticalPoint;
- (void)resetStatus;
- (void)destory;
@end

NS_ASSUME_NONNULL_END
