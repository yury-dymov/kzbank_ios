//
//  RevenueViewController.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/25/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "RevenueViewController.h"
#import "FinanceIndication.h"
#import "Finance.h"
#import "MiscElem.h"
#import "ViewController.h"
#import "FinanceViewController.h"
#import "CardViewController.h"
#import "MenuView.h"

@interface RevenueViewController ()

@property (nonatomic, strong) NSArray *_plotData;
@property (nonatomic, strong) NSArray *_data;
@property (nonatomic, strong) NSArray *_barData;
@property (nonatomic, strong) UTGTableView *_dataTableView;
@property (nonatomic, strong) CPTGraphHostingView *_activeHostingView;
@property (nonatomic, strong) CPTGraphHostingView *_passiveHostingView;
@property (nonatomic, strong) CPTGraphHostingView *_capitalHostingView;
@property (nonatomic, strong) CPTGraphHostingView *_scatterView;
@property (nonatomic, strong) UIView *_scatterHideView;

@end

@implementation RevenueViewController
@synthesize _scatterView;
@synthesize _data;
@synthesize _plotData;
@synthesize _dataTableView;
@synthesize _activeHostingView;
@synthesize _passiveHostingView;
@synthesize _capitalHostingView;
@synthesize _barData;
@synthesize _scatterHideView;

- (void)_loadData {
    _data = [Finance findByTypeId:4];
    _barData = [MiscBlock findByScreenId:3];
}

- (UTGTableView*)_dataTableView {
    if (!_dataTableView) {
        self._dataTableView = [[UTGTableView alloc] initWithFrame:CGRectMake(46, 126, 700, 491) andHeaderHeight:60];
        self._dataTableView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
        self._dataTableView.delegate = self;
    }
    return _dataTableView;
}

- (UIView*)_scatterHideView {
    if (!_scatterHideView) {
        self._scatterHideView = [[UIView alloc] initWithFrame:_scatterView.frame];
        self._scatterHideView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _scatterHideView;
}


- (CPTGraphHostingView*)_activeHostingView {
    if (!_activeHostingView) {
        _activeHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(754, 163, 222, 120)];
        _activeHostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _activeHostingView;
}

- (CPTGraphHostingView*)_passiveHostingView {
    if (!_passiveHostingView) {
        _passiveHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(754, 328, 222, 120)];
        _passiveHostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _passiveHostingView;
}

- (CPTGraphHostingView*)_capitalHostingView {
    if (!_capitalHostingView) {
        _capitalHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(754, 495, 222, 120)];
        _capitalHostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _capitalHostingView;
}

- (double)_getMin {
    double ret = INT_MAX;
    for (FinanceIndication *eio in _plotData) {
        if (eio.value < ret)
            ret = eio.value;
    }
    return ret;
}

- (double)_getMax {
    double ret = INT_MIN;
    for (FinanceIndication *eio in _plotData) {
        if (eio.value > ret)
            ret = eio.value;
    }
    return ret;
}

- (NSInteger)graphIndex:(CPTGraphHostingView*)hostingView {
    if (hostingView == _activeHostingView) {
        return 0;
    } else if (hostingView == _passiveHostingView) {
        return 1;
    }
    return 2;
}

- (void)_setupGraphs {
    NSArray *graphs = @[self._activeHostingView, self._passiveHostingView, self._capitalHostingView];
    for (CPTGraphHostingView *hostingView in graphs) {
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
        NSArray *texts = @[@"2014", @"2015"];
        for (NSString *text in texts) {
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:text textStyle:y.labelTextStyle];
            newLabel.tickLocation = [NSNumber numberWithUnsignedInteger:++labelLocation];
            newLabel.offset = 2.0f;
            [customLabels addObject:newLabel];
        }
        x.axisLabels = customLabels;
        MiscBlock *mb = [_barData objectAtIndex:[self graphIndex:hostingView]];
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
        
    }
}

- (CPTGraphHostingView*)_scatterView {
    if (!_scatterView) {
        //        46, 214, 1024 - 94, 345
        self._scatterView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(46, 662, 1024 - 94, 768 - 662 - 10)];
        _scatterView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _scatterView;
}

