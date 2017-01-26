//
//  SyncEngine.m
//  KZBank
//
//  Created by Dymov, Yuri on 3/11/15.
//  Copyright (c) 2015 IBA. All rights reserved.
//

#import "SyncEngine.h"
#import "KZVar.h"
#import "BaseObject.h"
#import <RestKit/RestKit.h>


static SyncEngine *_instance;

@interface SyncEngine() {
    NSUInteger _syncObjectCount;
    BOOL _success;
    BOOL _syncing;
}

@property (nonatomic, strong) NSMutableDictionary *_syncDict;

@end

@implementation SyncEngine

@synthesize _syncDict;

- (id)init {
    if (!_instance) {
        self = [super init];
        [AFRKNetworkActivityIndicatorManager sharedManager].enabled = YES;
        AFRKHTTPClient *client = [[AFRKHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://kzbank.herokuapp.com/"]];
        [client setDefaultHeader:@"Content-Type" value:RKMIMETypeJSON];
        [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        [client setDefaultHeader:@"User-Agent" value:@"iOS Application"];
        RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
        [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];

//        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
        
        _instance = self;
    }
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    if (_instance)
        return _instance;
    return [super allocWithZone:zone];
}

+ (id)getInstance {
    if (!_instance) {
        return [self new];
    }
    return _instance;
}

- (void)cleanUp {
    [self cleanUpWithBlock:nil];
}

- (void)_commitSync:(NSString*)state withBlock:(CleanUpBlock)block {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKObjectMapping *commitMapping = [RKObjectMapping mappingForClass:[KZVar class]];
    [commitMapping addAttributeMappingsFromDictionary:@{@"success": @"value"}];
    RKResponseDescriptor *commitDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commitMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:nil];
    [manager addResponseDescriptor:commitDescriptor];
    KZVar *var = [KZVar new];
    [manager getObject:var path:@"/modata/commit" parameters:
     @{@"platform":@"ios",
       @"sync_state":state,
       @"device_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString]
       }
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   if (block) {
                       if ([var.value isEqualToString:@"1"]) {
                           block(YES);
                       } else {
                           block(NO);
                       }
                   }
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   if (block)
                       block(NO);
               }];
    [manager removeResponseDescriptor:commitDescriptor];
}

- (void)cleanUpWithBlock:(CleanUpBlock)block {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    KZVar *var = [KZVar findByKey:@"sync_state"];
    
    NSString *parameter = @"init";
    if (var) {
        parameter = var.value;
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[KZVar class]];
        [mapping addAttributeMappingsFromDictionary:@{@"table":@"key", @"ids":@"value"}];
        RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:nil];
        [manager addResponseDescriptor:descriptor];
        [manager getObjectsAtPath:[NSString stringWithFormat:@"/modata/deleted/%@", parameter] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSString *syncState = @"0";
            for (KZVar *var in mappingResult.array) {
                if ([var.key isEqualToString:@"sync_state"]) {
                    [var save];
                    syncState = var.value;
                } else {
                    [NSClassFromString(var.key) internalRmByIds:var.value];
                }
            }
            [self _commitSync:syncState withBlock:block];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            if (block)
                block(NO);
        }];
        [manager removeResponseDescriptor:descriptor];
    } else {
        var = [KZVar new];
        var.key = @"sync_state";
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[KZVar class]];
        [mapping addAttributeMappingsFromDictionary:@{@"sync_state":@"value"}];
        RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:nil];
        [manager addResponseDescriptor:descriptor];
        [manager getObject:var path:[NSString stringWithFormat:@"/modata/deleted/%@", parameter] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [var save];
            [self _commitSync:var.value withBlock:block];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            if (block)
                block(NO);
        }];
        [manager removeResponseDescriptor:descriptor];
    }
    return;
}

- (void)_syncDone:(NSString*)className success:(BOOL)result{
    _success = _success && result;
    [_syncDict setValue:className forKey:className];
    if (_syncDict.count == _syncObjectCount) {
        _syncing = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"syncDone" object:[NSNumber numberWithBool:_success]];
    }
}


- (void)syncAll {
    if (!_syncing) {
        _syncing = YES;
        [_syncDict removeAllObjects];
        _success = YES;
        NSArray *objects = @[@"Exchange", @"Indication", @"FinanceIndication", @"Finance", @"MiscBlock", @"MiscElem", @"CurrencyExchange", @"Commodity"];
        
        for (NSString *object in objects) {
            [NSClassFromString(object) synchronize];
        }
        
        _syncObjectCount = objects.count + 1; // cleanup
        [self cleanUpWithBlock:^(BOOL success) {
            [self _syncDone:@"_cleanup" success:success];
        }];
    }
}


- (void)synchronizeObject:(NSString *)className withRemoteTable:(NSString *)tableName {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[NSClassFromString(className) class]];
    [projectMapping addAttributeMappingsFromDictionary:[NSClassFromString(className) _mapping]];
    RKResponseDescriptor *projectDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:projectMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:nil];
    
    [manager addResponseDescriptor:projectDescriptor];
    [manager getObjectsAtPath:[NSString stringWithFormat:@"/modata/data/%@", tableName] parameters:@{@"timestamp":[NSNumber numberWithInteger:[NSClassFromString(className) getLastTimestamp]]} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [NSClassFromString(className) bulkSave:mappingResult.array];
        [self _syncDone:className success:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self _syncDone:className success:NO];
    }];
    [manager removeResponseDescriptor:projectDescriptor];
}


- (void)synchronizeObject:(NSString *)className {
    [self synchronizeObject:className withRemoteTable:className];
}

@end
