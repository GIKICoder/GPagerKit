//
//  GSimultaneouslyGestureProcessor.h
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/22.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GSimultaneouslyGestureProcessor : NSObject

@property (nonatomic, weak  ) UIScrollView * outerScrollView;
@property (nonatomic, weak  ) UIScrollView * innerScrollView;

@property (nonatomic, assign) BOOL  reachCriticalPoint;
@property (nonatomic, assign) CGPoint  criticalPoint;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
