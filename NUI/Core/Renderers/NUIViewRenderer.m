//
//  NUIViewRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "NUIGraphics.h"
#import "NUIViewRenderer.h"
#import "UIView+NUI.h"

@interface NUIViewRenderer ()

+ (UIImage *)gradientImageWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor backgroundColor:(UIColor *)backgroundColor height:(CGFloat)height;
+ (UIImage *)image:(UIImage *)image withSize:(CGSize)size offset:(CGPoint)offset backgroundColor:(UIColor *)backgroundColor;
+ (UIImage *)stretchedImage:(UIImage *)image withSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor;

@end

@implementation NUIViewRenderer

+ (void)render:(UIView*)view withClass:(NSString*)className
{
    [self renderBackground:view withClass:className];
    [self renderSize:view withClass:className];
    [self renderBorder:view withClass:className];
    [self renderShadow:view withClass:className];
}

+ (void)renderBackground:(UIView *)view withClass:(NSString *)className
{
    UIColor * backgroundColor = view.backgroundColor;
    if ([NUISettings hasProperty:@"background-color" withClass:className]) {
        backgroundColor = [NUISettings getColor:@"background-color" withClass: className];
    }
    
    if ([NUISettings hasProperty:@"background-image" withClass:className]) {
        UIImage * image = [NUISettings getImage:@"background-image" withClass:className];
        
        if (![NUISettings hasProperty:@"background-image-tile" withClass:className] ||
            ![NUISettings getBoolean:@"background-image-tile" withClass:className]) {
            if ([NUISettings hasProperty:@"background-image-stretch" withClass:className] &&
                [NUISettings getBoolean:@"background-image-stretch" withClass:className]) {
                image = [self stretchedImage:image withSize:view.bounds.size backgroundColor:backgroundColor];
            } else {
                CGPoint offset = CGPointZero;
                if ([NUISettings hasProperty:@"background-image-offset-x" withClass:className])
                    offset.x = [NUISettings getFloat:@"background-image-offset-x" withClass:className] * CGRectGetWidth(view.bounds);
                if ([NUISettings hasProperty:@"background-image-offset-y" withClass:className])
                    offset.y = [NUISettings getFloat:@"background-image-offset-y" withClass:className] * CGRectGetHeight(view.bounds);;
                
                image = [self image:image withSize:view.bounds.size offset:offset backgroundColor:backgroundColor];
            }
        }
    
        [view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    } else if ([NUISettings hasProperty:@"background-color-top" withClass:className] &&
               [NUISettings hasProperty:@"background-color-bottom" withClass:className]) {
        UIImage * image = [self gradientImageWithTopColor:[NUISettings getColor:@"background-color-top" withClass:className]
                                              bottomColor:[NUISettings getColor:@"background-color-bottom" withClass:className]
                                          backgroundColor:backgroundColor
                                                   height:CGRectGetHeight(view.bounds)];
        [view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    } else {
        [view setBackgroundColor:backgroundColor];
    }
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

+ (void)renderExtendedProperties:(UIView*)view withClass:(NSString*)className
{
    for (NSString * property in [NUISettings extendedPropertiesWithClass:className]) {
        objc_property_t prop = class_getProperty([view class], [property UTF8String]);
        if (prop) {
            char *setterName = property_copyAttributeValue(prop, "S");
            NSString *setter = (setterName ?
                                [NSString stringWithFormat:@"%s", setterName] :
                                [NSString stringWithFormat:@"set%@:", [property capitalizedString]]);
            
            SEL selector = NSSelectorFromString(setter);
            NSMethodSignature* signature = [[view class] instanceMethodSignatureForSelector:selector];
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:view];
            [invocation setSelector:selector];
            
            char *type = property_copyAttributeValue(prop, "T");
            if (*type == 'c') {
                BOOL value = [NUISettings getBoolean:[NUISettings getExtendedPropertyName:property] withClass:className];
                [invocation setArgument:&value atIndex:2];
                [invocation invoke];
            } else {
                // TODO: More property types.
            }
        }
    }

}

+ (UIImage *)gradientImageWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor backgroundColor:(UIColor *)backgroundColor height:(CGFloat)height
{
    CGSize size = CGSizeMake(1.f, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (backgroundColor) {
        CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
        CGContextFillRect(ctx, (CGRect){ CGPointZero, size });
    }
    
    if (topColor && bottomColor) {
        CFMutableArrayRef colors = CFArrayCreateMutable(NULL, 2, NULL);
        CFArrayAppendValue(colors, topColor.CGColor);
        CFArrayAppendValue(colors, bottomColor.CGColor);
        
        CGFloat locations[] = { 0.f, 1.f };
        CGGradientRef gradient = CGGradientCreateWithColors(NULL, colors, locations);
        
        CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0.f, 0.f), CGPointMake(0.f, height), NULL);
        CGGradientRelease(gradient);
        CFRelease(colors);
    }
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)image:(UIImage *)image withSize:(CGSize)size offset:(CGPoint)offset backgroundColor:(UIColor *)backgroundColor
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (backgroundColor) {
        CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
        CGContextFillRect(ctx, (CGRect){ CGPointZero, size });
    }
    
    if (image) {
        CGContextTranslateCTM(ctx, 0.0, size.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        offset.y = size.height - image.size.height - offset.y;
        
        CGContextDrawImage(ctx, (CGRect){ offset, image.size }, image.CGImage);
    }
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)stretchedImage:(UIImage *)image withSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (backgroundColor) {
        CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
        CGContextFillRect(ctx, (CGRect){ CGPointZero, size });
    }
    
    if (image) {
        CGContextTranslateCTM(ctx, 0.f, size.height);
        CGContextScaleCTM(ctx, 1.f, -1.f);
        CGContextDrawImage(ctx, (CGRect){ CGPointZero, size }, image.CGImage);
    }
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
