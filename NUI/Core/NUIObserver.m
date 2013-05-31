//
//  NUIObserver.m
//  AnyPresence
//
//  Created by Ruslan Sokolov on 5/30/13.
//
//

#import "NUIObserver.h"

@interface NUIObserverItem : NSObject

@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSString * keyPath;
@property (nonatomic, assign) SEL selector;

@end

@interface NUIObserver ()

@property (nonatomic, strong) NSMutableArray * items;

+ (NUIObserver *)instance;
- (void)addObserverTo:(id)object forKeyPath:(NSString *)keyPath selector:(SEL)selector;
- (void)removeObserverFrom:(id)object forKeyPath:(NSString *)keyPath selector:(SEL)selector;

@end

@implementation NUIObserver

#pragma mark - Public

+ (void)addObserverTo:(id)object forKeyPath:(NSString *)keyPath selector:(SEL)selector {
    [[self instance] addObserverTo:object forKeyPath:keyPath selector:selector];
}

+ (void)removeObserverFrom:(id)object forKeyPath:(NSString *)keyPath selector:(SEL)selector {
    [[self instance] removeObserverFrom:object forKeyPath:keyPath selector:selector];
}

#pragma mark - Private

+ (NUIObserver *)instance {
    static NUIObserver * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NUIObserver new];
    });
    
    return instance;
}

- (void)addObserverTo:(id)object forKeyPath:(NSString *)keyPath selector:(SEL)selector {
    NUIObserverItem * item = [NUIObserverItem new];
    item.object = object;
    item.keyPath = keyPath;
    item.selector = selector;
    
    if (!self.items)
        self.items = [NSMutableArray new];
    [self.items addObject:item];
    
    [object addObserver:self forKeyPath:keyPath options:0 context:nil];
}

- (void)removeObserverFrom:(id)object forKeyPath:(NSString *)keyPath selector:(SEL)selector {
    NSInteger idx = [self.items indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NUIObserverItem * item = (NUIObserverItem *)obj;
        *stop = item.object == object && [item.keyPath isEqualToString:keyPath] && item.selector == selector;
        return *stop;
    }];
    
    if (idx != NSNotFound) {
        [object removeObserver:self forKeyPath:keyPath];
        [self.items removeObjectAtIndex:idx];
    }
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    BOOL handled = NO;
    for (NUIObserverItem * item in [self.items copy]) {
        if (item.object == object && [keyPath isEqualToString:item.keyPath]) {
            handled = YES;
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [item.object performSelector:item.selector];
#pragma clang diagnostic pop
        }
    }
    
    if (!handled)
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end

@implementation NUIObserverItem

@end