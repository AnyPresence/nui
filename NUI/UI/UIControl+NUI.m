//
//  UIControl+NUI.m
//  NUIDemo
//
//  Created by Alejandro Isaza on 13-01-30.
//  Copyright (c) 2013 Tom Benner. All rights reserved.
//

#import "NUIObserver.h"
#import "UIControl+NUI.h"

@implementation UIControl (NUI)

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"Control";
    }
}

- (void)applyNUI
{
    // Styling shouldn't be applied to inherited classes, unless nuiClass is
    // explictly set
    if ([self class] == [UIControl class] || self.nuiClass) {
        [self initNUI];
        if (![self.nuiClass isEqualToString:@"none"]) {
            [NUIRenderer renderView:self withClass:self.nuiClass];
        }
    }
    self.nuiIsApplied = [NSNumber numberWithBool:YES];
}

- (void)override_didMoveToWindow
{
    if (!self.nuiIsApplied) {
        [self applyNUI];
    }
    
    if (self.window) {
        [NUIObserver addObserverTo:self forKeyPath:@"frame" selector:@selector(applyNUI)];
    } else {
        [NUIObserver removeObserverFrom:self forKeyPath:@"frame" selector:@selector(applyNUI)];
    }
    
    [self override_didMoveToWindow];
}

@end
