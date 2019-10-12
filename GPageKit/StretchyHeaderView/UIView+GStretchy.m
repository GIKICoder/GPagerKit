//
//  UIView+GStretchy.m
//  GPagerKitExample
//
//  Created by GIKI on 2019/10/11.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "UIView+GStretchy.h"

@interface NSLayoutConstraint (GSKTransplantSubviews)

- (NSLayoutConstraint *)g_copyWithFirstItem:(id)firstItem secondItem:(id)secondItem;

@end

@implementation NSLayoutConstraint (GSKTransplantSubviews)

- (NSLayoutConstraint *)g_copyWithFirstItem:(id)firstItem secondItem:(id)secondItem {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                  attribute:self.firstAttribute
                                                                  relatedBy:self.relation
                                                                     toItem:secondItem
                                                                  attribute:self.secondAttribute
                                                                 multiplier:self.multiplier
                                                                   constant:self.constant];
    constraint.identifier = self.identifier;
    if ([self respondsToSelector:@selector(isActive)]) {
        constraint.active = self.active;
    }
    return constraint;
}

@end

@implementation UIView (GStretchy)

- (BOOL)g_isSelfOrLayoutGuide:(id)object {
    // We can't transplant constraints to layout guides like safe area insets (introduced in iOS 11)
    // So we assume the constraints will be related to the superview
    // This may become a problem if the safe area insets are not zero, but for header views it's always the case
    if (object == self) {
        return true;
    } else if (@available(iOS 9.0, *)) {
        return [object isKindOfClass:[UILayoutGuide class]];
    }
    return false;
}

- (void)g_transplantSubviewsToView:(UIView *)newSuperview {
    NSArray<UIView *> *oldSubviews = self.subviews;
    NSArray<NSLayoutConstraint *> *oldConstraints = self.constraints;
    NSMutableArray<NSNumber *> *oldConstraintsActiveValues = [NSMutableArray array];
    
    if ([NSLayoutConstraint instancesRespondToSelector:@selector(isActive)]) {
        for (NSLayoutConstraint *constraint in oldConstraints) {
            [oldConstraintsActiveValues addObject:@(constraint.active)];
        }
    }
    
    for (UIView *view in oldSubviews) {
        [view removeFromSuperview];
        [newSuperview addSubview:view];
    }
    
    [self removeConstraints:oldConstraints];
    [oldConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *oldConstraint, NSUInteger index, BOOL *stop) {
        id firstItem = [self g_isSelfOrLayoutGuide:oldConstraint.firstItem] ? newSuperview : oldConstraint.firstItem;
        id secondItem = [self g_isSelfOrLayoutGuide:oldConstraint.secondItem] ? newSuperview : oldConstraint.secondItem;
        NSLayoutConstraint *constraint = [oldConstraint g_copyWithFirstItem:firstItem
                                                                   secondItem:secondItem];
        if ([constraint respondsToSelector:@selector(setActive:)]) {
            constraint.active = oldConstraintsActiveValues[index].boolValue;
        } else {
            [newSuperview addConstraint:constraint];
        }
    }];
}

@end