- (void)setupGraph {
    double min = [self _getMin];
    double max = [self _getMax];
    CPTXYGraph *barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    _scatterView.hostedGraph = barChart;
    
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius    = 0.0;
    barChart.plotAreaFrame.masksToBorder   = NO;
    
    barChart.plotAreaFrame.paddingLeft   = 100;
    barChart.plotAreaFrame.paddingTop    = 0.0;
    barChart.plotAreaFrame.paddingRight  = 50.0;
    barChart.plotAreaFrame.paddingBottom = 0.0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:min] length:[NSNumber numberWithFloat:max - min]];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:1] length:[NSNumber numberWithFloat:2]];
    
    CPTMutableLineStyle *style = [CPTMutableLineStyle lineStyle];
    style.lineColor = [CPTColor lightGrayColor];
    CPTMutableLineStyle *boldStyle = [CPTMutableLineStyle lineStyle];
    boldStyle.lineColor = [CPTColor blackColor];
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle new];
    textStyle.color = [CPTColor grayColor];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = boldStyle;
    x.majorTickLineStyle          = style;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength         = [NSNumber numberWithFloat:1];
    x.labelTextStyle = textStyle;
    x.orthogonalPosition = [NSNumber numberWithDouble:min];
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
    y.orthogonalPosition = [NSNumber numberWithDouble:1];
    y.majorIntervalLength = [NSNumber numberWithDouble:5];
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    
    
    
    NSUInteger labelLocation     = 0;
    NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:[_plotData count]];
    NSArray *texts = @[@"31.12.2014", @"31.03.2015", @"30.04.2015"];
    for (NSString *text in texts) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:text textStyle:y.labelTextStyle];
        newLabel.tickLocation = [NSNumber numberWithUnsignedInteger:++labelLocation];
        newLabel.offset = 5.0f;
        [customLabels addObject:newLabel];
    }
    x.axisLabels = customLabels;
    
    // First bar plot
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.dataSource = self;
    [barChart addPlot:dataSourceLinePlot];
    
    CPTMutableLineStyle *mainPlotLineStyle = [CPTMutableLineStyle lineStyle];
    [mainPlotLineStyle setLineWidth:4.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithComponentRed:168.0/255 green:65.0/255 blue:226.0/255 alpha:1]];
    
    [dataSourceLinePlot setDataLineStyle:mainPlotLineStyle];
    
    CPTColor *areaColor = [CPTColor colorWithComponentRed:168.0/255 green:65.0/255 blue:226.0/255 alpha:0.5];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    [areaGradient setAngle:-90.0f];
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    [dataSourceLinePlot setAreaFill:areaGradientFill];
    [dataSourceLinePlot setAreaBaseValue:[NSNumber numberWithFloat:min]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _loadData];
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(_setupGraphs) userInfo:nil repeats:NO];
    
    if (self._data.count) {
        [_dataTableView.aTableView.delegate tableView:_dataTableView.aTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *fixLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 300, 30)];
    fixLabel.textColor = [UIColor lightGrayColor];
    fixLabel.font = [UIFont boldSystemFontOfSize:12];
    fixLabel.text = @"МОБИЛЬНОЕ ПРИЛОЖЕНИЕ ДЛЯ";
    fixLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fixLabel];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SW_bank_screen3"]];
    [self.view addSubview:self._dataTableView];
    
    [self.view addSubview:self._activeHostingView];
    [self.view addSubview:self._passiveHostingView];
    [self.view addSubview:self._capitalHostingView];
    [self.view addSubview:self._scatterView];
    
    MenuView *mView = [[MenuView alloc] initWithFrame:CGRectMake(580-91-45, 0, 1024 - 580 + 91 + 45, 73) andNavigationController:self.navigationController];
    mView.activeIndex = 2;
    [self.view addSubview:mView];
    
    [self.view addSubview:self._scatterHideView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)valueForUTGTableView:(UTGTableView *)anUtgTableView atIndexPath:(NSIndexPath *)indexPath andColumn:(NSInteger)columnIndex {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:indexPath andColumn:columnIndex], 40)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.numberOfLines = 0;
    lbl.font = [UIFont systemFontOfSize:13];
    Finance *object = [_data objectAtIndex:indexPath.row];
    if (!columnIndex) {
        UIView *view = [[UIView alloc] initWithFrame:lbl.bounds];
        lbl.frame = CGRectMake(20, 0, view.frame.size.width - 20, view.frame.size.height);
        lbl.text = object.title;
        if (object.bold) {
            lbl.font = [UIFont boldSystemFontOfSize:13];
        }
        [view addSubview:lbl];
        view.backgroundColor = [UIColor clearColor];
        return view;
    } else {
        lbl.textAlignment = NSTextAlignmentCenter;
        FinanceIndication *fio = [object.indications objectAtIndex:columnIndex - 1];
        lbl.text = [NSString stringWithFormat:@"%0.2f", fio.value];
    }
    return lbl;
}

- (CGFloat)heightForUTGTableView:(UTGTableView *)utgTableView {
    return 40;
}

