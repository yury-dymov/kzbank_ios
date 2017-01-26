//
//  Indication.h
//  KZBank
//
//  Created by Dymov, Yuri on 4/22/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "Exchange.h"


@interface Indication : BaseObject

@property (nonatomic, assign) NSInteger exchangeId;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) double minValue;
@property (nonatomic, assign) double maxValue;
@property (nonatomic, assign) double openingValue;
@property (nonatomic, assign) double currentValue;
@property (nonatomic, strong) Exchange *exchange;

- (NSString*)change;

- (double)annualMinValue;
- (double)annualMaxValue;
- (NSString*)annualChange;
- (NSArray*)last30;

+ (NSArray*)findAllDistinct;


@end
