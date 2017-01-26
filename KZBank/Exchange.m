//
//  Exchange.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/22/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "Exchange.h"

@implementation Exchange

static BOOL _tableCreated = NO;

@synthesize title;

+ (void)_createTable {
    if (!_tableCreated) {
        _tableCreated = YES;
        [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ("
                                                "id INTEGER PRIMARY KEY,"
                                                "title TEXT,"
                                                "createdAt INTEGER,"
                                                "updatedAt INTEGER)", NSStringFromClass([self class])]];
    }
}

+ (NSDictionary*)_mapping {
    return @{
             @"id" : @"id_",
             @"title" : @"title",
             @"created_at" : @"_icreatedAt",
             @"updated_at" : @"_iupdatedAt"
             };
}


- (void)save {
    [[self class] _createTable];
    [self rm];
    [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"INSERT INTO '%@' (id, title, createdAt, updatedAt) VALUES(%ld, ?, %ld, %ld)", [self class], self.id_, self._icreatedAt, self._iupdatedAt] parameters:@[self.title]];
}

+ (id)_makeElemFromRow:(EGODatabaseRow *)row {
    Exchange *ret = [Exchange new];
    ret.id_ = [row intForColumn:@"id"];
    ret.title = [row stringForColumn:@"title"];
    ret._iupdatedAt = [row intForColumn:@"updatedAt"];
    ret._icreatedAt = [row intForColumn:@"createdAt"];
    return ret;
}





@end
