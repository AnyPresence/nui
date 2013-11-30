//
//  UIProgressView+NUI.m
//  NUIDemo
//
//  Created by Christopher Cotton on 3/13/13.
//  Copyright (c) 2013 Tom Benner. All rights reserved.
//

#import "NUIObserver.h"
#import "UIProgressView+NUI.h"

@implementation UIProgressView (NUI)

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"Progress";
    }
}

- (void)applyNUI
{
    if ([self isMemberOfClass:[UIProgressView class]] || self.nuiClass) {
        
        [self initNUI];
        if (![self.nuiClass isEqualToString:kNUIClassNone]) {
            [NUIRenderer renderProgressView:self withClass:self.nuiClass];
        }
    }
    
    self.nuiApplied = YES;
}

- (void)override_didMoveToWindow
{
    if (!self.isNUIApplied) {
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
