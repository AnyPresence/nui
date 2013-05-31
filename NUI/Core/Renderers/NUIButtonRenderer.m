//
//  NUIButtonRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIButtonRenderer.h"
#import "NUIViewRenderer.h"

@implementation NUIButtonRenderer

+ (void)render:(UIButton*)button withClass:(NSString*)className
{
    // UIButtonTypeRoundedRect's first two sublayers contain its background and border, which
    // need to be hidden for NUI's rendering to be displayed correctly. Ideally we would switch
    // over to a UIButtonTypeCustom, but this appears to be impossible.
    if (button.buttonType == UIButtonTypeRoundedRect) {
        if ([button.layer.sublayers count] > 2) {
            [button.layer.sublayers[0] setOpacity:0.0f];
            [button.layer.sublayers[1] setOpacity:0.0f];
        }
    }

    // Set padding
    if ([NUISettings hasProperty:@"padding" withClass:className]) {
        [button setTitleEdgeInsets:[NUISettings getEdgeInsets:@"padding" withClass:className]];
    }
    
    // Background and text
    [NUIViewRenderer renderBackground:button withClass:className];
    [NUILabelRenderer renderText:button.titleLabel withClass:className];
    
    // Set text align
    if ([NUISettings hasProperty:@"text-align" withClass:className]) {
        [button setContentHorizontalAlignment:[NUISettings getControlContentHorizontalAlignment:@"text-align" withClass:className]];
    }
    
    // Set font color
    if ([NUISettings hasProperty:@"font-color" withClass:className]) {
        [button setTitleColor:[NUISettings getColor:@"font-color" withClass:className] forState:UIControlStateNormal];
    }
    if ([NUISettings hasProperty:@"font-color-selected" withClass:className]) {
        [button setTitleColor:[NUISettings getColor:@"font-color-selected" withClass:className] forState:UIControlStateSelected];
    }
    if ([NUISettings hasProperty:@"font-color-highlighted" withClass:className]) {
        [button setTitleColor:[NUISettings getColor:@"font-color-highlighted" withClass:className] forState:UIControlStateHighlighted];
    }
    if ([NUISettings hasProperty:@"font-color-disabled" withClass:className]) {
        [button setTitleColor:[NUISettings getColor:@"font-color-disabled" withClass:className] forState:UIControlStateDisabled];
    }
    
    // Set text shadow color
    if ([NUISettings hasProperty:@"text-shadow-color" withClass:className]) {
        [button setTitleShadowColor:[NUISettings getColor:@"text-shadow-color" withClass:className] forState:UIControlStateNormal];
    }
    if ([NUISettings hasProperty:@"text-shadow-color-selected" withClass:className]) {
        [button setTitleShadowColor:[NUISettings getColor:@"text-shadow-color-selected" withClass:className] forState:UIControlStateSelected];
    }
    if ([NUISettings hasProperty:@"text-shadow-color-highlighted" withClass:className]) {
        [button setTitleShadowColor:[NUISettings getColor:@"text-shadow-color-highlighted" withClass:className] forState:UIControlStateHighlighted];
    }
    
    // title insets
    if ([NUISettings hasProperty:@"title-insets" withClass:className]) {
        [button setTitleEdgeInsets:[NUISettings getEdgeInsets:@"title-insets" withClass:className]];
    }
    
    // content insets
    if ([NUISettings hasProperty:@"content-insets" withClass:className]) {
        [button setContentEdgeInsets:[NUISettings getEdgeInsets:@"content-insets" withClass:className]];
    }
    
    [NUIViewRenderer renderBorder:button withClass:className];
    
    // We need to apply the corner radius to all sublayers so that the shadow displays correctly
    if ([NUISettings hasProperty:@"corner-radius" withClass:className]) {
        CGFloat r = [NUISettings getFloat:@"corner-radius" withClass:className];
        for (CALayer* layer in button.layer.sublayers) {
            layer.cornerRadius = r;
        }
    }

    [NUIViewRenderer renderSize:button withClass:className];
    [NUIViewRenderer renderShadow:button withClass:className];
}

@end
