//
//  BaseObject.m
//  KZBank
//
//  Created by Dymov, Yuri on 3/11/15.
//  Copyright (c) 2015 IBA. All rights reserved.
//

#import "BaseObject.h"
#import "SyncEngine.h"

@implementation BaseObject

@synthesize id_;
@synthesize createdAt;
@synthesize _icreatedAt;
@synthesize _iupdatedAt;
@synthesize updatedAt;

- (void)set_icreatedAt:(NSInteger)_aicreatedAt {
    _icreatedAt = _aicreatedAt;
    self.createdAt = [NSDate dateWithTimeIntervalSince1970:_aicreatedAt];
}

- (void)set_iupdatedAt:(NSInteger)_aiupdatedAt {
    _iupdatedAt = _aiupdatedAt;
    self.updatedAt = [NSDate dateWithTimeIntervalSince1970:_aiupdatedAt];
}

- (void)save {
    NSAssert(0, @"save not implemented");
}

- (void)rm {
    if (self.id_)
        [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"DELETE FROM '%@' WHERE id=%ld", NSStringFromClass([self class]), self.id_]];
}

+ (void)synchronize {
    [self _createTable];
    [[SyncEngine getInstance] synchronizeObject:NSStringFromClass([self class])];
}

+ (void)_createTable {
    NSAssert(0, @"%@ createTable not implemented", [self class]);
}

+ (NSUInteger)getLastTimestamp {
    [self _createTable];
    NSLog(@"%@", [self class]);
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT updatedAt FROM '%@' ORDER BY updatedAt DESC LIMIT 1", [self class]]];
    for (EGODatabaseRow *row in res) {
        return [row longForColumnAtIndex:0];
    }
    return 0;
}


+ (id)_makeElemFromRow:(EGODatabaseRow *)row {
    NSAssert(0, @"_makeElemFromRow not implemented");
    return nil;
}

+ (NSDictionary*)_mapping {
    NSAssert(0, @"_mapping not implemented");
    return @{};
}

+ (void)bulkSave:(NSArray *)objects {
    [self _createTable];
    [[KZDatabase getInstance] executeQuery:@"BEGIN"];
    for (BaseObject *object in objects)
        [object save];
    [[KZDatabase getInstance] executeQuery:@"COMMIT"];
}

+ (id)findById:(NSInteger)anId {
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE id=%ld", [self class], anId]];
    for (EGODatabaseRow *row in res)
        return [self _makeElemFromRow:row];
    return nil;
}

+ (NSArray*)findAll {
    NSMutableArray *ret = [NSMutableArray new];
    EGODatabaseResult *res = [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"SELECT * FROM '%@'", [self class]]];
    for (EGODatabaseRow * row in res)
        [ret addObject:[self _makeElemFromRow:row]];
    return ret;
}

+ (void)rmById:(NSUInteger)anId {
    [self _createTable];
    [self internalRmByIds:[NSString stringWithFormat:@"%lu", (unsigned long)anId]];
}

+ (void)rmByIds:(NSArray *)ids {
    [self _createTable];
    [self internalRmByIds:[ids componentsJoinedByString:@","]];
}

+ (void)internalRmByIds:(NSString *)ids {
    [self _createTable];
    [[KZDatabase getInstance] executeQuery:[NSString stringWithFormat:@"DELETE FROM '%@' WHERE id in (%@)", [self class], ids]];
}


@end
