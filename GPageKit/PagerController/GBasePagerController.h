//
//  GBasePagerController.h
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/16.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSimultaneouslyGestureProcessor.h"
NS_ASSUME_NONNULL_BEGIN

@interface GBasePagerController : UIViewController

@property (nonatomic, weak  ) GSimultaneouslyGestureProcessor * gestureProcessor;

@property (nonatomic, assign, readonly) NSInteger  currentPageIndex;

@property (nonatomic, strong, readonly) __kindof UIViewController *currentViewController;
@end

NS_ASSUME_NONNULL_END
