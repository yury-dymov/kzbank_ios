//
//  ViewController.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/16/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "ViewController.h"
#import "Indication.h"
#import <CorePlot-CocoaTouch.h>
#import "Cache.h"
#import "CurrencyExchange.h"
#import "Commodity.h"
#import "MenuView.h"

enum {
    MODE_DAILY = 0,
    MODE_ANNUAL
};

@interface ViewController () {
    NSInteger _mode;
    NSInteger _selectedStock;
    NSInteger _selectedBlock;
}

@property (nonatomic, strong) UTGTableView *_contentView;
@property (nonatomic, strong) NSArray *_data;
@property (nonatomic, strong) NSArray *_plotData;
@property (nonatomic, strong) CPTGraphHostingView *_hostingView;
@property (nonatomic, strong) UIButton *_dailyButton;
@property (nonatomic, strong) UIButton *_annualyButton;
@property (nonatomic, strong) UIView *_scatterView;
@property (nonatomic, strong) UIImageView *_zapl;
@property (nonatomic, strong) NSArray *_buttonArray;

@end

@implementation ViewController
@synthesize _contentView;
@synthesize _data;
@synthesize _hostingView;
@synthesize _plotData;
@synthesize _annualyButton;
@synthesize _dailyButton;
@synthesize _scatterView;
@synthesize _zapl;
@synthesize _buttonArray;

- (UIView*)_scatterView {
    if (!_scatterView) {
        self._scatterView = [[UIView alloc] initWithFrame:_hostingView.frame];
        self._scatterView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _scatterView;
}

- (double)_getMin {
    double ret = INT_MAX;
    for (Indication *eio in _plotData) {
        if (eio.currentValue < ret)
            ret = eio.currentValue;
    }
    return ret;
}

- (double)_getMax {
    double ret = INT_MIN;
    for (Indication *eio in _plotData) {
        if (eio.currentValue > ret)
            ret = eio.currentValue;
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
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:1] length:[NSNumber numberWithFloat:29]];
    
    CPTMutableLineStyle *style = [CPTMutableLineStyle lineStyle];
    style.lineColor = [CPTColor lightGrayColor];
    CPTMutableLineStyle *boldStyle = [CPTMutableLineStyle lineStyle];
    boldStyle.lineColor = [CPTColor blackColor];
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle new];
    textStyle.color = [CPTColor grayColor];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = boldStyle;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength         = [NSNumber numberWithFloat:1];
    x.labelTextStyle = textStyle;
    x.orthogonalPosition = [NSNumber numberWithDouble:min];
    //    x.title                       = @"X Axis";
    //    x.titleLocation               = CPTDecimalFromFloat(7.5f);
    //    x.titleOffset                 = 55.0;
    
    
    //    x.labelRotation  = M_PI_4;
    
    NSNumberFormatter *xLabelFormatter = [[NSNumberFormatter alloc] init];
    [xLabelFormatter setGeneratesDecimalNumbers:NO];
    x.labelFormatter = xLabelFormatter;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = nil;
    y.majorGridLineStyle = style;
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.labelTextStyle = textStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    NSNumberFormatter *yLabelFormatter = [[NSNumberFormatter alloc] init];
    [yLabelFormatter setGeneratesDecimalNumbers:YES];
    [yLabelFormatter setMaximumFractionDigits:3];
    y.labelFormatter = yLabelFormatter;

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
        _hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(46, 662, 1024 - 94, 768 - 662 - 10)];
        _hostingView.backgroundColor = [UIColor colorWithRed:223.0/255 green:230.0/255 blue:225.0/255 alpha:1];
    }
    return _hostingView;
}

- (void)changeMode:(UIButton*)sender {
    if (!sender.selected) {
        if (sender == _dailyButton) {
            _annualyButton.selected = NO;
            _dailyButton.selected = YES;
            _mode = MODE_DAILY;
        } else {
            _annualyButton.selected = YES;
            _dailyButton.selected = NO;
            _mode = MODE_ANNUAL;
        }
        [_contentView reloadData];
        [_contentView.aTableView.delegate tableView:_contentView.aTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedStock inSection:0]];
        
    }
}

