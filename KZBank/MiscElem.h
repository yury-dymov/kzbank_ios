//
//  MiscElem.h
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <CorePlot-CocoaTouch.h>
#import "BaseObject.h"
#import "MiscBlock.h"


@interface MiscElem : BaseObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double value;
@property (nonatomic, assign) NSInteger blockId;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) MiscBlock *block;

+ (NSArray*)findAllByBlockId:(NSInteger)aBlockId;
- (CPTColor*)cptColor;

@end
