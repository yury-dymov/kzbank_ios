//
//  Indication.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/22/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "Indication.h"

static BOOL _tableCreated = NO;

@interface Indication()

@property (nonatomic, assign) NSInteger _idate;

@end

@implementation Indication

@synthesize exchange;
@synthesize exchangeId;
@synthesize minValue;
@synthesize maxValue;
@synthesize date;
@synthesize currentValue;
@synthesize openingValue;
@synthesize _idate;

- (Exchange*)exchange {
    if (!exchange) {
        self.exchange = [Exchange findById:exchangeId];
    }
    return exchange;
}

+ (void)_createTable {
    if (!_tableCreated) {
        _tableCreated = YES;
        [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ("
                                                "id INTEGER PRIMARY KEY,"
                                                "exchangeId INTEGER,"
                                                "date INTEGER,"
                                                "minValue REAL,"
                                                "maxValue REAL,"
                                                "openingValue REAL,"
                                                "currentValue REAL,"
                                                "createdAt INTEGER,"
                                                "updatedAt INTEGER)", NSStringFromClass([self class])]];
    }
}

+ (NSDictionary*)_mapping {
    return @{
             @"id" : @"id_",
             @"date" : @"_idate",
             @"exchange_id" : @"exchangeId",
             @"min_value" : @"minValue",
             @"max_value" : @"maxValue",
             @"opening_value" : @"openingValue",
             @"current_value" : @"currentValue",
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
    [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"INSERT INTO '%@' (id, date, exchangeId, minValue, maxValue, openingValue, currentValue ,createdAt, updatedAt) VALUES(%ld, %ld, %ld, %f, %f, %f, %f, %ld, %ld)", [self class], self.id_, self._idate, self.exchangeId, self.minValue, self.maxValue, self.openingValue, self.currentValue, self._icreatedAt, self._iupdatedAt]];
}

+ (id)_makeElemFromRow:(EGODatabaseRow *)row {
    Indication *ret = [Indication new];
    ret.id_ = [row intForColumn:@"id"];
    ret._idate = [row intForColumn:@"date"];
    ret.exchangeId = [row intForColumn:@"exchangeId"];
    ret.minValue = [row doubleForColumn:@"minValue"];
    ret.maxValue = [row doubleForColumn:@"maxValue"];
    ret.openingValue = [row doubleForColumn:@"openingValue"];
    ret.currentValue = [row doubleForColumn:@"currentValue"];
    ret._iupdatedAt = [row intForColumn:@"updatedAt"];
    ret._icreatedAt = [row intForColumn:@"createdAt"];
    return ret;
}

- (NSString*)change {
    double val = (currentValue - openingValue) / currentValue * 100;
    NSString *sign = @"";
    if (val > 0)
        sign = @"+";
    return [NSString stringWithFormat:@"%@%0.2g%%", sign, val];
}

- (NSString*)annualChange {
    Indication *start;
    Indication *end;
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE exchangeId=%ld ORDER BY date ASC LIMIT 1", NSStringFromClass([self class]), self.exchangeId]];
    for (EGODatabaseRow * row in res)
        start = [Indication _makeElemFromRow:row];
    res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE exchangeId=%ld ORDER BY date DESC LIMIT 1", NSStringFromClass([self class]), self.exchangeId]];
    for (EGODatabaseRow * row in res)
        end = [Indication _makeElemFromRow:row];
    double val = (end.currentValue - start.openingValue) / start.openingValue * 100;
    NSString *sign = @"";
    if (val > 0)
        sign = @"+";
    return [NSString stringWithFormat:@"%@%0.2g%%", sign, val];
}

- (double)annualMaxValue {
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE exchangeId=%ld ORDER BY maxValue DESC LIMIT 1", NSStringFromClass([self class]), self.exchangeId]];
    for (EGODatabaseRow * row in res)
        return [[Indication _makeElemFromRow:row] maxValue];
    return 0;
}

- (double)annualMinValue {
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE exchangeId=%ld ORDER BY minValue ASC LIMIT 1", NSStringFromClass([self class]), self.exchangeId]];
    for (EGODatabaseRow * row in res)
        return [[Indication _makeElemFromRow:row] minValue];
    return 0;
}

+ (NSArray*)findAllDistinct {
    NSMutableArray *ret = [NSMutableArray new];
    for (Exchange *eo in [Exchange findAll]) {
        EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE exchangeId=%ld ORDER BY date desc LIMIT 1", NSStringFromClass([self class]), eo.id_]];
        for (EGODatabaseRow *row in res)
            [ret addObject:[self _makeElemFromRow:row]];
    }
    return ret;
}

- (NSArray*)last30 {
    NSMutableArray *ret = [NSMutableArray new];
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE exchangeId=%ld ORDER BY date desc LIMIT 30", NSStringFromClass([self class]), self.exchangeId]];
    for (EGODatabaseRow *row in res)
        [ret insertObject:[Indication _makeElemFromRow:row] atIndex:0];
    return ret;
}


@end
