//
//  SyncEngine.h
//  KZBank
//
//  Created by Dymov, Yuri on 3/11/15.
//  Copyright (c) 2015 IBA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CleanUpBlock)(BOOL success);

@interface SyncEngine : NSObject

+ (id)getInstance;

- (void)cleanUp;
- (void)cleanUpWithBlock:(CleanUpBlock)block;
- (void)syncAll;
- (void)synchronizeObject:(NSString*)className;
- (void)synchronizeObject:(NSString*)className withRemoteTable:(NSString*)tableName;

@end
