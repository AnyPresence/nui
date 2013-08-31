//
//  NUITableViewCellRenderer.m
//  AnyPresence
//
//  Created by Ruslan Sokolov on 8/31/13.
//
//

#import "NUICollectionViewCellRenderer.h"

@implementation NUICollectionViewCellRenderer

+ (void)render:(UICollectionViewCell *)cell withClass:(NSString*)className
{
    [self renderSizeDependentProperties:cell];
}

+ (void)sizeDidChange:(UICollectionViewCell *)cell
{
    [self renderSizeDependentProperties:cell];
}

+ (void)renderSizeDependentProperties:(UICollectionViewCell *)cell
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
