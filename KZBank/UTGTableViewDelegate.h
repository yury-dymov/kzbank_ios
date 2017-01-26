//
//
//  
//
//  Created by F1reCaT on 20.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UTGTableViewCell;

@protocol UTGTableViewDelegate <NSObject>

- (NSInteger)numberOfColumnsInUTGTableViewCell:(UTGTableViewCell*)utgTableViewCell;
- (CGFloat)UTGTableViewCell:(UTGTableViewCell*)utgTableViewCell cellWidthForColumnId:(NSInteger)aColumnId;

@optional
- (UIColor*)UTGTableViewCell:(UTGTableViewCell*)utgTableViewCell colorForColumnId:(NSInteger)aColumnId;
- (NSString*)UTGTableViewCell:(UTGTableViewCell*)utgTableViewCell valueForColumnId:(NSInteger)aColumnId;
- (UIView*)UTGTableViewCell:(UTGTableViewCell*)utgTableViewCell viewForColumnId:(NSInteger)aColumnId;


@end
