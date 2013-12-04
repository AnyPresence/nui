//
//  UITableViewCell+NUI.m
//  AnyPresence
//
//  Created by Ruslan Sokolov on 8/31/13.
//
//

#import "NUIObserver.h"
#import "UICollectionViewCell+NUI.h"

@implementation UICollectionViewCell (NUI)

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"CollectionCell";
    }
}

- (void)applyNUI
{
    [self initNUI];
    if (![self.nuiClass isEqualToString:@"none"]) {
        [NUIRenderer renderCollectionViewCell:self withClass:self.nuiClass];
        [NUIRenderer addOrientationDidChangeObserver:self];
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

- (void)orientationDidChange:(NSNotification*)notification
{
    [NUIRenderer performSelector:@selector(sizeDidChangeForCollectionViewCell:) withObject:self afterDelay:0];
}

@end
