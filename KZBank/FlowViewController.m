//
//  FlowViewController.m
//  KZBank
//
//  Created by Dymov, Yuri on 5/16/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "FlowViewController.h"
#import "MiscBlock.h"
#import "MiscElem.h"
#import "MenuView.h"

@interface FlowViewController ()

@property (nonatomic, strong) NSArray *_plotData;
@property (nonatomic, strong) CPTGraphHostingView *_barHostingView;
@property (nonatomic, strong) CPTGraphHostingView *_paperHostingView;
@property (nonatomic, strong) CPTGraphHostingView *_coinHostingView;


@end

@implementation FlowViewController
@synthesize _plotData;
@synthesize _barHostingView;
@synthesize _paperHostingView;
@synthesize _coinHostingView;

- (void)_loadData {
    _plotData = [MiscBlock findByScreenId:6];
}

- (NSInteger)idxByHostingView:(CPTGraphHostingView*)view {
    if (view == _barHostingView)
        return 0;
    if (view == _paperHostingView)
        return 1;
    return 2;
}

- (CPTGraphHostingView*)_barHostingView {
    if (!_barHostingView) {
        _barHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(40, 508, 450, 250)];
        _barHostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _barHostingView;
}

- (CPTGraphHostingView*)_paperHostingView {
    if (!_paperHostingView) {
        _paperHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(40, 163, 450, 300)];
        _paperHostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _paperHostingView;
}

- (CPTGraphHostingView*)_coinHostingView {
    if (!_coinHostingView) {
        _coinHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(530, 163, 450, 300)];
        _coinHostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _coinHostingView;
}


