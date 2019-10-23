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

@class GSimultaneouslyGestureProcessor;
@interface NSObject (GestureProcessor)

@property (nonatomic, weak  ) GSimultaneouslyGestureProcessor * weakProcessor;

@end

@interface GSimultaneouslyGestureProcessor : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak  ) UIScrollView * outerScrollView;
@property (nonatomic, weak  ) UIScrollView * innerScrollView;

@property (nonatomic, assign) BOOL  reachCriticalPoint;
@property (nonatomic, assign) CGPoint  criticalPoint;

- (GMultiDelegate *)registerMultiDelegate:(id)delegate;
@end

NS_ASSUME_NONNULL_END
