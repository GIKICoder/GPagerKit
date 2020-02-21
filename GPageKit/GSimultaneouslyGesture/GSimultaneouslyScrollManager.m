//
//  GSimultaneouslyScrollManager.m
//  GPagerKitExample
//
//  Created by GIKI on 2020/2/21.
//  Copyright © 2020 GIKI. All rights reserved.
//

#import "GSimultaneouslyScrollManager.h"
#import "GSimultaneouslyGestureProcessor.h"

@interface GSimultaneouslyScrollManager ()

@end

@implementation GSimultaneouslyScrollManager

+ (instancetype)sharedInstance
{
    static GSimultaneouslyScrollManager * INST = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INST = [[GSimultaneouslyScrollManager alloc] init];
    });
    return INST;
}

@end
