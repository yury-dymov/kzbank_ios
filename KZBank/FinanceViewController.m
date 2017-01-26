//
//  FinanceViewController.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/24/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "FinanceViewController.h"
#import "MiscElem.h"
#import "FinanceIndication.h"
#import "ViewController.h"
#import "RevenueViewController.h"
#import "CardViewController.h"
#import "MenuView.h"


@interface FinanceViewController ()

@property (nonatomic, strong) UTGTableView *_activeTableView;
@property (nonatomic, strong) UTGTableView *_passiveTableView;
@property (nonatomic, strong) UTGTableView *_capitalTableView;
@property (nonatomic, strong) CPTGraphHostingView *_activePieView;
@property (nonatomic, strong) CPTGraphHostingView *_passivePieView;
@property (nonatomic, strong) CPTGraphHostingView *_capitalPieView;
@property (nonatomic, strong) CPTGraphHostingView *_scatterView;
@property (nonatomic, strong) NSArray *_data;
@property (nonatomic, strong) NSArray *_pieData;
@property (nonatomic, strong) NSArray *_plotData;
@property (nonatomic, strong) CPTGraphHostingView *_hostingView;
@property (nonatomic, strong) UIView *_scatterHideView;


@end

@implementation FinanceViewController
@synthesize _data;
@synthesize _activeTableView;
@synthesize _passiveTableView;
@synthesize _capitalTableView;
@synthesize _activePieView;
@synthesize _passivePieView;
@synthesize _capitalPieView;
@synthesize _pieData;
@synthesize _plotData;
@synthesize _hostingView;
@synthesize _scatterView;
@synthesize _scatterHideView;


- (void)_loadData {
    NSMutableArray *data = [NSMutableArray new];
    [data addObject:[Finance findByTypeId:1]];
    [data addObject:[Finance findByTypeId:2]];
    [data addObject:[Finance findByTypeId:3]];
    _data = data;
    
    _pieData = [MiscBlock findByScreenId:2];
}

