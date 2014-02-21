//
//  NUINavigationBarRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUINavigationBarRenderer.h"

@implementation NUINavigationBarRenderer

+ (void)render:(UINavigationBar*)bar withClass:(NSString*)className
{
    if ([NUISettings hasProperty:@"background-tint-color" withClass:className]) {
        if ([bar respondsToSelector:@selector(setBarTintColor:)]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
            [bar setBarTintColor:[NUISettings getColor:@"background-tint-color" withClass:className]];
#endif
        } else {
            [bar setTintColor:[NUISettings getColor:@"background-tint-color" withClass:className]];
        }
    }
    
    if ([NUISettings hasProperty:@"shadow-image" withClass:className]) {
        [bar setShadowImage:[NUISettings getImage:@"shadow-image" withClass:className]];
    }
    
    [NUIViewRenderer renderBorder:bar withClass:className];
    [self renderSizeDependentProperties:bar];
    
    NSDictionary *titleTextAttributes = [NUIUtilities titleTextAttributesForClass:className];
    
    if ([[titleTextAttributes allKeys] count] > 0) {
        bar.titleTextAttributes = titleTextAttributes;
    }
}

+ (void)sizeDidChange:(UINavigationBar*)bar
{
    [self renderSizeDependentProperties:bar];
}

+ (void)renderSizeDependentProperties:(UINavigationBar*)bar
{
    NSString *className = bar.nuiClass;
    
    UIColor * backgroundColor = bar.backgroundColor;
    if ([NUISettings hasProperty:@"background-color" withClass:className]) {
        backgroundColor = [NUISettings getColor:@"background-color" withClass:className];
        
        if ([bar respondsToSelector:@selector(setBarTintColor:)]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
            bar.barTintColor = backgroundColor;
#endif
        } else {
            bar.tintColor = backgroundColor;
        }
    }

    UIImage * patternImage = [NUIViewRenderer backgroundPatternImage:backgroundColor withClass:className size:bar.bounds.size];
    if (patternImage) {
        [bar setBackgroundImage:patternImage forBarMetrics:UIBarMetricsDefault];
    }
}

@end
