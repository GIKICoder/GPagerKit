//
//  NSObject+GSimultaneously.h
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/21.
//  Copyright © 2020 GIKI. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GSimultaneouslyGestureProcessor.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GSimultaneously)
@property (nonatomic, strong) GSimultaneouslyGestureProcessor * gesutreProcessor;
@end

NS_ASSUME_NONNULL_END
