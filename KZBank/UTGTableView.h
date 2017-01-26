//
//  UTGTableView.h
//  
//
//  Created by F1reCaT on 16.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTGTableViewCell.h"

#define UTG_TABLE_VIEW_DEFAULT_ROW_HEIGHT 44.0

@protocol UTGTableViewProtocol;

@interface UTGTableView : UIView<UITableViewDataSource, UITableViewDelegate, UTGTableViewDelegate>

@property (nonatomic, retain) UIView *aHeaderView;
@property (nonatomic, retain) UITableView *aTableView;
@property (nonatomic, retain) id<UTGTableViewProtocol> delegate;

- (void)reloadData;
- (CGFloat)rowHeight;

- (id)initWithFrame:(CGRect)frame andHeaderHeight:(CGFloat)height;

@end

@protocol UTGTableViewProtocol <NSObject>

- (UIView*)headerViewForUTGTableView:(UTGTableView*)anUtgTableView atIndex:(NSInteger)index;
- (UIView*)valueForUTGTableView:(UTGTableView*)anUtgTableView atIndexPath:(NSIndexPath*)indexPath andColumn:(NSInteger)columnIndex;
- (NSInteger)numberOfColumnsInUTGTableView:(UTGTableView*)anUtgTableView atIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)widthForUTGTableView:(UTGTableView*)anUtgTableView atIndexPath:(NSIndexPath*)indexPath andColumn:(NSInteger)columnIndex;
- (NSInteger)numberOfSectionsInUTGTableView:(UTGTableView*)anUtgTableView;
- (NSInteger)numberOfRowsInUTGTableView:(UTGTableView*)anUtgTableView atSection:(NSInteger)section;

@optional

- (NSString*)headerForUTGTableView:(UTGTableView*)utgTableView forSegment:(NSInteger)segment;
- (CGFloat)heightForUTGTableView:(UTGTableView*)utgTableView;
- (UIColor*)selectedBackgroundColorInUTGTableView:(UTGTableView*)utgTableView;
- (UITableViewCellAccessoryType)accessoryTypeForUTGTableView:(UTGTableView*)utgTableView atIndexPath:(NSIndexPath*)indexPath;
- (void)UTGTableView:(UTGTableView*)utgTableView selectedIndexPath:(NSIndexPath*)indexPath selectedColumnIndex:(NSInteger)columnIndex;

@end

