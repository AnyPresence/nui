//
//  NUIWebViewRenderer.h
//  AnyPresence
//
//  Created by Ruslan Sokolov on 6/4/13.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NUISettings.h"

@interface NUIWebViewRenderer : NSObject

+ (void)render:(UIWebView*)view withClass:(NSString*)className;
+ (void)renderCSS:(UIWebView*)view withClass:(NSString*)className;

@end
