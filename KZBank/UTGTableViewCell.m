//
//
//  
//
//  Created by F1reCaT on 20.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UTGTableViewCell.h"

#define OFFSET 1.0

@implementation UTGTableViewCell
@synthesize delegate;
@synthesize indexPath;
@synthesize separatorColor;
@synthesize cellType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.separatorColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        cellType = CELL_STRING;
        self.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    const CGFloat* components = CGColorGetComponents(separatorColor.CGColor);
    CGContextSetRGBStrokeColor(ctx, components[0], components[1], components[2], components[3]);
    CGContextSetLineWidth(ctx, 0.25);
    CGFloat total = rect.origin.x;
    for (NSInteger i = 0; i < [delegate numberOfColumnsInUTGTableViewCell:self]; ++i) {
        CGFloat width = [delegate UTGTableViewCell:self cellWidthForColumnId:i];
        if (cellType == CELL_STRING) {
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(OFFSET + total, rect.origin.y + OFFSET, width - 2*OFFSET, rect.size.height - 2 * OFFSET)];  
            if ([delegate respondsToSelector:@selector(UTGTableViewCell: colorForColumnId:)])
                lbl.backgroundColor = [delegate UTGTableViewCell:self colorForColumnId:i];
            lbl.text = [delegate UTGTableViewCell:self valueForColumnId:i];
            lbl.textAlignment = self.textLabel.textAlignment;
            lbl.textColor = self.textLabel.textColor;
            lbl.backgroundColor = self.textLabel.backgroundColor;
            lbl.font = self.textLabel.font;
            lbl.numberOfLines = 2;
            [self addSubview:lbl];
        } else {
            UIView *view = [delegate UTGTableViewCell:self viewForColumnId:i];
            view.frame = CGRectMake(OFFSET + total + view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            [self addSubview:view];
        }
        total += width;
        CGContextMoveToPoint(ctx, total, 0.0);
        CGContextAddLineToPoint(ctx, total, self.bounds.size.height);
    }
    CGContextStrokePath(ctx);
    [super drawRect:rect];
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    divider.backgroundColor = [UIColor grayColor];
    [self addSubview:divider];
}




@end
