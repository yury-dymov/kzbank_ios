//
//  Card2ViewController.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/26/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "Card2ViewController.h"
#import "MiscElem.h"
#import "CardViewController.h"
#import "ViewController.h"
#import "FinanceViewController.h"
#import "RevenueViewController.h"
#import "MenuView.h"


@interface Card2ViewController ()

@property (nonatomic, strong) CPTGraphHostingView *_activeHostingView;
@property (nonatomic, strong) CPTGraphHostingView *_passiveHostingView;
@property (nonatomic, strong) CPTGraphHostingView *_capitalHostingView;
@property (nonatomic, strong) CPTGraphHostingView *_activeHostingView2;

@property (nonatomic, strong) NSArray *_barData;


@end

@implementation Card2ViewController
@synthesize _activeHostingView;
@synthesize _passiveHostingView;
@synthesize _capitalHostingView;
@synthesize _activeHostingView2;
@synthesize _barData;

- (void)loadData {
    self._barData = [MiscBlock findByScreenId:5];
}

- (CPTGraphHostingView*)_activeHostingView {
    if (!_activeHostingView) {
        _activeHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(46, 244, 438, 201)];
        _activeHostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _activeHostingView;
}

- (CPTGraphHostingView*)_passiveHostingView {
    if (!_passiveHostingView) {
        _passiveHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(533, 244, 438, 201)];
        _passiveHostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _passiveHostingView;
}

- (CPTGraphHostingView*)_capitalHostingView {
    if (!_capitalHostingView) {
        _capitalHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(46, 526, 438, 201)];
        _capitalHostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _capitalHostingView;
}

- (CPTGraphHostingView*)_activeHostingView2 {
    if (!_activeHostingView2) {
        _activeHostingView2 = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(533, 526, 438, 201)];
        _activeHostingView2.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _activeHostingView2;
}

- (NSInteger)graphIndex:(CPTGraphHostingView*)hostingView {
    if (hostingView == _activeHostingView) {
        return 0;
    } else if (hostingView == _passiveHostingView) {
        return 1;
    } else if (hostingView == _capitalHostingView) {
        return 2;
    } else if (hostingView == _activeHostingView2) {
        return 3;
    }
    return 0;
}


- (double)_getMaxForHostingView:(CPTGraphHostingView*)hostingView {
    double ret = INT_MIN;
    MiscBlock *block = [_barData objectAtIndex:[self graphIndex:hostingView]];
    NSArray *elements = block.elements;
    if (hostingView == _activeHostingView || hostingView == _capitalHostingView) {
        for (NSInteger i = 0; i < elements.count; i += 2) {
            MiscElem *e1 = [elements objectAtIndex:i];
            MiscElem *e2 = [elements objectAtIndex:i + 1];
            double sum = e1.value + e2.value ;
            if (sum > ret)
                ret = sum;
        }
    } else {
        for (NSInteger i = 0; i < elements.count; i++) {
            MiscElem *e1 = [elements objectAtIndex:i];
            double sum = e1.value;
            if (sum > ret)
                ret = sum;
        }
    }
    
    return ret * 1.2;
}

- (void)changeView {
    CardViewController *cv = [CardViewController new];
    [self.navigationController setViewControllers:@[cv] animated:NO];
}

