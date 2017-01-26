//
//
//  
//
//  Created by F1reCaT on 20.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTGTableViewDelegate.h"

enum {
    CELL_STRING = 0,
    CELL_VIEW
};

@interface UTGTableViewCell : UITableViewCell

@property (nonatomic, assign) id<UTGTableViewDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) UIColor *separatorColor;
@property (nonatomic, assign) NSInteger cellType;

@end
