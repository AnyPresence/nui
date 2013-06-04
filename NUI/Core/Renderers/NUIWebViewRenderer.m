//
//  NUIWebViewRenderer.m
//  AnotherTest
//
//  Created by Ruslan Sokolov on 6/4/13.
//
//

#import "NUIWebViewRenderer.h"
#import "NUIViewRenderer.h"

@implementation NUIWebViewRenderer

+ (void)render:(UIWebView *)view withClass:(NSString *)className
{
    [NUIViewRenderer renderBackground:view withClass:className];
    [NUIViewRenderer renderSize:view withClass:className];
    [NUIViewRenderer renderBorder:view withClass:className];
    
    [self renderCSS:view withClass:className];
}

+ (void)renderCSS:(UIWebView *)view withClass:(NSString *)className
{
    NSString *property;
    NSString *js = @"document.getElementsByTagName('body')[0].style.%@ = '%@'";
    
    property = @"font-name";
    if ([NUISettings hasProperty:property withClass:className]) {
        [view stringByEvaluatingJavaScriptFromString:
         [NSString stringWithFormat:js, @"fontFamily", [NUISettings get:property withClass:className]]];
    }
    
    property = @"font-color";
    if ([NUISettings hasProperty:property withClass:className]) {
        [view stringByEvaluatingJavaScriptFromString:
         [NSString stringWithFormat:js, @"color", [NUISettings get:property withClass:className]]];
    }
    
    property = @"font-size";
    if ([NUISettings hasProperty:property withClass:className]) {
        [view stringByEvaluatingJavaScriptFromString:
         [NSString stringWithFormat:js, @"fontSize", [NUISettings get:property withClass:className]]];
    }
    
    property = @"text-align";
    if ([NUISettings hasProperty:property withClass:className]) {
        [view stringByEvaluatingJavaScriptFromString:
         [NSString stringWithFormat:js, @"textAlign", [NUISettings get:property withClass:className]]];
    }
    
    property = @"text-decoration";
    if ([NUISettings hasProperty:property withClass:className]) {
        [view stringByEvaluatingJavaScriptFromString:
         [NSString stringWithFormat:js, @"textDecoration", [NUISettings get:property withClass:className]]];
    }
}


@end
