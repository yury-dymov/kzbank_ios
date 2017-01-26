//
//  KZVar.h
//  KZBank
//
//  Created by Dymov, Yuri on 3/11/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZVar : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;

- (void)save;
- (void)rm;

+ (KZVar*)findByKey:(NSString*)key;

@end
