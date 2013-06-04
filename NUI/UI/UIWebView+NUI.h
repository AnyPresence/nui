//
//  UIWebView+NUI.h
//  AnyPresence
//
//  Created by Ruslan Sokolov on 6/4/13.
//
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "NUIRenderer.h"
#import "NUIWebViewRenderer.h"

@interface UIWebView (NUI)

@property (nonatomic, retain) NSString* nuiClass;
@property (nonatomic, retain) NSNumber* nuiIsApplied;

- (void)applyNUI;

@end
