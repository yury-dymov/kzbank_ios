//
//  Finance.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "Finance.h"
#import "FinanceIndication.h"

@implementation Finance

@synthesize title;
@synthesize typeId;
@synthesize indications;
@synthesize bold;

static BOOL _tableCreated = NO;


+ (void)_createTable {
    if (!_tableCreated) {
        _tableCreated = YES;
        [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ("
                                                "id INTEGER PRIMARY KEY,"
                                                "title TEXT,"
                                                "typeId INTEGER,"
                                                "bold INTEGER,"
                                                "createdAt INTEGER,"
                                                "updatedAt INTEGER)", NSStringFromClass([self class])]];
    }
}

- (NSArray*)indications {
    if (!indications) {
        self.indications = [FinanceIndication findByFinanceId:self.id_];
    }
    return indications;
}

+ (NSDictionary*)_mapping {
    return @{
             @"id" : @"id_",
             @"title" : @"title",
             @"type_id" : @"typeId",
             @"bold" : @"bold",
             @"created_at" : @"_icreatedAt",
             @"updated_at" : @"_iupdatedAt"
             };
}


- (void)save {
    [[self class] _createTable];
    [self rm];
    [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"INSERT INTO '%@' (id, title, typeId, createdAt, updatedAt, bold) VALUES(%ld, ?, %ld, %ld, %ld, %d)", [self class], self.id_, self.typeId, self._icreatedAt, self._iupdatedAt, self.bold] parameters:@[self.title]];
}

+ (id)_makeElemFromRow:(EGODatabaseRow *)row {
    Finance *ret = [Finance new];
    ret.id_ = [row intForColumn:@"id"];
    ret.typeId = [row intForColumn:@"typeId"];
    ret.title = [row stringForColumn:@"title"];
    ret.bold = [row intForColumn:@"bold"];
    ret._iupdatedAt = [row intForColumn:@"updatedAt"];
    ret._icreatedAt = [row intForColumn:@"createdAt"];
    return ret;
}

+ (NSArray*)findByTypeId:(NSInteger)aTypeId {
    NSMutableArray *ret = [NSMutableArray new];
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE typeId=%ld", NSStringFromClass([self class]), aTypeId]];
    for (EGODatabaseRow * row in res)
        [ret addObject:[self _makeElemFromRow:row]];
    return ret;
}





@end
