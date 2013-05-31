//
//  UITableViewCell+NUI.m
//  NUIDemo
//
//  Created by Tom Benner on 12/9/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIObserver.h"
#import "UITableViewCell+NUI.h"

@implementation UITableViewCell (NUI)

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"TableCell";
    }
}

- (void)applyNUI
{
    [self initNUI];
    if (![self.nuiClass isEqualToString:@"none"]) {
        [NUIRenderer renderTableViewCell:self withClass:self.nuiClass];
        [NUIRenderer addOrientationDidChangeObserver:self];
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

- (void)orientationDidChange:(NSNotification*)notification
{
    [NUIRenderer performSelector:@selector(sizeDidChangeForTableViewCell:) withObject:self afterDelay:0];
}

@end