- (void)_setupGraphs {
    NSArray *graphs = @[self._activeHostingView, self._passiveHostingView, self._capitalHostingView, self._activeHostingView2];
    for (CPTGraphHostingView *hostingView in graphs) {
        CPTXYGraph *barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
        hostingView.hostedGraph = barChart;
        hostingView.hostedGraph.identifier = hostingView.description;
        
        barChart.plotAreaFrame.borderLineStyle = nil;
        barChart.plotAreaFrame.cornerRadius    = 0.0;
        barChart.plotAreaFrame.masksToBorder   = NO;
        if (hostingView == _activeHostingView || hostingView == _capitalHostingView) {
            barChart.plotAreaFrame.paddingLeft   = 30;
            barChart.plotAreaFrame.paddingTop    = 0.0;
            barChart.plotAreaFrame.paddingRight  = 100.0;
            barChart.plotAreaFrame.paddingBottom = 0.0;
        } else {
            barChart.plotAreaFrame.paddingLeft   = 30;
            barChart.plotAreaFrame.paddingTop    = 0.0;
            barChart.plotAreaFrame.paddingRight  = 0.0;
            barChart.plotAreaFrame.paddingBottom = 0.0;
        }
        
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:[self _getMaxForHostingView:hostingView]]];
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:4]];
        
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
        y.majorGridLineStyle = nil;
        y.majorTickLineStyle          = nil;
        y.minorTickLineStyle          = nil;
        y.labelTextStyle = textStyle;
        x.labelTextStyle = textStyle;
        y.orthogonalPosition = [NSNumber numberWithDouble:0];
        y.majorIntervalLength = [NSNumber numberWithDouble:10];
        y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
        
        
        
        NSUInteger labelLocation     = 0;
        NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:3];
        NSArray *texts = @[@"31.12.2014", @"31.03.2015", @"30.04.2015"];
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
        firstPlot.barWidth = [NSNumber numberWithFloat:0.7];
        firstPlot.dataSource = self;
        firstPlot.identifier = @"first";
        [barChart addPlot:firstPlot toPlotSpace:plotSpace];
        
        if (hostingView == _activeHostingView || hostingView == _capitalHostingView) {
            CPTBarPlot *secondPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor grayColor] horizontalBars:NO];
            secondPlot.lineStyle = barLineStyle;
            secondPlot.barBasesVary = YES;
            secondPlot.fill = [CPTFill fillWithColor:[CPTColor grayColor]];
            secondPlot.barWidth = [NSNumber numberWithFloat:0.7];
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
            legend.paddingRight = 30;
            
            
            CPTMutableTextStyle *mySmallerTextStyle = [CPTMutableTextStyle new];
            mySmallerTextStyle.lineBreakMode = NSLineBreakByWordWrapping;
            mySmallerTextStyle.fontSize = 12.0f;
            mySmallerTextStyle.color = [CPTColor blackColor];
            legend.textStyle = mySmallerTextStyle;
            //legend.delegate = self;
            barChart.legend = legend;
            barChart.legendAnchor = CPTRectAnchorRight;
            
        }
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        [anim setDuration:0.6f];
        
        anim.toValue = [NSNumber numberWithFloat:1.0f];
        anim.fromValue = [NSNumber numberWithFloat:0.0f];
        anim.removedOnCompletion = NO;
        anim.delegate = self;
        anim.fillMode = kCAFillModeForwards;
        
        hostingView.hostedGraph.position = CGPointMake(0, 0);
        hostingView.hostedGraph.anchorPoint = CGPointMake(0.0, 0.0);
        
        [hostingView.hostedGraph addAnimation:anim forKey:@"grow"];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [self _setupGraphs];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *fixLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 300, 30)];
    fixLabel.textColor = [UIColor lightGrayColor];
    fixLabel.font = [UIFont boldSystemFontOfSize:12];
    fixLabel.text = @"МОБИЛЬНОЕ ПРИЛОЖЕНИЕ ДЛЯ";
    fixLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fixLabel];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SW_bank_screen4_2"]];
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customBtn.frame = CGRectMake(46, 109, 73, 59);
    [customBtn addTarget:self action:@selector(changeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customBtn];
    [self.view addSubview:self._activeHostingView];
    [self.view addSubview:self._passiveHostingView];
    [self.view addSubview:self._capitalHostingView];
    [self.view addSubview:self._activeHostingView2];
    
    MenuView *mView = [[MenuView alloc] initWithFrame:CGRectMake(580-91-45, 0, 1024 - 580 + 91 + 45, 73) andNavigationController:self.navigationController];
    mView.activeIndex = 3;
    [self.view addSubview:mView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        if ([plot.identifier isEqual:@"legend"]) {
            CPTGraphHostingView *hostingView = plot.graph.hostingView;
            if (hostingView == _activeHostingView  || hostingView == _capitalHostingView)
                return 2;
            return 1;
        }
        return 3;
    }
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    if ( [plot isKindOfClass:[CPTScatterPlot class]] ) {
    } else {
        if (fieldEnum == CPTBarPlotFieldBarLocation) {
            return [NSNumber numberWithUnsignedInteger:index + 1];
        } else  {
            if ([plot.identifier isEqual:@"legend"])
                return [NSNumber numberWithInt:0];
            CPTGraphHostingView *hostingView = plot.graph.hostingView;
            if (hostingView == _activeHostingView || hostingView == _capitalHostingView) {
                MiscBlock *mb = [_barData objectAtIndex:[self graphIndex:plot.graph.hostingView]];
                MiscElem *me2 = [mb.elements objectAtIndex:index * 2 + 1];
                MiscElem *me1 = [mb.elements objectAtIndex:index * 2 + 0];
                double offset = 0;
                if (((CPTBarPlot *)plot).barBasesVary) {
                    if ([plot.identifier isEqual:@"second"])
                        offset = me1.value;
                }
                
                if (fieldEnum == CPTBarPlotFieldBarTip) {
                    if ([plot.identifier isEqual:@"second"])
                        return [NSNumber numberWithDouble:offset + me2.value];
                    return [NSNumber numberWithDouble:me1.value];
                }
                else {
                    return [NSNumber numberWithDouble:offset];
                }
            } else {
                MiscBlock *mb = [_barData objectAtIndex:[self graphIndex:plot.graph.hostingView]];
                MiscElem *me1 = [mb.elements objectAtIndex:index];
                
                if (fieldEnum == CPTBarPlotFieldBarTip) {
                    return [NSNumber numberWithDouble:me1.value];
                }
                else {
                    return [NSNumber numberWithDouble:0];
                }
            }
        }
    }
    return num;
}

- (CPTFill*)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx {
    if ([barPlot.identifier isEqual:@"legend"]) {
        MiscBlock *mb = [_barData objectAtIndex:[self graphIndex:barPlot.graph.hostingView]];
        MiscElem *me = [mb.elements objectAtIndex:idx];
        return [CPTFill fillWithColor:me.cptColor];
    }
    if ([barPlot.identifier isEqual:@"first"]) {
        MiscBlock *mb = [_barData objectAtIndex:[self graphIndex:barPlot.graph.hostingView]];
        MiscElem *me = [mb.elements objectAtIndex:0];
        return [CPTFill fillWithColor:me.cptColor];
    }
    if ([barPlot.identifier isEqual:@"second"]) {
        MiscBlock *mb = [_barData objectAtIndex:[self graphIndex:barPlot.graph.hostingView]];
        MiscElem *me = [mb.elements objectAtIndex:1];
        return [CPTFill fillWithColor:me.cptColor];
    }
    return [CPTFill fillWithColor:[CPTColor grayColor]];
}


-(NSString *)legendTitleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx {
    MiscBlock *block = [_barData objectAtIndex:[self graphIndex:barPlot.graph.hostingView]];
    MiscElem *elem = [block.elements objectAtIndex:idx];
    return elem.title;
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
