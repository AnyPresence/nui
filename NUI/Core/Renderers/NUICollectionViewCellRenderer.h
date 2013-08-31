//
//  NUITableViewCellRenderer.h
//  AnyPresence
//
//  Created by Ruslan Sokolov on 8/31/13.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NUIGraphics.h"
#import "NUIRenderer.h"
#import "NUISettings.h"

@interface NUICollectionViewCellRenderer : NSObject

+ (void)render:(UICollectionViewCell *)cell withClass:(NSString *)className;
+ (void)sizeDidChange:(UITableViewCell *)cell;

@end
