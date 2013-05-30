//
//  NUITextViewRenderer.h
//  AnyPresence
//
//  Created by Ruslan Sokolov on 5/30/13.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NUISettings.h"

@interface NUITextViewRenderer : NSObject

+ (void)render:(UITextView*)label withClass:(NSString*)className;
+ (void)render:(UITextView*)label withClass:(NSString*)className withSuffix:(NSString*)suffix;
+ (void)renderText:(UITextView*)label withClass:(NSString*)className;

@end

