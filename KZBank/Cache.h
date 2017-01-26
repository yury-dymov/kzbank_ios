//
//  Cache.h
//  KZBank
//
//  Created by Dymov, Yuri on 4/26/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "ViewController.h"
#import "FinanceViewController.h"
#import "RevenueViewController.h"
#import "CardViewController.h"
#import "FlowViewController.h"

@interface Cache : NSObject

+ (ViewController*)viewController;
+ (FinanceViewController*)financeViewController;
+ (RevenueViewController*)revenueViewController;
+ (CardViewController*)cardViewController;
+ (FlowViewController*)flowViewController;

+ (ADTransitioningViewController*)vcAtIndex:(NSInteger)idx;

@end
