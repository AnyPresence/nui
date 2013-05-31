//
//  NUIObserver.h
//  AnyPresence
//
//  Created by Ruslan Sokolov on 5/30/13.
//
//

#import <Foundation/Foundation.h>

@interface NUIObserver : NSObject

+ (void)addObserverTo:(id)object forKeyPath:(NSString *)keyPath selector:(SEL)selector;
+ (void)removeObserverFrom:(id)object forKeyPath:(NSString *)keyPath selector:(SEL)selector;

@end
