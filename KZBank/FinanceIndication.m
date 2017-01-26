//
//  FinanceIndication.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "FinanceIndication.h"

@interface FinanceIndication()

@property (nonatomic, assign) NSInteger _idate;

@end

@implementation FinanceIndication


static BOOL _tableCreated = NO;

@synthesize finance;
@synthesize financeId;
@synthesize value;
@synthesize date;
@synthesize _idate;

- (Finance*)finance {
    if (!finance) {
        self.finance = [Finance findById:financeId];
    }
    return finance;
}

+ (void)_createTable {
    if (!_tableCreated) {
        _tableCreated = YES;
        [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ("
                                                "id INTEGER PRIMARY KEY,"
                                                "financeId INTEGER,"
                                                "date INTEGER,"
                                                "value REAL,"
                                                "createdAt INTEGER,"
                                                "updatedAt INTEGER)", NSStringFromClass([self class])]];
    }
}

+ (NSDictionary*)_mapping {
    return @{
             @"id" : @"id_",
             @"date" : @"_idate",
             @"finance_id" : @"financeId",
             @"value" : @"value",
             @"created_at" : @"_icreatedAt",
             @"updated_at" : @"_iupdatedAt"
             };
}

- (void)set_idate:(NSInteger)_anidate {
    _idate = _anidate;
    self.date = [NSDate dateWithTimeIntervalSince1970:_idate];
}


- (void)save {
    [[self class] _createTable];
    [self rm];
    [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"INSERT INTO '%@' (id, date, financeId, value, createdAt, updatedAt) VALUES(%ld, %ld, %ld, %f, %ld, %ld)", [self class], self.id_, self._idate, self.financeId, self.value, self._icreatedAt, self._iupdatedAt]];
}

+ (id)_makeElemFromRow:(EGODatabaseRow *)row {
    FinanceIndication *ret = [FinanceIndication new];
    ret.id_ = [row intForColumn:@"id"];
    ret._idate = [row intForColumn:@"date"];
    ret.financeId = [row intForColumn:@"financeId"];
    ret.value = [row doubleForColumn:@"value"];
    ret._iupdatedAt = [row intForColumn:@"updatedAt"];
    ret._icreatedAt = [row intForColumn:@"createdAt"];
    return ret;
}

+ (NSArray*)findByFinanceId:(NSInteger)aFinanceId {
    NSMutableArray *ret = [NSMutableArray new];
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE financeId=%ld", NSStringFromClass([self class]), aFinanceId]];
    for (EGODatabaseRow *row in res)
        [ret addObject:[self _makeElemFromRow:row]];
    return ret;
}


@end
