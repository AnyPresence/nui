//
//  NUITabBarRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUITabBarRenderer.h"

@implementation NUITabBarRenderer

+ (void)render:(UITabBar*)bar withClass:(NSString*)className
{    
    if ([NUISettings hasProperty:@"selected-image" withClass:className]) {
        [bar setSelectionIndicatorImage:[NUISettings getImage:@"selected-image" withClass:className]];
    }
    
    if ([NUISettings hasProperty:@"selected-image-tint-color" withClass:className]) {
        [bar setSelectedImageTintColor:[NUISettings getColor:@"selected-image-tint-color" withClass:className]];
    }
    
    [NUIViewRenderer renderBorder:bar withClass:className];
    [self renderSizeDependentProperties:bar];
    
    // Apply UITabBarItem's background-image-selected property to bar.selectionIndicatorImage
    if ([[bar items] count] > 0) {
        UITabBarItem *firstItem = [[bar items] objectAtIndex:0];
        NSArray *firstItemClasses = [firstItem.nuiClass componentsSeparatedByString: @":"];
        for (NSString *itemClass in firstItemClasses) {
            if ([NUISettings hasProperty:@"background-image-selected" withClass:itemClass]) {
                [bar setSelectionIndicatorImage:[NUISettings getImage:@"background-image-selected" withClass:itemClass]];
            }
        }
    }
}

+ (void)sizeDidChange:(UITabBar*)bar
{
    [self renderSizeDependentProperties:bar];
}

+ (void)renderSizeDependentProperties:(UITabBar*)bar
{
    NSString * className = bar.nuiClass;
    if (bar.nuiClass) {
        UIColor * backgroundColor = bar.backgroundColor;
        if ([NUISettings hasProperty:@"background-color" withClass:className]) {
            backgroundColor = [NUISettings getColor:@"background-color" withClass:className];
            
            bar.tintColor = backgroundColor;
        }
        
        UIImage * patternImage = [NUIViewRenderer backgroundPatternImage:backgroundColor withClass:className size:bar.bounds.size];
        bar.backgroundImage = patternImage;
        
        NSString * activeClassName = [NSString stringWithFormat:@"%@Active", className];
        if ([NUISettings hasProperty:@"background-tint-color" withClass:activeClassName]) {
            if ([bar respondsToSelector:@selector(setBarTintColor:)]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
                [bar setBarTintColor:[NUISettings getColor:@"background-tint-color" withClass:activeClassName]];
#endif
            } else {
                [bar setTintColor:[NUISettings getColor:@"background-tint-color" withClass:activeClassName]];
            }
        } else {
            NSMutableArray * properties = [[NUIViewRenderer backgroundPatternImageProperties] mutableCopy];
            [properties removeObject:@"background-image"];
            [properties removeObject:@"background-image-stretch"];
            [properties removeObject:@"background-image-tile"];
            [properties removeObject:@"background-image-offset-x"];
            [properties removeObject:@"background-image-offset-y"];
            [properties addObject:@"background-color"];
            
            for (NSString * property in properties) {
                if ([NUISettings hasProperty:property withClass:activeClassName]) {
                    float borderWidth = [NUISettings getFloat:@"border-width" withClass:activeClassName];
                    float cornerRadius = [NUISettings getFloat:@"corner-radius" withClass:activeClassName];
                    
                    CALayer * layer = [CALayer new];
                    layer.frame = CGRectMake(0.f, 0.f, cornerRadius * 2.f + borderWidth * 2.f + 1.f, CGRectGetHeight(bar.bounds));
                    layer.masksToBounds = YES;
                    
                    UIColor * backgroundColor = [UIColor clearColor];
                    if ([NUISettings hasProperty:@"background-color" withClass:activeClassName]) {
                        backgroundColor = [NUISettings getColor:@"background-color" withClass:activeClassName];
                        
                        layer.backgroundColor = backgroundColor.CGColor;
                    }
                    
                    UIImage * patternImage = [NUIViewRenderer backgroundPatternImage:backgroundColor withClass:activeClassName size:bar.bounds.size properties:properties];
                    if (patternImage) {
                        layer.backgroundColor = [UIColor colorWithPatternImage:patternImage].CGColor;
                    }
                    
                    if ([NUISettings hasProperty:@"border-color" withClass:activeClassName]) {
                        layer.borderColor = [[NUISettings getColor:@"border-color" withClass:activeClassName] CGColor];
                    }
                    
                    if ([NUISettings hasProperty:@"border-width" withClass:activeClassName]) {
                        layer.borderWidth = borderWidth;
                    }

                    if ([NUISettings hasProperty:@"corner-radius" withClass:activeClassName]) {
                        layer.cornerRadius = cornerRadius;
                    }

                    UIEdgeInsets insets = UIEdgeInsetsMake(0.f, CGRectGetWidth(layer.bounds) / 2.f, 0.f, CGRectGetWidth(layer.bounds) / 2.f);
                    UIImage *image = [NUIGraphics caLayerToUIImage:layer];
                    if ([image respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
                        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
                    } else {
                        image = [image resizableImageWithCapInsets:insets];
                    }

                    bar.selectionIndicatorImage = image;
                    
                    break;
                }
            }
        }
    }
}

@end