- (void)modeChanged:(UIButton*)sender {
    if (sender.tag != _selectedBlock) {
        _selectedBlock = sender.tag;
        for (UIButton *btn in _buttonArray) {
            if (btn.tag == 0) {
                btn.hidden = (sender.tag == 0);
            }
            btn.selected = NO;
        }
        sender.selected = YES;
        if (_selectedBlock == 0) {
            _data = [Indication findAllDistinct];
        } else if (_selectedBlock == 1) {
            _data = [CurrencyExchange calculateData];
        } else if (_selectedBlock == 2) {
            _data = [Commodity calculateData];
        }
        [_contentView reloadData];
        _zapl.hidden = (_selectedBlock == 0);
        if (_data.count) {
            _selectedStock = -1;
            [_contentView.delegate UTGTableView:_contentView selectedIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] selectedColumnIndex:0];
            [_contentView.aTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"index"]];
    _contentView = [[UTGTableView alloc] initWithFrame:CGRectMake(46, 214, 1024 - 94, 345) andHeaderHeight:60];
    _contentView.delegate = self;
    [self.view addSubview:_contentView];
    [self.view addSubview:self._hostingView];
    
    if ([Indication findAllDistinct].count) {
        [_contentView.aTableView.delegate tableView:_contentView.aTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    self._dailyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dailyButton.frame = CGRectMake(70 - 11, 581 - 11, 43, 43);
    [_dailyButton setImage:[UIImage imageNamed:@"radion_deselected"] forState:UIControlStateNormal];
    [_dailyButton setImage:[UIImage imageNamed:@"radion_selected"] forState:UIControlStateSelected];
    [self.view addSubview:_dailyButton];
    _dailyButton.selected = YES;
    [_dailyButton addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];

    self._annualyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _annualyButton.frame = CGRectMake(338 - 11, 581 - 11, 43, 43);
    [_annualyButton setImage:[UIImage imageNamed:@"radion_deselected"] forState:UIControlStateNormal];
    [_annualyButton setImage:[UIImage imageNamed:@"radion_selected"] forState:UIControlStateSelected];
    [self.view addSubview:_annualyButton];
    [_annualyButton addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
    
    MenuView *mView = [[MenuView alloc] initWithFrame:CGRectMake(580-91-45, 0, 1024 - 580 + 91 + 45, 73) andNavigationController:self.navigationController];
    mView.activeIndex = 0;
    [self.view addSubview:mView];
        
    [self.view addSubview:self._scatterView];
    
    self._zapl = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zapl"]];
    self._zapl.frame = CGRectMake(0, 562, self._zapl.frame.size.width, self._zapl.frame.size.height);
    [self.view addSubview:self._zapl];
    self._zapl.hidden = YES;
    
    UIButton *businessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    businessButton.tag = 0;
    businessButton.frame = CGRectMake(46, 138.5, 72, 60);
    [businessButton setImage:[UIImage imageNamed:@"business"] forState:UIControlStateNormal];
    businessButton.selected = YES;
    businessButton.hidden = YES;
    [businessButton addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:businessButton];
    
    UIButton *cexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cexButton.tag = 1;
    cexButton.frame = CGRectMake(355, 138.5, 72, 60);
    [cexButton setImage:[UIImage imageNamed:@"cex_active"] forState:UIControlStateSelected];
    [cexButton addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cexButton];

    UIButton *marketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    marketButton.tag = 2;
    marketButton.frame = CGRectMake(660, 138.5, 72, 60);
    [marketButton setImage:[UIImage imageNamed:@"market_active"] forState:UIControlStateSelected];
    [marketButton addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:marketButton];

    _buttonArray = @[businessButton, cexButton, marketButton];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(442, 157, 200, 21)];
    lbl.textColor = [UIColor darkGrayColor];
    lbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lbl];
    lbl.text = @"Курсы валют";
    
}

- (UIColor*)selectedBackgroundColorInUTGTableView:(UTGTableView *)utgTableView {
    return [UIColor colorWithRed:42.0/255 green:156.0/255 blue:109.0/255 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInUTGTableView:(UTGTableView *)anUtgTableView {
    return 1;
}

- (NSInteger)numberOfRowsInUTGTableView:(UTGTableView *)anUtgTableView atSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)widthForUTGTableView:(UTGTableView *)anUtgTableView atIndexPath:(NSIndexPath *)indexPath andColumn:(NSInteger)columnIndex {
    switch (columnIndex) {
        case 0:
            return 1024 - 94 - 600;
        default:
            return 150;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _selectedStock = -1;
    _data = [Indication findAllDistinct];
}

- (void)UTGTableView:(UTGTableView *)utgTableView selectedIndexPath:(NSIndexPath *)indexPath selectedColumnIndex:(NSInteger)columnIndex {
    if (_selectedStock != indexPath.row) {
        _selectedStock = indexPath.row;
        self._plotData = [[self._data objectAtIndex:_selectedStock] last30];
        [self setupGraph];
        [_hostingView.hostedGraph reloadData];
        _scatterView.frame = CGRectMake(46, 662, 1024 - 94, 768 - 662 - 10);
        [_scatterView.layer removeAllAnimations];
        [UIView animateWithDuration:1.5 animations:^{
            _scatterView.frame = CGRectMake(_scatterView.frame.origin.x + _scatterView.frame.size.width, _scatterView.frame.origin.y, 0, _scatterView.frame.size.height);
        }];
    }
}


- (NSInteger)numberOfColumnsInUTGTableView:(UTGTableView *)anUtgTableView atIndexPath:(NSIndexPath *)indexPath {
    return 5;
}

- (UIView*)headerViewForUTGTableView:(UTGTableView *)anUtgTableView atIndex:(NSInteger)index {
    if (index == 0) {
        UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] andColumn:0], 60)];
        ret.backgroundColor = [UIColor colorWithRed:224.0/255 green:232.0/255 blue:226.0/255 alpha:1];
        return ret;
    } else if (index == 1) {
        UILabel *ret = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] andColumn:index], 60)];
        ret.text = @"Текущее значение";
        ret.textAlignment = NSTextAlignmentRight;
        ret.numberOfLines = 0;
        ret.font = [UIFont systemFontOfSize:15];
        ret.backgroundColor = [UIColor colorWithRed:224.0/255 green:232.0/255 blue:226.0/255 alpha:1];
        return ret;
    } else if (index == 2) {
        UILabel *ret = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] andColumn:index], 60)];
        ret.text = @"Изменение";
        ret.numberOfLines = 0;
        ret.font = [UIFont systemFontOfSize:15];
        ret.textAlignment = NSTextAlignmentRight;
        ret.backgroundColor = [UIColor colorWithRed:224.0/255 green:232.0/255 blue:226.0/255 alpha:1];
        return ret;
        
    } else if (index == 3) {
        UILabel *ret = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] andColumn:index], 60)];
        ret.text = @"Минимальное значение";
        ret.numberOfLines = 0;
        ret.font = [UIFont systemFontOfSize:15];
        ret.textAlignment = NSTextAlignmentRight;
        ret.backgroundColor = [UIColor colorWithRed:224.0/255 green:232.0/255 blue:226.0/255 alpha:1];
        return ret;
        
    } else if (index == 4) {
        UILabel *ret = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self widthForUTGTableView:anUtgTableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] andColumn:index], 60)];
        ret.text = @"Максимальное значение";
        ret.numberOfLines = 0;
        ret.font = [UIFont systemFontOfSize:15];
        ret.textAlignment = NSTextAlignmentRight;
        ret.backgroundColor = [UIColor colorWithRed:224.0/255 green:232.0/255 blue:226.0/255 alpha:1];        
        return ret;
        
    }
    return [UIView new];
}