- (void)_setupGraphs {
    CPTGraphHostingView *hostingView = _barHostingView;
        CPTXYGraph *barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
        hostingView.hostedGraph = barChart;
        hostingView.hostedGraph.identifier = hostingView.description;
        
        barChart.plotAreaFrame.borderLineStyle = nil;
        barChart.plotAreaFrame.cornerRadius    = 0.0;
        barChart.plotAreaFrame.masksToBorder   = NO;
        
        barChart.plotAreaFrame.paddingLeft   = 0;
        barChart.plotAreaFrame.paddingTop    = 0.0;
        barChart.plotAreaFrame.paddingRight  = 0.0;
        barChart.plotAreaFrame.paddingBottom = 0.0;
        
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:100]];
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:3]];
        
        CPTMutableLineStyle *style = [CPTMutableLineStyle lineStyle];
        style.lineColor = [CPTColor lightGrayColor];
        CPTMutableLineStyle *boldStyle = [CPTMutableLineStyle lineStyle];
        boldStyle.lineColor = [CPTColor blackColor];
        
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle new];
        textStyle.color = [CPTColor grayColor];
        
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
        CPTXYAxis *x          = axisSet.xAxis;
        x.axisLineStyle               = nil;
        x.majorTickLineStyle          = style;
        x.minorTickLineStyle          = nil;
        x.majorIntervalLength         = [NSNumber numberWithFloat:1];
        x.orthogonalPosition = [NSNumber numberWithDouble:0];
        //    x.title                       = @"X Axis";
        //    x.titleLocation               = CPTDecimalFromFloat(7.5f);
        //    x.titleOffset                 = 55.0;
        
        
        //    x.labelRotation  = M_PI_4;
        x.labelingPolicy = CPTAxisLabelingPolicyNone;
        CPTXYAxis *y = axisSet.yAxis;
        y.axisLineStyle               = nil;
        y.majorGridLineStyle = style;
        y.majorTickLineStyle          = style;
        y.minorTickLineStyle          = nil;
        y.labelTextStyle = textStyle;
        x.labelTextStyle = textStyle;
        y.orthogonalPosition = [NSNumber numberWithDouble:0];
        y.majorIntervalLength = [NSNumber numberWithDouble:10];
        y.labelingPolicy = CPTAxisLabelingPolicyNone;
        
        
        NSUInteger labelLocation     = 0;
        NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:[_plotData count]];
        NSArray *texts = @[@"01.04.2015", @"01.05.2015"];
        for (NSString *text in texts) {
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:text textStyle:y.labelTextStyle];
            newLabel.tickLocation = [NSNumber numberWithUnsignedInteger:++labelLocation];
            newLabel.offset = 2.0f;
            [customLabels addObject:newLabel];
        }
        x.axisLabels = customLabels;
        MiscBlock *mb = [_plotData objectAtIndex:0];
        MiscElem *me = [mb.elements objectAtIndex:0];
        
        CPTMutableLineStyle *barLineStyle   = [CPTMutableLineStyle lineStyle];
        barLineStyle.lineWidth              = 1.0;
        barLineStyle.lineColor              = [CPTColor whiteColor];
        CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
        whiteTextStyle.color                = [CPTColor whiteColor];
        
        CPTBarPlot *firstPlot = [CPTBarPlot tubularBarPlotWithColor:me.cptColor horizontalBars:NO];
        firstPlot.barBasesVary = YES;
        firstPlot.lineStyle = barLineStyle;
        firstPlot.fill = [CPTFill fillWithColor:me.cptColor];
        firstPlot.barWidth = [NSNumber numberWithFloat:0.65];
        firstPlot.dataSource = self;
        firstPlot.identifier = @"first";
        [barChart addPlot:firstPlot toPlotSpace:plotSpace];
        
        CPTBarPlot *secondPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor grayColor] horizontalBars:NO];
        secondPlot.lineStyle = barLineStyle;
        secondPlot.barBasesVary = YES;
        secondPlot.fill = [CPTFill fillWithColor:[CPTColor grayColor]];
        secondPlot.barWidth = [NSNumber numberWithFloat:0.65];
        secondPlot.dataSource = self;
        secondPlot.identifier = @"second";
        [barChart addPlot:secondPlot toPlotSpace:plotSpace];
    
    CPTBarPlot *legendPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor grayColor] horizontalBars:NO];
    legendPlot.identifier = @"legend";
    legendPlot.dataSource = self;
    [barChart addPlot:legendPlot toPlotSpace:plotSpace];
    
    
        CPTLegend *legend = [[CPTLegend alloc] initWithPlots:@[legendPlot]];
        legend.numberOfColumns = 1;
        legend.cornerRadius = 5.0;
        legend.delegate = self;
        CPTMutableTextStyle *mySmallerTextStyle = [CPTMutableTextStyle new];
        mySmallerTextStyle.lineBreakMode = NSLineBreakByWordWrapping;
        mySmallerTextStyle.fontSize = 12.0f;
        mySmallerTextStyle.color = [CPTColor blackColor];
        legend.textStyle = mySmallerTextStyle;

        barChart.legend = legend;
        barChart.legendAnchor = CPTRectAnchorRight;
  
  
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        [anim setDuration:0.6f];
        
        anim.toValue = [NSNumber numberWithFloat:1.0f];
        anim.fromValue = [NSNumber numberWithFloat:0.0f];
        anim.removedOnCompletion = NO;
        anim.delegate = self;
        anim.fillMode = kCAFillModeForwards;
        
        barChart.position = CGPointMake(0, 0);
        barChart.anchorPoint = CGPointMake(0.0, 0.0);
        
        [barChart addAnimation:anim forKey:@"grow"];
    
    for (CPTGraphHostingView *hostView in @[self._paperHostingView, self._coinHostingView]) {
        CPTXYGraph *barChart = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
        hostView.hostedGraph = barChart;
        barChart.plotAreaFrame.borderLineStyle = nil;
        barChart.plotAreaFrame.cornerRadius    = 0.0;
        barChart.plotAreaFrame.masksToBorder   = NO;
        
        barChart.plotAreaFrame.paddingLeft   = 30;
        barChart.plotAreaFrame.paddingTop    = 40.0;
        barChart.plotAreaFrame.paddingRight  = 110.0;
        
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
        CPTXYAxis *x          = axisSet.xAxis;
        x.axisLineStyle               = nil;
        x.majorTickLineStyle          = nil;
        x.minorTickLineStyle          = nil;
        x.labelingPolicy = CPTAxisLabelingPolicyNone;
        CPTXYAxis *y = axisSet.yAxis;
        y.axisLineStyle               = nil;
        y.majorTickLineStyle          = nil;
        y.minorTickLineStyle          = nil;
        y.labelingPolicy = CPTAxisLabelingPolicyNone;
        
        
        CPTPieChart *pieChart = [[CPTPieChart alloc] initWithFrame:hostView.bounds];
        pieChart.dataSource = self;
        pieChart.pieRadius = (hostView.bounds.size.height * 0.6f) / 2;
        pieChart.pieInnerRadius = pieChart.pieRadius - 20;
        pieChart.identifier = hostView.description;
        pieChart.startAngle = 0;
        pieChart.sliceDirection = CPTPieDirectionClockwise;
        CPTLegend *legend = [[CPTLegend alloc] initWithPlots:@[pieChart]];
        legend.numberOfColumns = 1;
        legend.cornerRadius = 5.0;
        legend.delegate = self;
        
        CPTMutableTextStyle *mySmallerTextStyle = [CPTMutableTextStyle new];
        mySmallerTextStyle.lineBreakMode = NSLineBreakByWordWrapping;
        mySmallerTextStyle.fontSize = 12.0f;
        mySmallerTextStyle.color = [CPTColor blackColor];
        legend.textStyle = mySmallerTextStyle;
        //legend.delegate = self;
        barChart.legend = legend;
        barChart.legendAnchor = CPTRectAnchorRight;
        //    barChart.legendDisplacement = CGPointMake(100.0, 0);
        
        CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation.removedOnCompletion = YES;
        rotation.fromValue = [NSNumber numberWithFloat:M_PI*1];
        rotation.toValue = [NSNumber numberWithFloat:0];
        rotation.duration = 1.0f;
        rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        rotation.delegate = self;
        [pieChart addAnimation:rotation forKey:@"rotation"];
        
        [hostView.hostedGraph addPlot:pieChart];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _loadData];
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(_setupGraphs) userInfo:nil repeats:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SW_bank_screen5"]];
    UILabel *fixLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 300, 30)];
    fixLabel.textColor = [UIColor lightGrayColor];
    fixLabel.font = [UIFont boldSystemFontOfSize:12];
    fixLabel.text = @"МОБИЛЬНОЕ ПРИЛОЖЕНИЕ ДЛЯ";
    fixLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fixLabel];
    
    
    [self.view addSubview:self._barHostingView];
    [self.view addSubview:self._coinHostingView];
    [self.view addSubview:self._paperHostingView];
    
    MenuView *mView = [[MenuView alloc] initWithFrame:CGRectMake(580-91-45, 0, 1024 - 580 + 91 + 45, 73) andNavigationController:self.navigationController];
    mView.activeIndex = 4;
    [self.view addSubview:mView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(_barHostingView.frame.origin.x, _barHostingView.frame.origin.y, _barHostingView.frame.size.width, 39)];
    bgView.backgroundColor = [UIColor colorWithRed:40.0/255 green:144.0/255 blue:101.0/255 alpha:1];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, bgView.frame.size.width - 40, bgView.frame.size.height)];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:lbl];
    lbl.text = @"Оборот монет и банкнот";
    [self.view addSubview:bgView];

    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(_paperHostingView.frame.origin.x, _paperHostingView.frame.origin.y, _paperHostingView.frame.size.width, 39)];
    bgView2.backgroundColor = [UIColor colorWithRed:40.0/255 green:144.0/255 blue:101.0/255 alpha:1];
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, bgView2.frame.size.width - 40, bgView2.frame.size.height)];
    lbl2.textColor = [UIColor whiteColor];
    lbl2.font = [UIFont systemFontOfSize:15];
    [bgView2 addSubview:lbl2];
    lbl2.text = @"Банкноты по номиналам";
    [self.view addSubview:bgView2];

    UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(_coinHostingView.frame.origin.x, _coinHostingView.frame.origin.y, _coinHostingView.frame.size.width, 39)];
    bgView3.backgroundColor = [UIColor colorWithRed:40.0/255 green:144.0/255 blue:101.0/255 alpha:1];
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, bgView3.frame.size.width - 40, bgView3.frame.size.height)];
    lbl3.textColor = [UIColor whiteColor];
    lbl3.font = [UIFont systemFontOfSize:15];
    [bgView3 addSubview:lbl3];
    lbl3.text = @"Монеты по номиналам";
    [self.view addSubview:bgView3];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 900, 40)];
    title.font = [UIFont systemFontOfSize:24];
    title.text = @"Объем наличных денег национальной валюты в обращении";
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot.identifier isEqual:@"legend"])
        return 2;
    MiscBlock *mb = [_plotData objectAtIndex:[self idxByHostingView:plot.graph.hostingView]];
    return mb.elements.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ([plot.identifier isEqual:@"legend"])
        return nil;
    NSNumber *num = nil;
    if ( [plot isKindOfClass:[CPTPieChart class]] ) {
        if (CPTPieChartFieldSliceWidth == fieldEnum)
        {
            MiscBlock *block = [_plotData objectAtIndex:[self idxByHostingView:plot.graph.hostingView]];
            MiscElem *elem = [block.elements objectAtIndex:index];
            num = [NSNumber numberWithDouble:elem.value];
        }
    } else {
    
        if (fieldEnum == CPTBarPlotFieldBarLocation) {
            return [NSNumber numberWithLong:index + 1];
        } else  {
            if (index >= 2)
                return nil;
            MiscBlock *mb = [_plotData objectAtIndex:[self idxByHostingView:plot.graph.hostingView]];
            
            double sum = 0;
            for (MiscElem *el in mb.elements) {
                sum += el.value;
            }
            MiscElem *me1 = [mb.elements objectAtIndex:2 * index];
            MiscElem *me2 = [mb.elements objectAtIndex:2 * index + 1];
            double offset = 0;
            if (((CPTBarPlot *)plot).barBasesVary) {
                offset += me1.value;
            }
            
            if (fieldEnum == CPTBarPlotFieldBarTip) {
                if ([plot.identifier isEqual:@"second"])
                    return [NSNumber numberWithDouble:me2.value + me1.value];
                else
                    return [NSNumber numberWithDouble:me1.value];
            }
            else {
                if ([plot.identifier isEqual:@"second"])
                    return [NSNumber numberWithDouble:me1.value];
                return [NSNumber numberWithInt:0];
            }
        }
    }
    return num;
}


