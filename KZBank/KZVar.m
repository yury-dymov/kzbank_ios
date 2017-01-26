//
//  KZVar.m
//  KZBank
//
//  Created by Dymov, Yuri on 3/11/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "KZVar.h"
#import "KZDatabase.h"

static BOOL _tableCreated = NO;

@implementation KZVar
@synthesize key;
@synthesize value;

+ (void)_createTable {
    if (!_tableCreated) {
        _tableCreated = YES;
        [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ("
                                                "key STRING UNIQUE,"
                                                "value STRING)", NSStringFromClass([self class])]];
    }
}


- (void)save {
    [[self class] _createTable];
    [self rm];
    [[KZDatabase getInstance] executeQuery:
     [NSString stringWithFormat:@"INSERT INTO '%@' (key, value) VALUES(?, ?)", [self class]] parameters:@[self.key, self.value]];
}


- (void)rm {
    [[self class] _createTable];
    [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"DELETE FROM '%@' WHERE key=?", NSStringFromClass([self class])] parameters:@[self.key]];
}

+ (id)_makeElemFromRow:(EGODatabaseRow*)row {
    KZVar *ret = [KZVar new];
    ret.key = [row stringForColumn:@"key"];
    ret.value = [row stringForColumn:@"value"];
    return ret;
}

+ (KZVar*)findByKey:(NSString *)key {
    [self _createTable];
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE key = ?", NSStringFromClass([self class])] parameters:@[key]];
    for (EGODatabaseRow *row in res)
        return [self _makeElemFromRow:row];
    return nil;
}


@end

