//
//  FlowViewController.h
//  KZBank
//
//  Created by Dymov, Yuri on 5/16/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADTransitionController.h>
#import <CorePlot-CocoaTouch.h>

@interface FlowViewController : ADTransitioningViewController<CPTBarPlotDataSource, CPTPieChartDataSource>

@end
