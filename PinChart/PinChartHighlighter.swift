//
//  PinChartHighlighter.swift
//  ChartsSample
//
//  Created by Wayne Yeh on 2017/2/6.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import Charts

private extension CGFloat {
    var squared: CGFloat {
        get{
            return pow(self, 2)
        }
    }
}

public class PinChartHighlighter : ChartHighlighter
{
    override public func getHighlight(xValue xVal: Double, x: CGFloat, y: CGFloat) -> Highlight?
    {
        guard
            let chart = chart as? LineChartView,
            let datas = chart.data?.dataSets as? [LineChartDataSet]
            else { return nil }
        
        let closestValues = getHighlights(xValue: xVal, x: x, y: y)
        if closestValues.isEmpty
        {
            return nil
        }
        
        var detail: Highlight?
        var min = CGFloat.greatestFiniteMagnitude
        var circleRadius: CGFloat = 0
        
        for closestValue in closestValues {
            let dataSet = datas[closestValue.dataSetIndex]
            if dataSet.entryForXValue(closestValue.x, closestToY: closestValue.y)?.data == nil {
                continue
            }
            let radius = dataSet.circleRadius
            let distance = (x - closestValue.xPx).squared + (y + radius - closestValue.yPx).squared
            if distance < min  {
                detail = closestValue
                min = distance
                circleRadius = radius
            }
        }
        
        if min > circleRadius.squared {
            return nil
        }
        
        return detail
    }
}
