//
//  NUITableViewCellRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUITableViewCellRenderer.h"

@implementation NUITableViewCellRenderer

+ (void)render:(UITableViewCell*)cell withClass:(NSString*)className
{
    [self renderSizeDependentProperties:cell];
    
    // Set the labels' background colors to clearColor by default, so they don't show a white
    // background on top of the cell background color
    if (cell.textLabel != nil) {
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        // Set Font
        [NUIRenderer renderLabel:cell.textLabel withClass:className];
    }
    
    if (cell.detailTextLabel != nil) {
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        // Set font
        [NUIRenderer renderLabel:cell.detailTextLabel withClass:className withSuffix:@"Detail"];
    }
    
}

+ (void)sizeDidChange:(UITableViewCell*)cell
{
    [self renderSizeDependentProperties:cell];
}

+ (void)renderSizeDependentProperties:(UITableViewCell*)cell
{
    NSString *className = cell.nuiClass;
    
    // Background
    UIColor * backgroundColor = cell.backgroundView.backgroundColor;
    if ([NUISettings hasProperty:@"background-color" withClass:className]) {
        backgroundColor = [NUISettings getColor:@"background-color" withClass:className];
    }
    
    UIImage * patternImage = [NUIViewRenderer backgroundPatternImage:backgroundColor
                                                           withClass:className
                                                                size:cell.bounds.size];
    cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.backgroundView.backgroundColor = patternImage ? [UIColor colorWithPatternImage:patternImage] : backgroundColor;
    
    // Border
    if ([NUISettings hasProperty:@"border-color" withClass:className]) {
        [cell.backgroundView.layer setBorderColor:[[NUISettings getColor:@"border-color" withClass:className] CGColor]];
    }
    
    if ([NUISettings hasProperty:@"border-width" withClass:className]) {
        [cell.backgroundView.layer setBorderWidth:[NUISettings getFloat:@"border-width" withClass:className]];
    }
    
    if ([NUISettings hasProperty:@"corner-radius" withClass:className]) {
        [cell.backgroundView.layer setCornerRadius:[NUISettings getFloat:@"corner-radius" withClass:className]];
    }

}

@end
