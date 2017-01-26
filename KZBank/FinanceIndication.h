//
//  FinanceIndication.h
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "Finance.h"

@interface FinanceIndication : BaseObject

@property (nonatomic, assign) NSInteger financeId;
@property (nonatomic, strong) Finance *finance;
@property (nonatomic, assign) double value;
@property (nonatomic, strong) NSDate *date;

+ (NSArray*)findByFinanceId:(NSInteger)aFinanceId;

@end
