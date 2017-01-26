//
//  FinanceViewController.h
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTGTableView.h"
#import <CorePlot-CocoaTouch.h>
#import <ADTransitionController.h>

@interface FinanceViewController : ADTransitioningViewController<UTGTableViewProtocol, CPTScatterPlotDataSource, CPTPieChartDataSource>

@end
