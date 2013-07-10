//
//  UIWebView+NUI.m
//  AnyPresence
//
//  Created by Ruslan Sokolov on 6/4/13.
//
//

#import "NUIObserver.h"
#import "UIWebView+NUI.h"

@implementation UIWebView (NUI)

@dynamic nuiClass;

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"View";
    }
}

- (void)applyNUI
{
    // Styling shouldn't be applied to inherited classes, unless nuiClass is explictly set
    if (([self class] == [UIView class] && [[self superview] class] != [UINavigationBar class]) || self.nuiClass) {
        [self initNUI];
        if (![self.nuiClass isEqualToString:@"none"]) {
            [NUIRenderer renderWebView:self withClass:self.nuiClass];
        }
    }
    self.nuiIsApplied = [NSNumber numberWithBool:YES];
}

- (void)override_didMoveToWindow
{
    if (!self.nuiIsApplied) {
        [self applyNUI];
    }
    
    static dispatch_source_t timer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.f * NSEC_PER_SEC, .5f * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            [NUIRenderer renderWebViewCSS:self withClass:self.nuiClass];
        });
    });
    
    if (self.window) {
        //dispatch_resume(timer);
        [NUIObserver addObserverTo:self forKeyPath:@"frame" selector:@selector(applyNUI)];
    } else {
        //dispatch_suspend(timer);
        [NUIObserver removeObserverFrom:self forKeyPath:@"frame" selector:@selector(applyNUI)];
    }
    
    [self override_didMoveToWindow];
}

- (void)setNuiClass:(NSString*)value {
    objc_setAssociatedObject(self, "nuiClass", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)nuiClass {
    return objc_getAssociatedObject(self, "nuiClass");
}

- (void)setNuiIsApplied:(NSNumber*)value {
    objc_setAssociatedObject(self, "nuiIsApplied", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber*)nuiIsApplied {
    return objc_getAssociatedObject(self, "nuiIsApplied");
}

@end
