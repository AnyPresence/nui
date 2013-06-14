//
//  NUIBarButtonItemRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIBarButtonItemRenderer.h"

@implementation NUIBarButtonItemRenderer

+ (void)render:(UIBarButtonItem*)item withClass:(NSString*)className
{
    if ([NUISettings hasProperty:@"width" withClass:className]) {
        CGFloat width = [NUISettings getFloat:@"width" withClass:className relativeTo:CGRectGetWidth([UIScreen mainScreen].applicationFrame)];
        item.width = width;
    }
    
    if ([NUISettings hasProperty:@"background-tint-color" withClass:className]) {
        [item setTintColor:[NUISettings getColor:@"background-tint-color" withClass:className]];
    } else if ([NUISettings hasProperty:@"background-color" withClass:className] ||
               [NUISettings hasProperty:@"background-image" withClass:className] ||
               [NUISettings hasProperty:@"background-image-tile" withClass:className] ||
               [NUISettings hasProperty:@"background-image-stretch" withClass:className] ||
               [NUISettings hasProperty:@"background-image-offset-x" withClass:className] ||
               [NUISettings hasProperty:@"background-image-offset-y" withClass:className] ||
               [NUISettings hasProperty:@"background-color-top" withClass:className] ||
               [NUISettings hasProperty:@"background-color-bottom" withClass:className] ||
               [NUISettings hasProperty:@"border-color" withClass:className] ||
               [NUISettings hasProperty:@"border-width" withClass:className] ||
               [NUISettings hasProperty:@"corner-radius" withClass:className]) {
        CALayer *layer = [CALayer layer];
        [layer setFrame:CGRectMake(0, 0, 30, 26)];
        [layer setMasksToBounds:YES];
        
        UIColor * backgroundColor = [UIColor clearColor];
        if ([NUISettings hasProperty:@"background-color" withClass:className]) {
            backgroundColor = [NUISettings getColor:@"background-color" withClass: className];
            layer.backgroundColor = backgroundColor.CGColor;
        }
        
        UIImage * patternImage = [NUIViewRenderer backgroundPatternImage:backgroundColor withClass:className size:layer.bounds.size];
        if (patternImage) {
            layer.backgroundColor = [UIColor colorWithPatternImage:patternImage].CGColor;
        }
        
        if ([NUISettings hasProperty:@"border-color" withClass:className]) {
            [layer setBorderColor:[[NUISettings getColor:@"border-color" withClass:className] CGColor]];
        }
        
        if ([NUISettings hasProperty:@"border-width" withClass:className]) {
            [layer setBorderWidth:[NUISettings getFloat:@"border-width" withClass:className]];
        }
        
        float cornerRadius = [NUISettings getFloat:@"corner-radius" withClass:className];
        float insetLength = cornerRadius;
        
        if (cornerRadius < 5) {
            insetLength = 5;
        }
        insetLength += 3;
        
        if ([NUISettings hasProperty:@"corner-radius" withClass:className]) {
            [layer setCornerRadius:[NUISettings getFloat:@"corner-radius" withClass:className]];
        }
        
        UIEdgeInsets insets = UIEdgeInsetsMake(insetLength, insetLength, insetLength, insetLength);
        UIImage *image = [NUIGraphics caLayerToUIImage:layer];
        if ([image respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        } else {
            image = [image resizableImageWithCapInsets:insets];
        }
        
        [item setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
    NSDictionary *titleTextAttributes = [NUIUtilities titleTextAttributesForClass:className];
    
    if ([[titleTextAttributes allKeys] count] > 0) {
        [item setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
}

@end
