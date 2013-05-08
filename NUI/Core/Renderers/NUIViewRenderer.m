//
//  NUIViewRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NUIGraphics.h"
#import "NUIViewRenderer.h"
#import "UIView+NUI.h"

@interface NUIViewRenderer ()

+ (void)removeSublayer:(CALayer *)layer withName:(NSString *)name;

@end

@implementation NUIViewRenderer

+ (void)render:(UIView*)view withClass:(NSString*)className
{
    if ([NUISettings hasProperty:@"background-color" withClass:className]) {
        [view setBackgroundColor: [NUISettings getColor:@"background-color" withClass: className]];
    }
    
    if ([NUISettings hasProperty:@"background-image" withClass:className]) {
        static NSString * name = @"AP:NUI:bgImageLayer";
        
        CALayer * layer = [CALayer new];
        layer.frame = view.bounds;
        layer.name = name;
        
        if ([NUISettings hasProperty:@"background-image-tile" withClass:className] &&
            [NUISettings getBoolean:@"background-image-tile" withClass:className]) {
            layer.geometryFlipped = YES;
            layer.transform = CATransform3DMakeScale(1.f, -1.f, 1.f);
            layer.backgroundColor = [NUISettings getColorFromImage:@"background-image" withClass:className].CGColor;
        } else {
            UIImage * image = [NUISettings getImage:@"background-image" withClass:className];
            layer.contents = (__bridge id)image.CGImage;
            
            if (![NUISettings hasProperty:@"background-image-stretch" withClass:className] ||
                ![NUISettings getBoolean:@"background-image-stretch" withClass:className]) {
                CGPoint offset = CGPointZero;
                if ([NUISettings hasProperty:@"background-image-offset-x" withClass:className])
                    offset.x = [NUISettings getFloat:@"background-image-offset-x" withClass:className] * CGRectGetWidth(view.bounds);
                if ([NUISettings hasProperty:@"background-image-offset-y" withClass:className])
                    offset.y = [NUISettings getFloat:@"background-image-offset-y" withClass:className] * CGRectGetHeight(view.bounds);;
                
                layer.frame = (CGRect){offset, image.size};
            }
        }
        
        if (view.nuiIsApplied) {
            [self removeSublayer:view.layer withName:name];
        }
        [view.layer insertSublayer:layer atIndex:0];
    }
    
    if ([NUISettings hasProperty:@"background-color-top" withClass:className]) {
        static NSString * name = @"AP:NUI:bgGradientLayer";
        
        CAGradientLayer *gradientLayer = [NUIGraphics
                                          gradientLayerWithTop:[NUISettings getColor:@"background-color-top" withClass:className]
                                          bottom:[NUISettings getColor:@"background-color-bottom" withClass:className]
                                          frame:view.bounds];
        gradientLayer.name = name;
        
        if (view.nuiIsApplied) {
            [self removeSublayer:view.layer withName:name];
        }
        [view.layer insertSublayer:gradientLayer atIndex:0];
    }

    [self renderSize:view withClass:className];
    [self renderBorder:view withClass:className];
    [self renderShadow:view withClass:className];
}

+ (void)renderBorder:(UIView*)view withClass:(NSString*)className
{
    CALayer *layer = [view layer];
    
    if ([NUISettings hasProperty:@"border-color" withClass:className]) {
        [layer setBorderColor:[[NUISettings getColor:@"border-color" withClass:className] CGColor]];
    }
    
    if ([NUISettings hasProperty:@"border-width" withClass:className]) {
        [layer setBorderWidth:[NUISettings getFloat:@"border-width" withClass:className]];
    }
    
    if ([NUISettings hasProperty:@"corner-radius" withClass:className]) {
        [layer setCornerRadius:[NUISettings getFloat:@"corner-radius" withClass:className]];
    }
}

+ (void)renderShadow:(UIView*)view withClass:(NSString*)className
{
    CALayer *layer = [view layer];
    
    if ([NUISettings hasProperty:@"shadow-radius" withClass:className]) {
        [layer setShadowRadius:[NUISettings getFloat:@"shadow-radius" withClass:className]];
    }
    
    if ([NUISettings hasProperty:@"shadow-offset" withClass:className]) {
        [layer setShadowOffset:[NUISettings getSize:@"shadow-offset" withClass:className]];
    }
    
    if ([NUISettings hasProperty:@"shadow-color" withClass:className]) {
        [layer setShadowColor:[NUISettings getColor:@"shadow-color" withClass:className].CGColor];
    }
    
    if ([NUISettings hasProperty:@"shadow-opacity" withClass:className]) {
        [layer setShadowOpacity:[NUISettings getFloat:@"shadow-opacity" withClass:className]];
    }
}

+ (void)renderSize:(UIView*)view withClass:(NSString*)className
{
    CGFloat height = view.frame.size.height;
    if ([NUISettings hasProperty:@"height" withClass:className]) {
        height = [NUISettings getFloat:@"height" withClass:className];
    }
    
    CGFloat width = view.frame.size.width;
    if ([NUISettings hasProperty:@"width" withClass:className]) {
        width = [NUISettings getFloat:@"width" withClass:className];
    }

    if (height != view.frame.size.height || width != view.frame.size.width) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, height);
    }
}

+ (void)removeSublayer:(CALayer *)layer withName:(NSString *)name {
    NSInteger idx = [layer.sublayers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj name] isEqualToString:name]) {
            *stop = YES;
            return YES;
        } else {
            return NO;
        }
    }];
    
    if (idx != NSNotFound) {
        [[layer.sublayers objectAtIndex:idx] removeFromSuperlayer];
    }
}

@end
