//
//  BaseObject.h
//  KZBank
//
//  Created by Dymov, Yuri on 3/11/15.
//  Copyright (c) 2015 IBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZDatabase.h"

@interface BaseObject : NSObject

@property (nonatomic, assign) NSInteger id_;
@property (nonatomic, assign) NSInteger _iupdatedAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, assign) NSInteger _icreatedAt;
@property (nonatomic, strong) NSDate *createdAt;

- (void)save;
- (void)rm;

+ (NSArray*)findAll;
+ (void)synchronize;

+ (void)bulkSave:(NSArray*)objects;
+ (void)_createTable;
+ (NSUInteger)getLastTimestamp;

+ (NSDictionary*)_mapping;
+ (id)_makeElemFromRow:(EGODatabaseRow*)row;
+ (id)findById:(NSInteger)anId;

+ (void)rmByIds:(NSArray*)ids;
+ (void)internalRmByIds:(NSString*)ids;
+ (void)rmById:(NSUInteger)anId;


@end
