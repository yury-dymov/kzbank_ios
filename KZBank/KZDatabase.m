//
//  KZDatabase.m
//  KZBank
//
//  Created by Dymov, Yuri on 3/11/15.
//  Copyright (c) 2015 IBA. All rights reserved.
//

#import "KZDatabase.h"

static KZDatabase *_instance;

@interface KZDatabase()

@property (nonatomic, strong) EGODatabase *_db;

@end

@implementation KZDatabase
@synthesize _db;

- (id)init {
    if (!_instance) {
        self = [super init];
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"kzdb.sqlite3"];
        
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
            [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"kzdb" ofType:@"sqlite3"] toPath:dbPath error:nil];
        }
        _db = [[EGODatabase alloc] initWithPath:dbPath];
        _instance = self;
        [_db open];
    }
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    if (!_instance) {
        return [super allocWithZone:zone];
    }
    return _instance;
}

+ (id)getInstance {
    if (!_instance)
        return [self new];
    return _instance;
}

- (EGODatabaseResult*)executeQuery:(NSString *)query {
    return [_db executeQuery:query];
}

- (EGODatabaseResult*)executeQuery:(NSString *)query parameters:(NSArray*)parameters{
    return [_db executeQuery:query parameters:parameters];
}


@end
