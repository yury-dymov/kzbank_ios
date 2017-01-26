//
//  Cache.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/26/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "Cache.h"

@implementation Cache

static ViewController *_vc;
static FinanceViewController * _fvc;
static RevenueViewController *_rvc;
static CardViewController * _cvc;
static FlowViewController *_flowVc;

+ (ViewController*)viewController {
    if (!_vc) {
        _vc = [ViewController new];
    }
    return _vc;
}

+ (FinanceViewController*)financeViewController {
    if (!_fvc) {
        _fvc = [FinanceViewController new];
    }
    return _fvc;
}

+ (RevenueViewController*)revenueViewController {
    if (!_rvc) {
        _rvc = [RevenueViewController new];
    }
    return _rvc;
}

+ (CardViewController*)cardViewController {
    if (!_cvc) {
        _cvc = [CardViewController new];
    }
    return _cvc;
}

+ (FlowViewController*)flowViewController {
    if (!_flowVc) {
        _flowVc = [FlowViewController new];
    }
    return _flowVc;
}

+ (ADTransitioningViewController*)vcAtIndex:(NSInteger)idx {
    NSArray *vcs = @[@"viewController", @"financeViewController", @"revenueViewController", @"cardViewController", @"flowViewController"];
    return [Cache performSelector:NSSelectorFromString([vcs objectAtIndex:idx])];
}

@end
