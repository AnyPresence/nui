//
//  NUITextViewRenderer.m
//  AnotherTest
//
//  Created by Ruslan Sokolov on 5/30/13.
//
//

#import "NUITextViewRenderer.h"
#import "NUIViewRenderer.h"

@implementation NUITextViewRenderer

+ (void)render:(UITextView*)label withClass:(NSString*)className
{
    [self render:label withClass:className withSuffix:@""];
}

+ (void)render:(UITextView*)label withClass:(NSString*)className withSuffix:(NSString*)suffix
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

+ (void)renderText:(UITextView*)label withClass:(NSString*)className
{
    NSString *property;
    
    property = @"font-color";
    if ([NUISettings hasProperty:property withClass:className]) {
        label.textColor = [NUISettings getColor:property withClass:className];
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
}

@end
