//
//  NUILabelRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUILabelRenderer.h"
#import "NUIViewRenderer.h"

@implementation NUILabelRenderer

+ (void)render:(UILabel*)label withClass:(NSString*)className
{
    [self render:label withClass:className withSuffix:@""];
}

+ (void)render:(UILabel*)label withClass:(NSString*)className withSuffix:(NSString*)suffix
{
    if (![suffix isEqualToString:@""]) {
        className = [NSString stringWithFormat:@"%@%@", className, suffix];
    }
    
    [NUIViewRenderer renderBackground:label withClass:className];
    [NUIViewRenderer renderSize:label withClass:className];
    [NUIViewRenderer renderBorder:label withClass:className];
    [NUIViewRenderer renderShadow:label withClass:className];
    [self renderText:label withClass:className];
    [NUIViewRenderer renderExtendedProperties:label withClass:className];
}

+ (void)renderText:(UILabel*)label withClass:(NSString*)className
{
    NSString *property;
    
    property = @"font-color";
    if ([NUISettings hasProperty:property withClass:className]) {
        label.textColor = [NUISettings getColor:property withClass:className];
    }
    
    property = @"font-color-highlighted";
    if ([NUISettings hasProperty:property withClass:className]) {
        label.highlightedTextColor = [NUISettings getColor:property withClass:className];
    }
    
    property = @"font-size";
    if ([NUISettings hasProperty:property withClass:className]) {
        label.font = [label.font fontWithSize:[NUISettings getFloat:property withClass:className]];
    }
    
    property = @"font-name";
    if ([NUISettings hasProperty:property withClass:className]) {
        label.font = [UIFont fontWithName:[NUISettings get:property withClass:className] size:label.font.pointSize];
    }
    
    property = @"text-align";
    if ([NUISettings hasProperty:property withClass:className]) {
        label.textAlignment = [NUISettings getTextAlignment:property withClass:className];
    }
    
    property = @"text-alpha";
    if ([NUISettings hasProperty:property withClass:className]) {
        label.alpha = [NUISettings getFloat:property withClass:className];
    }
    
    property = @"text-auto-fit";
    if ([NUISettings hasProperty:property withClass:className]) {
        [label setAdjustsFontSizeToFitWidth:[NUISettings getBoolean:property withClass:className]];
    }
    
    property = @"text-shadow-color";
    if ([NUISettings hasProperty:property withClass:className]) {
        label.shadowColor = [NUISettings getColor:property withClass:className];
    }
    
    property = @"text-shadow-offset";
    if ([NUISettings hasProperty:property withClass:className]) {
        label.shadowOffset = [NUISettings getSize:property withClass:className];
    }
}

@end