- (CPTFill*)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx {
    MiscBlock *block = [_plotData objectAtIndex:[self idxByHostingView:pieChart.graph.hostingView]];
    MiscElem *elem = [block.elements objectAtIndex:idx];
    return [CPTFill fillWithColor:elem.cptColor];
}


-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    MiscBlock *block = [_plotData objectAtIndex:[self idxByHostingView:pieChart.graph.hostingView]];
    MiscElem *elem = [block.elements objectAtIndex:index];
    return elem.title;
}

- (NSString*)legendTitleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx{
    MiscBlock *block = [_plotData objectAtIndex:0];
    MiscElem *elem = [block.elements objectAtIndex:idx];
    return elem.title;
}



- (CPTFill*)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx {
    if ([barPlot.identifier isEqual:@"legend"]) {
        MiscBlock *mb = [_plotData objectAtIndex:0];
        MiscElem *me = [mb.elements objectAtIndex:idx];
        return [CPTFill fillWithColor:me.cptColor];
    }
    MiscBlock *mb = [_plotData objectAtIndex:[self idxByHostingView:barPlot.graph.hostingView]];
    MiscElem *me = [mb.elements objectAtIndex:1];
    if ([barPlot.identifier isEqual:@"first"]) {
        me = [mb.elements objectAtIndex:0];
    }
    return [CPTFill fillWithColor:me.cptColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
