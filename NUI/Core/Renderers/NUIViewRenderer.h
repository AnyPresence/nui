//
//  NUIViewRenderer.h
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NUISettings.h"

@interface NUIViewRenderer : NSObject

+ (void)render:(UIView*)view withClass:(NSString*)className;
+ (void)renderBackground:(UIView*)view withClass:(NSString*)className;
+ (void)renderBorder:(UIView*)view withClass:(NSString*)className;
+ (void)renderShadow:(UIView*)view withClass:(NSString*)className;
+ (void)renderSize:(UIView*)view withClass:(NSString*)className;
+ (void)renderExtendedProperties:(UIView*)view withClass:(NSString*)className;
+ (UIImage *)backgroundPatternImage:(UIColor *)defaultColor withClass:(NSString *)className size:(CGSize)size;

@end
