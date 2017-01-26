//
//  MiscElem.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "MiscElem.h"

@implementation MiscElem

@synthesize title;
@synthesize value;
@synthesize block;
@synthesize blockId;
@synthesize color;

static BOOL _tableCreated = NO;


+ (void)_createTable {
    if (!_tableCreated) {
        _tableCreated = YES;
        [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ("
                                                "id INTEGER PRIMARY KEY,"
                                                "title TEXT,"
                                                "value REAL,"
                                                "blockId INTEGER,"
                                                "color TEXT,"
                                                "createdAt INTEGER,"
                                                "updatedAt INTEGER)", NSStringFromClass([self class])]];
    }
}

+ (NSDictionary*)_mapping {
    return @{
             @"id" : @"id_",
             @"title" : @"title",
             @"value" : @"value",
             @"misc_block_id" : @"blockId",
             @"color" : @"color",
             @"created_at" : @"_icreatedAt",
             @"updated_at" : @"_iupdatedAt"
             };
}

- (MiscBlock*)block {
    if (!block) {
        self.block = [MiscBlock findById:blockId];
    }
    return block;
}

- (void)save {
    [[self class] _createTable];
    [self rm];
    [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"INSERT INTO '%@' (id, blockId, title, value, createdAt, updatedAt, color) VALUES(%ld, %ld, ?, %f, %ld, %ld, ?)", [self class], self.id_, self.blockId, self.value, self._icreatedAt, self._iupdatedAt] parameters:@[self.title, color]];
}

+ (id)_makeElemFromRow:(EGODatabaseRow *)row {
    MiscElem *ret = [MiscElem new];
    ret.id_ = [row intForColumn:@"id"];
    ret.value = [row intForColumn:@"value"];
    ret.title = [row stringForColumn:@"title"];
    ret.color = [row stringForColumn:@"color"];
    ret.blockId = [row intForColumn:@"blockId"];
    ret._iupdatedAt = [row intForColumn:@"updatedAt"];
    ret._icreatedAt = [row intForColumn:@"createdAt"];
    return ret;
}

+ (NSArray*)findAllByBlockId:(NSInteger)aBlockId {
    NSMutableArray *ret = [NSMutableArray new];
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE blockId=%ld", NSStringFromClass([self class]), aBlockId]];
    for (EGODatabaseRow * row in res)
        [ret addObject:[self _makeElemFromRow:row]];
    return ret;
}

- (CPTColor*)cptColor {
    unsigned int red, green, blue;
    sscanf([self.color UTF8String], "%02X%02X%02X", &red, &green, &blue);
    float redf = ((float)red) / 255;
    float greenf = ((float)green) / 255;
    float bluef = ((float)blue) / 255;
    return [CPTColor colorWithComponentRed:redf green:greenf blue:bluef alpha:1.0f];
}



@end

