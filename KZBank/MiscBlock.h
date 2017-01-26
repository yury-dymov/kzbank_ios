//
//  MiscBlock.h
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "BaseObject.h"

@interface MiscBlock : BaseObject

@property (nonatomic, assign) NSInteger screenId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *elements;

+ (NSArray*)findByScreenId:(NSInteger)aScreenId;

@end
