//
//  NUIToolbarRenderer.m
//  NUIDemo
//
//  Created by Simon Moser @savage7 on 09/01/13.
//  Copyright (c) 2013 Simon Moser. All rights reserved.
//

#import "NUIObserver.h"
#import "UIToolbar+NUI.h"

@implementation UIToolbar (NUI)

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"Toolbar";
    }
}

- (void)applyNUI
{
    [self initNUI];
    if (![self.nuiClass isEqualToString:@"none"]) {
        [NUIRenderer renderToolbar:self withClass:self.nuiClass];
        
        for (UIBarButtonItem *barButtonItem in [self items]) {
            [barButtonItem applyNUI];
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
