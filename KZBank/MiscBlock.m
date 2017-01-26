//
//  MiscBlock.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "MiscBlock.h"
#import "MiscElem.h"

@implementation MiscBlock

static BOOL _tableCreated = NO;

@synthesize title;
@synthesize screenId;
@synthesize elements;

- (NSArray*)elements {
    if (!elements) {
        self.elements = [MiscElem findAllByBlockId:self.id_];
    }
    return elements;
}

+ (void)_createTable {
    if (!_tableCreated) {
        _tableCreated = YES;
        [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ("
                                                "id INTEGER PRIMARY KEY,"
                                                "title TEXT,"
                                                "screenId INTEGER,"
                                                "createdAt INTEGER,"
                                                "updatedAt INTEGER)", NSStringFromClass([self class])]];
    }
}

+ (NSDictionary*)_mapping {
    return @{
             @"id" : @"id_",
             @"title" : @"title",
             @"screen_id" : @"screenId",
             @"created_at" : @"_icreatedAt",
             @"updated_at" : @"_iupdatedAt"
             };
}


- (void)save {
    [[self class] _createTable];
    [self rm];
    [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"INSERT INTO '%@' (id, screenId, title, createdAt, updatedAt) VALUES(%ld, %ld, ?, %ld, %ld)", [self class], self.id_, self.screenId ,self._icreatedAt, self._iupdatedAt] parameters:@[self.title]];
}

+ (id)_makeElemFromRow:(EGODatabaseRow *)row {
    MiscBlock *ret = [MiscBlock new];
    ret.id_ = [row intForColumn:@"id"];
    ret.title = [row stringForColumn:@"title"];
    ret.screenId = [row intForColumn:@"screenId"];
    ret._iupdatedAt = [row intForColumn:@"updatedAt"];
    ret._icreatedAt = [row intForColumn:@"createdAt"];
    return ret;
}

+ (NSArray*)findByScreenId:(NSInteger)aScreenId {
    NSMutableArray *ret = [NSMutableArray new];
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE screenId=%ld", NSStringFromClass([self class]), aScreenId]];
    for (EGODatabaseRow *row in res)
        [ret addObject:[self _makeElemFromRow:row]];
    return ret;
}





@end
