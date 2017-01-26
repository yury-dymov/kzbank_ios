//
//  Finance.h
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "BaseObject.h"

@interface Finance : BaseObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) NSArray *indications;
@property (nonatomic, assign) BOOL bold;

+ (NSArray*)findByTypeId:(NSInteger)aTypeId;

@end