- (UIView*)_scatterHideView {
    if (!_scatterHideView) {
        self._scatterHideView = [[UIView alloc] initWithFrame:_hostingView.frame];
        self._scatterHideView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _scatterHideView;
}


- (UTGTableView*)_activeTableView {
    if (!_activeTableView) {
        self._activeTableView = [[UTGTableView alloc] initWithFrame:CGRectMake(46, 126, 700, 160) andHeaderHeight:40];
        self._activeTableView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
        self._activeTableView.delegate = self;
    }
    return _activeTableView;
}

- (UTGTableView*)_passiveTableView {
    if (!_passiveTableView) {
        self._passiveTableView = [[UTGTableView alloc] initWithFrame:CGRectMake(46, 286, 700, 160) andHeaderHeight:40];
        self._passiveTableView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
        self._passiveTableView.delegate = self;
    }
    return _passiveTableView;
}


- (UTGTableView*)_capitalTableView {
    if (!_capitalTableView) {
        self._capitalTableView = [[UTGTableView alloc] initWithFrame:CGRectMake(46, 446, 700, 165) andHeaderHeight:40];
        self._capitalTableView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
        self._capitalTableView.delegate = self;
    }
    return _capitalTableView;
}

- (CPTGraphHostingView*)_activePieView {
    if (!_activePieView) {
        _activePieView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(754, 163, 222, 120)];
        _activePieView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _activePieView;
}

- (CPTGraphHostingView*)_passivePieView {
    if (!_passivePieView) {
        _passivePieView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(754, 328, 222, 120)];
        _passivePieView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _passivePieView;
}

- (CPTGraphHostingView*)_capitalPieView {
    if (!_capitalPieView) {
        _capitalPieView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(754, 495, 222, 120)];
        _capitalPieView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _capitalPieView;
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


- (void)setupGraph {
    double min = [self _getMin];
    double max = [self _getMax];
    CPTXYGraph *barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    _hostingView.hostedGraph = barChart;
    
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
    
    
    
     NSUInteger labelLocation     = 0;
     NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:[_plotData count]];
    NSArray *texts = @[@"31.12.2014", @"31.03.2015", @"30.04.2015"];
    
    for (NSUInteger i = 0; i < _data.count; ++i) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[texts objectAtIndex:labelLocation] textStyle:y.labelTextStyle];
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

- (CPTGraphHostingView*)_hostingView {
    if (!_hostingView) {
        //        46, 214, 1024 - 94, 345
        _hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(46, 662, 1024 - 94, 768 - 662 - 10)];
        _hostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _hostingView;
}

- (void)_setupGraphs {
    NSArray *views = @[_activePieView, _passivePieView, _capitalPieView];
    for (CPTGraphHostingView *hostView in views) {
    CPTXYGraph *barChart = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = barChart;
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius    = 0.0;
    barChart.plotAreaFrame.masksToBorder   = NO;
    
    barChart.plotAreaFrame.paddingLeft   = 0;
    barChart.plotAreaFrame.paddingTop    = 0.0;
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
    pieChart.pieInnerRadius = pieChart.pieRadius - 10;
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
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(_setupGraphs) userInfo:nil repeats:NO];
    if (self._data.count) {
        [_activeTableView.aTableView.delegate tableView:_activeTableView.aTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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
    
    [self.view addSubview:self._activeTableView];
    [self.view addSubview:self._passiveTableView];
    [self.view addSubview:self._capitalTableView];
    
    [self.view addSubview:self._activePieView];
    [self.view addSubview:self._passivePieView];
    [self.view addSubview:self._capitalPieView];
    [self.view addSubview:self._hostingView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SW_bank_screen2_1"]];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(440, 90, 100, 40)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.text = @"31.12.2014";
    [self.view addSubview:dateLabel];
   
    UILabel *date2Label = [[UILabel alloc] initWithFrame:CGRectMake(540, 90, 100, 40)];
    date2Label.textAlignment = NSTextAlignmentCenter;
    date2Label.font = [UIFont systemFontOfSize:15];
    date2Label.textColor = [UIColor whiteColor];
    date2Label.text = @"31.03.2015";
    [self.view addSubview:date2Label];

    UILabel *date3Label = [[UILabel alloc] initWithFrame:CGRectMake(640, 90, 100, 40)];
    date3Label.textAlignment = NSTextAlignmentCenter;
    date3Label.font = [UIFont systemFontOfSize:15];
    date3Label.textColor = [UIColor whiteColor];
    date3Label.text = @"30.04.2015";
    [self.view addSubview:date3Label];
 
    MenuView *mView = [[MenuView alloc] initWithFrame:CGRectMake(580-91-45, 0, 1024 - 580 + 91 + 45, 73) andNavigationController:self.navigationController];
    mView.activeIndex = 1;
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
    Finance *object = [[_data objectAtIndex:[self _sectionByTable:anUtgTableView]] objectAtIndex:indexPath.row];
    if (!columnIndex) {
        UIView *view = [[UIView alloc] initWithFrame:lbl.bounds];
        lbl.frame = CGRectMake(20, 0, view.frame.size.width - 20, view.frame.size.height);
        if (object.bold) {
            lbl.font = [UIFont boldSystemFontOfSize:13];
        }
        lbl.text = object.title;
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
    if (utgTableView != _activeTableView) {
        for (NSIndexPath *indexPath in _activeTableView.aTableView.indexPathsForSelectedRows) {
            [_activeTableView.aTableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    if (utgTableView != _passiveTableView) {
        for (NSIndexPath *indexPath in _passiveTableView.aTableView.indexPathsForSelectedRows) {
            [_passiveTableView.aTableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    if (utgTableView != _capitalTableView) {
        for (NSIndexPath *indexPath in _capitalTableView.aTableView.indexPathsForSelectedRows) {
            [_capitalTableView.aTableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    self._plotData = [[[self._data objectAtIndex:[self _sectionByTable:utgTableView]] objectAtIndex:indexPath.row] indications];
    [self setupGraph];
    [_hostingView.hostedGraph reloadData];
    _scatterHideView.frame = CGRectMake(46, 662, 1024 - 94, 768 - 662 - 10);
    [_scatterHideView.layer removeAllAnimations];
    [UIView animateWithDuration:1.5 animations:^{
        _scatterHideView.frame = CGRectMake(_scatterHideView.frame.origin.x + _scatterHideView.frame.size.width, _scatterHideView.frame.origin.y, 0, _scatterHideView.frame.size.height);
    }];
}

- (NSInteger)numberOfSectionsInUTGTableView:(UTGTableView *)anUtgTableView {
    return 1;
}

- (NSInteger)_sectionByTable:(UTGTableView*)anUtgTableView {
    if (anUtgTableView == _activeTableView)
        return 0;
    else if (anUtgTableView == _passiveTableView)
        return 1;
    return 2;
}

- (NSInteger)numberOfRowsInUTGTableView:(UTGTableView *)anUtgTableView atSection:(NSInteger)section {
    return [[_data objectAtIndex:[self _sectionByTable:anUtgTableView]] count];
}

- (UIView*)headerViewForUTGTableView:(UTGTableView *)anUtgTableView atIndex:(NSInteger)index {
    NSArray *arr = @[@"Активы", @"Обязательства", @"Капитал"];
    if (!index) {
        UILabel *ret = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] andColumn:index], 40)];
        ret.backgroundColor = [UIColor colorWithRed:218.0/255 green:167.0/255 blue:3.0/255 alpha:1];
        ret.text = [NSString stringWithFormat:@"    %@", [arr objectAtIndex:[self _sectionByTable:anUtgTableView]]];
        ret.textColor = [UIColor whiteColor];
        return ret;
    } else {
        UILabel *ret = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] andColumn:index], 40)];
        ret.backgroundColor = [UIColor colorWithRed:218.0/255 green:167.0/255 blue:3.0/255 alpha:1];
        NSArray *fo = [_data objectAtIndex:[self _sectionByTable:anUtgTableView]];
        double sum = 0;
        for (Finance *f in fo) {
            FinanceIndication *fio = [f.indications objectAtIndex:index - 1];
            sum += fio.value;
        }
        ret.textAlignment = NSTextAlignmentCenter;
        ret.text = [NSString stringWithFormat:@"%0.2f", sum];
        ret.textColor = [UIColor whiteColor];
        return ret;
    }
    return nil;
}

- (NSInteger)_sectionByPie:(CPTPieChart*)pieChart {
    if ([pieChart.identifier isEqual:_activePieView.description])
        return 0;
    else if ([pieChart.identifier isEqual:_passivePieView.description])
        return 1;
    return 2;
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot isKindOfClass:[CPTPieChart class]]) {
        MiscBlock *block = [_pieData objectAtIndex:[self _sectionByPie:plot]];
        return block.elements.count;
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
        if (CPTPieChartFieldSliceWidth == fieldEnum)
        {
            MiscBlock *block = [_pieData objectAtIndex:[self _sectionByPie:plot]];
            MiscElem *elem = [block.elements objectAtIndex:index];
            num = [NSNumber numberWithDouble:elem.value];
        }
    }
    return num;
}


- (CPTFill*)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx {
    MiscBlock *block = [_pieData objectAtIndex:0];
    MiscElem *elem = [block.elements objectAtIndex:idx];
    return [CPTFill fillWithColor:elem.cptColor];
}


-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    MiscBlock *block = [_pieData objectAtIndex:[self _sectionByPie:pieChart]];
    MiscElem *elem = [block.elements objectAtIndex:index];
    return [elem.title stringByReplacingOccurrencesOfString:@" деятельность" withString:@""];
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
