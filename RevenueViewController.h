//
//  RevenueViewController.h
//  KZBank
//
//  Created by Dymov, Yuri on 4/25/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTGTableView.h"
#import <CorePlot-CocoaTouch.h>
#import <ADTransitioningViewController.h>

@interface RevenueViewController : ADTransitioningViewController<UTGTableViewProtocol, CPTBarPlotDataSource, CPTScatterPlotDataSource>

@end