- (UIView*)valueForUTGTableView:(UTGTableView *)anUtgTableView atIndexPath:(NSIndexPath *)indexPath andColumn:(NSInteger)columnIndex {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, [self widthForUTGTableView:anUtgTableView atIndexPath:indexPath andColumn:columnIndex] - 30, 30)];
    lbl.textAlignment = NSTextAlignmentRight;

    NSMutableDictionary *data = [NSMutableDictionary new];
    if (_selectedBlock == 0) {
        Indication *indication = [_data objectAtIndex:indexPath.row];
        [data setValue:indication.exchange.title forKey:@"title"];
        [data setValue:[NSNumber numberWithDouble:indication.currentValue] forKey:@"value"];
        if (_mode == MODE_DAILY) {
            [data setValue:indication.change forKey:@"change"];
            [data setValue:[NSNumber numberWithDouble:indication.minValue] forKey:@"min"];
            [data setValue:[NSNumber numberWithDouble:indication.minValue] forKey:@"max"];
        } else {
            [data setValue:indication.annualChange forKey:@"change"];
            [data setValue:[NSNumber numberWithDouble:indication.annualMinValue] forKey:@"min"];
            [data setValue:[NSNumber numberWithDouble:indication.annualMaxValue] forKey:@"max"];
        }
    } else if (_selectedBlock == 1) {
        CurrencyExchange *indication = [_data objectAtIndex:indexPath.row];
        [data setValue:indication.title forKey:@"title"];
        [data setValue:[NSNumber numberWithDouble:indication.value] forKey:@"value"];
        [data setValue:indication.change forKey:@"change"];
        [data setValue:[NSNumber numberWithDouble:indication.min] forKey:@"min"];
        [data setValue:[NSNumber numberWithDouble:indication.max] forKey:@"max"];
    } else {
        Commodity *indication = [_data objectAtIndex:indexPath.row];
        [data setValue:indication.title forKey:@"title"];
        [data setValue:[NSNumber numberWithDouble:indication.value] forKey:@"value"];
        [data setValue:indication.change forKey:@"change"];
        [data setValue:[NSNumber numberWithDouble:indication.min] forKey:@"min"];
        [data setValue:[NSNumber numberWithDouble:indication.max] forKey:@"max"];
        
    }
    switch (columnIndex) {
        case 0:
            lbl.textAlignment = NSTextAlignmentLeft;
            lbl.font = [UIFont systemFontOfSize:15];
            lbl.text = [NSString stringWithFormat:@"    %@", [data valueForKey:@"title"]];
            break;
        case 1:
            lbl.text = [NSString stringWithFormat:@"%0.2f", [[data valueForKey:@"value"] doubleValue]];
            break;
        case 2:
            lbl.text = [data valueForKey:@"change"];
            if ([lbl.text characterAtIndex:0] == '-') {
                lbl.textColor = [UIColor redColor];
            } else {
                lbl.textColor = [UIColor colorWithRed:44.0/255 green:95.0/255 blue:58.0/255 alpha:1];
            }
            break;
        case 3:
            lbl.text = [NSString stringWithFormat:@"%0.2f", [[data valueForKey:@"min"] doubleValue]];
            break;
        case 4:
            lbl.text = [NSString stringWithFormat:@"%0.2f", [[data valueForKey:@"max"] doubleValue]];
            break;
        default:
            break;
    }
    return lbl;
}

- (CGFloat)heightForUTGTableView:(UTGTableView *)utgTableView {
    return 40;
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _plotData.count;
}

-(id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if (fieldEnum == CPTScatterPlotFieldX)
        return [NSNumber numberWithUnsignedLong:index + 1];
    return [NSNumber numberWithDouble:[[_plotData objectAtIndex:index] currentValue]];
}

@end
