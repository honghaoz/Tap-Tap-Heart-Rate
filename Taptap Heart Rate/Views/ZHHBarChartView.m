//
//  ZHHBarChartView.m
//  Taptap Heart Rate
//
//  Created by Honghao on 7/30/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "ZHHBarChartView.h"

@protocol ZHHBarChartViewDataSource;
@protocol ZHHBarChartViewDelegate;

@protocol ZHHBarChartViewDataSource <NSObject>
@required

- (float)barChartView:(ZHHBarChartView *)barChartView maxValue:(float)max;
- (NSUInteger)barChartView:(ZHHBarChartView *)barChartView numberOfBars:(NSUInteger)number;

@optional

- (NSString *)barChartView:(ZHHBarChartView *)barChartView barTextForIndex:(NSInteger)index;

@end

@protocol ZHHBarChartViewDelegate <NSObject>
@required

@optional

@end





@implementation ZHHBarChartView

@end