- (NSInteger)numberOfColumnsInUTGTableView:(UTGTableView *)anUtgTableView atIndexPath:(NSIndexPath *)indexPath {
    return 4;
}

- (CGFloat)widthForUTGTableView:(UTGTableView *)anUtgTableView atIndexPath:(NSIndexPath *)indexPath andColumn:(NSInteger)columnIndex {
    switch (columnIndex) {
        case 0:
            return 400;
        default:
            return 102;
    }
}

- (UIColor*)selectedBackgroundColorInUTGTableView:(UTGTableView *)utgTableView {
    return [UIColor colorWithRed:42.0/255 green:156.0/255 blue:109.0/255 alpha:1.0];
}

- (void)UTGTableView:(UTGTableView *)utgTableView selectedIndexPath:(NSIndexPath *)indexPath selectedColumnIndex:(NSInteger)columnIndex {
    self._plotData = [[self._data objectAtIndex:indexPath.row] indications];
    [self setupGraph];
    [_scatterView.hostedGraph reloadData];
    _scatterHideView.frame = CGRectMake(46, 662, 1024 - 94, 768 - 662 - 10);
    [_scatterHideView.layer removeAllAnimations];
    [UIView animateWithDuration:1.5 animations:^{
        _scatterHideView.frame = CGRectMake(_scatterHideView.frame.origin.x + _scatterHideView.frame.size.width, _scatterHideView.frame.origin.y, 0, _scatterHideView.frame.size.height);
    }];
    
}

- (NSInteger)numberOfSectionsInUTGTableView:(UTGTableView *)anUtgTableView {
    return 1;
}


- (NSInteger)numberOfRowsInUTGTableView:(UTGTableView *)anUtgTableView atSection:(NSInteger)section {
    return [_data count];
}

- (UIView*)headerViewForUTGTableView:(UTGTableView *)anUtgTableView atIndex:(NSInteger)index {
    NSArray *dates = @[@"31.12.2014", @"31.03.2015", @"30.04.2015"];
    if (!index) {
        UILabel *ret = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] andColumn:index], 60)];
        ret.backgroundColor = [UIColor clearColor];
        ret.text = [NSString stringWithFormat:@"    Наименование статей"];
        return ret;
    } else {
        UILabel *ret = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] andColumn:index], 60)];
        ret.backgroundColor = [UIColor clearColor];
        ret.textAlignment = NSTextAlignmentCenter;
        ret.text = [dates objectAtIndex:index - 1];
        return ret;
    }
    return nil;
}

/*
- (NSInteger)_sectionByPie:(CPTPieChart*)pieChart {
    if ([pieChart.identifier isEqual:_activePieView.description])
        return 0;
    else if ([pieChart.identifier isEqual:_passivePieView.description])
        return 1;
    return 2;
}
*/
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        MiscBlock *mb = [_barData objectAtIndex:[self graphIndex:plot.graph.hostingView]];
        return mb.elements.count;
    } else {
        return _plotData.count;
    }
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    if ( [plot isKindOfClass:[CPTScatterPlot class]] ) {
        if (fieldEnum == CPTScatterPlotFieldX)
            return [NSNumber numberWithLong:index + 1];
        FinanceIndication *fio = [_plotData objectAtIndex:index];
        return [NSNumber numberWithDouble:fio.value];
    } else {
        if (fieldEnum == CPTBarPlotFieldBarLocation) {
            return [NSNumber numberWithLong:index + 1];
        } else  {
            MiscBlock *mb = [_barData objectAtIndex:[self graphIndex:plot.graph.hostingView]];
            MiscElem *me = [mb.elements objectAtIndex:index];
            double offset = 0;
            if (((CPTBarPlot *)plot).barBasesVary) {
                    offset += me.value;
            }
            
            if (fieldEnum == CPTBarPlotFieldBarTip) {
                if ([plot.identifier isEqual:@"second"])
                    return [NSNumber numberWithDouble:me.value];
                else
                    return [NSNumber numberWithDouble:100];
            }
            else {
                if ([plot.identifier isEqual:@"second"])
                    return [NSNumber numberWithDouble:100];
                return [NSNumber numberWithInt:0];
            }
        }
    }
    return num;
}

- (CPTFill*)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx {
    if ([barPlot.identifier isEqual:@"first"]) {
        MiscBlock *mb = [_barData objectAtIndex:[self graphIndex:barPlot.graph.hostingView]];
 //   MiscBlock *mb = [_barData objectAtIndex:2];
        MiscElem *me = [mb.elements objectAtIndex:0];
        return [CPTFill fillWithColor:me.cptColor];
    }
    return [CPTFill fillWithColor:[CPTColor grayColor]];
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
