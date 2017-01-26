#import "Commodity.h"

@interface Commodity()

@property (nonatomic, assign) NSInteger _iDate;
@property (nonatomic, assign) double _min;
@property (nonatomic, assign) double _max;
@property (nonatomic, assign) double _yesterday;


@end

@implementation Commodity

static BOOL _tableCreated = NO;

@synthesize title;
@synthesize date;
@synthesize value;
@synthesize _iDate;
@synthesize _min;
@synthesize _max;
@synthesize _yesterday;

+ (void)_createTable {
    if (!_tableCreated) {
        _tableCreated = YES;
        [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ("
                                                "id INTEGER PRIMARY KEY,"
                                                "title TEXT,"
                                                "date INTEGER,"
                                                "value REAL,"
                                                "createdAt INTEGER,"
                                                "updatedAt INTEGER)", NSStringFromClass([self class])]];
    }
}

+ (NSDictionary*)_mapping {
    return @{
             @"id" : @"id_",
             @"title" : @"title",
             @"date" : @"_iDate",
             @"value" : @"value",
             @"createdAt" : @"_icreatedAt",
             @"updatedAt" : @"_iupdatedAt"
             };
}
- (void)set_iDate:(NSInteger)_an_iDate {
    _iDate = _an_iDate;
    self.date = [NSDate dateWithTimeIntervalSince1970:_iDate];
}

- (void)save {
    [[self class] _createTable];
    [self rm];
    [[KZDatabase getInstance] executeQuery:
     [NSString stringWithFormat:@"INSERT INTO '%@' (id, title, date, value, createdAt, updatedAt) "
      "VALUES(%ld, ?, %ld, %f, %ld, %ld)",
      [self class], self.id_, self._iDate, self.value, self._icreatedAt, self._iupdatedAt]
                                parameters:@[self.title]
     ];
}

+ (id)_makeElemFromRow:(EGODatabaseRow *)row {
    Commodity *ret = [Commodity new];
    ret.id_ = [row intForColumn:@"id"];
    ret.title = [row stringForColumn:@"title"];
    ret._iDate = [row intForColumn:@"date"];
    ret.value = [row doubleForColumn:@"value"];
    ret._iupdatedAt = [row intForColumn:@"updatedAt"];
    ret._icreatedAt = [row intForColumn:@"createdAt"];
    return ret;
}

+ (NSArray*)calculateData {
    NSMutableArray *ret = [NSMutableArray new];
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT title FROM '%@'", [self class]]];
    for (EGODatabaseRow *row in res) {
        Commodity *object = [Commodity new];
        object.title = [row stringForColumn:@"title"];
        EGODatabaseResult *res2 = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT value FROM '%@' WHERE title='%@' ORDER BY value DESC LIMIT 1", [self class], object.title]];
        for (EGODatabaseRow *row2 in res2) {
            object._max = [row2 doubleForColumn:@"value"];
        }
        res2 = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT value FROM '%@' WHERE title='%@' ORDER BY value ASC LIMIT 1", [self class], object.title]];
        for (EGODatabaseRow *row2 in res2) {
            object._min = [row2 doubleForColumn:@"value"];
        }
        res2 = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT value FROM '%@' WHERE title='%@' ORDER BY date DESC LIMIT 2", [self class], object.title]];
        for (EGODatabaseRow *row2 in res2) {
            if (fabs(object.value) < 0.000001)
                object.value = [row2 doubleForColumn:@"value"];
            else
                object._yesterday = [row2 doubleForColumn:@"value"];
        }
        [ret addObject:object];
    }
    return ret;
}

- (NSString*)change {
    double val = (value - _yesterday) / value * 100;
    NSString *sign = @"";
    if (val > 0)
        sign = @"+";
    return [NSString stringWithFormat:@"%@%0.2g%%", sign, val];
}

- (double)min {
    return _min;
}

- (double)max {
    return _max;
}

- (double)currentValue {
    return value;
}

- (NSArray*)last30 {
    NSMutableArray *ret = [NSMutableArray new];
    EGODatabaseResult *res2 = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE title='%@' ORDER BY date DESC LIMIT 30", [self class], self.title]];
    for (EGODatabaseRow *row2 in res2) {
        [ret insertObject:[Commodity _makeElemFromRow:row2] atIndex:0];
    }
    return ret;
}


@end
