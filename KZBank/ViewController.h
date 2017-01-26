//
//  ViewController.h
//  KZBank
//
//  Created by Dymov, Yuri on 4/16/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot-CocoaTouch.h>
#import "UTGTableView.h"
#import <ADTransitioningViewController.h>

@interface ViewController : ADTransitioningViewController<UTGTableViewProtocol, CPTScatterPlotDataSource>


@end

