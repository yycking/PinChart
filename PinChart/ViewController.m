//
//  ViewController.m
//  PinChart
//
//  Created by Wayne Yeh on 2017/2/7.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

#import "ViewController.h"
#import "PinChart-Swift.h"

@import Charts;

@interface ViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray<ChartDataEntry*> *yValues = [NSMutableArray array];
    for (double i=0; i<10; i++) {
        double v = arc4random_uniform(100);
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:v];
        if (arc4random_uniform(2) % 2 == 0) {
            entry.data = @"";
        }
        [yValues addObject:entry];
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yValues];
    set.circleRadius = 16;
    
    LineChartData *data = [[LineChartData alloc] initWithDataSet:set];
    
    self.lineChartView.data = data;
    
    self.lineChartView.renderer = [[PinChartRenderer alloc] initWithChartView:self.lineChartView];
    
    self.lineChartView.highlighter = [[PinChartHighlighter alloc] initWithChart:self.lineChartView];
    
    self.lineChartView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    
}

@end
