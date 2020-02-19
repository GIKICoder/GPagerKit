//
//  GMultiDelegate.h
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/23.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMultiDelegate : NSObject

@property (readonly, nonatomic) NSPointerArray* delegates;
@property (nonatomic, assign) BOOL silentWhenEmpty;

- (instancetype)initWithDelegates:(NSArray*)delegates;

- (void)addDelegate:(id)delegate;
- (void)addDelegate:(id)delegate beforeDelegate:(id)otherDelegate;
- (void)addDelegate:(id)delegate afterDelegate:(id)otherDelegate;

- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

- (id)lastDelegate;
@end

NS_ASSUME_NONNULL_END
