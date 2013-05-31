//
//  UITextView+NUI.m
//  AnyPresence
//
//  Created by Ruslan Sokolov on 5/30/13.
//
//

#import "NUIObserver.h"
#import "UITextView+NUI.h"

@implementation UITextView (NUI)

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"TextView";
    }
}

- (void)applyNUI
{
    // Styling shouldn't be applied to inherited classes or to labels within other views
    // (e.g. UITableViewCellContentView), unless nuiClass is explictly set
    if (([self class] == [UITextView class] &&
         [[self superview] class] == [UIView class]) || self.nuiClass) {
        [self initNUI];
        if (![self.nuiClass isEqualToString:@"none"]) {
            [NUIRenderer renderTextView:self withClass:self.nuiClass];
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

