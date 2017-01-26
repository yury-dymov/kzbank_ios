//
//  UTGTableView.m
//  
//
//  Created by F1reCaT on 16.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UTGTableView.h"
#import <QuartzCore/QuartzCore.h>


@implementation UTGTableView
@synthesize delegate;
@synthesize aTableView;
@synthesize aHeaderView;

- (id)initWithFrame:(CGRect)frame andHeaderHeight:(CGFloat)height {
    self = [super initWithFrame:frame];
    if (self) {
// ------- SETUP --------
        CGFloat offsetY = 0.0f;
// ----------------------        
        
        self.aHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, height)];
        self.backgroundColor = [UIColor clearColor];
//        aHeaderView.layer.cornerRadius = 10.0;
//        aHeaderView.layer.masksToBounds = YES;
        
        CGFloat tableOffset = height + offsetY;
        self.aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, tableOffset, frame.size.width, frame.size.height - tableOffset)];
        self.aTableView.delegate = self;
        self.aTableView.dataSource = self;
        self.aTableView.layer.opacity = 1.0;
        [self.aTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        self.aTableView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
        
    }
    return self;
}


- (CGFloat)rowHeight {
    CGFloat columnHeight = UTG_TABLE_VIEW_DEFAULT_ROW_HEIGHT;
    if ([delegate respondsToSelector:@selector(heightForUTGTableView:)]) {
        columnHeight = [delegate heightForUTGTableView:self];
    }
    return columnHeight;
}

- (void)centerView:(UIView*)cellView forIndexPath:(NSIndexPath*)indexPath andColumn:(NSInteger)columnIndex {
    CGFloat columnWidth = [delegate widthForUTGTableView:self atIndexPath:nil andColumn:columnIndex];
    CGFloat columnHeight = [self rowHeight];
    cellView.frame = CGRectMake((columnWidth - cellView.frame.size.width) / 2, (columnHeight - cellView.frame.size.height) / 2, cellView.frame.size.width, cellView.frame.size.height);        
}

- (void)makeHeader {
    [self.aHeaderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];    
    CGFloat offsetX = 0.0;    
    for (NSInteger i = 0; i < [delegate numberOfColumnsInUTGTableView:self atIndexPath:nil]; ++i) {
        UIView *headerView = [delegate headerViewForUTGTableView:self atIndex:i];
        [self centerView:headerView forIndexPath:nil andColumn:i];        
        headerView.frame = CGRectMake(headerView.frame.origin.x + offsetX - 5.0, 0.0, headerView.frame.size.width, headerView.frame.size.height);
        [aHeaderView addSubview:headerView];
        offsetX += [delegate widthForUTGTableView:self atIndexPath:nil andColumn:i];        
    }
}

- (void)reloadData {
    [self.aTableView reloadData];
    [self makeHeader];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self makeHeader];
    [self addSubview:aHeaderView];    
    [self addSubview:aTableView];     
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [delegate numberOfSectionsInUTGTableView:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [delegate numberOfRowsInUTGTableView:self atSection:section];
}

- (void)cellSelected:(UIGestureRecognizer*)gesture {
    UTGTableViewCell *cell = (id)gesture.view;
    CGFloat loc = [gesture locationInView:cell].x;
    [UIView animateWithDuration:0.3 animations:^{
        [self.aTableView selectRowAtIndexPath:cell.indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } completion:^(BOOL finished){        
        if ([delegate respondsToSelector:@selector(UTGTableView:selectedIndexPath:selectedColumnIndex:)]) {
            CGFloat sum = 0.0;
            for (NSInteger i = 0; i < [delegate numberOfColumnsInUTGTableView:self atIndexPath:cell.indexPath]; ++i) {
                sum += [delegate widthForUTGTableView:self atIndexPath:cell.indexPath andColumn:i];

                if (loc < sum) {
                    [delegate UTGTableView:self selectedIndexPath:cell.indexPath selectedColumnIndex:i];
                    return;
                }
            }
        }
        
    }];       
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.3 animations:^{
        [self.aTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } completion:^(BOOL finished){
        if ([delegate respondsToSelector:@selector(UTGTableView:selectedIndexPath:selectedColumnIndex:)])
            [delegate UTGTableView:self selectedIndexPath:indexPath selectedColumnIndex:0];
    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UTGTableViewCell *cell = [[UTGTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.separatorColor = [UIColor clearColor];
    cell.cellType = CELL_VIEW;
    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelected:)]];
    if ([delegate respondsToSelector:@selector(selectedBackgroundColorInUTGTableView:)]) {
        UIView *selView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aTableView.frame.size.width, 40)];
        selView.backgroundColor = [delegate selectedBackgroundColorInUTGTableView:self];
        cell.selectedBackgroundView = selView;
    }
    if ([delegate respondsToSelector:@selector(accessoryTypeForTableView:atIndexPath:)])
        cell.accessoryType = [delegate accessoryTypeForUTGTableView:self atIndexPath:indexPath];
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (UIView*)UTGTableViewCell:(UTGTableViewCell *)liverpoolTableViewCell viewForColumnId:(NSInteger)aColumnId {
    
    UIView *columnView = [delegate valueForUTGTableView:self atIndexPath:liverpoolTableViewCell.indexPath andColumn:aColumnId];
    [self centerView:columnView forIndexPath:liverpoolTableViewCell.indexPath andColumn:aColumnId];
    return columnView;
}

- (NSInteger)numberOfColumnsInUTGTableViewCell:(UTGTableViewCell *)liverpoolTableViewCell {
    return [delegate numberOfColumnsInUTGTableView:self atIndexPath:liverpoolTableViewCell.indexPath];
}

- (CGFloat)UTGTableViewCell:(UTGTableViewCell *)liverpoolTableViewCell cellWidthForColumnId:(NSInteger)aColumnId {
    return [delegate widthForUTGTableView:self atIndexPath:liverpoolTableViewCell.indexPath andColumn:aColumnId];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self rowHeight];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([delegate respondsToSelector:@selector(headerForUTGTableView:forSegment:)])
        return [delegate headerForUTGTableView:self forSegment:section];
    return @"";
}




@end
