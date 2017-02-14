//
//  PinChartHighlighter.swift
//  ChartsSample
//
//  Created by Wayne Yeh on 2017/2/6.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import Charts

public class PinChartHighlighter : ChartHighlighter
{
    override public func getHighlight(x: CGFloat, y: CGFloat) -> Highlight?
    {
        guard
            let chart = chart as? LineChartView,
            let datas = chart.data?.dataSets as? [LineChartDataSet]
            else { return nil }
        
        for i in 0..<datas.count {
            
            let dataSet = datas[i]
            let radius = dataSet.circleRadius
            let from = chart.getTransformer(forAxis: dataSet.axisDependency).valueForTouchPoint(x: x-radius, y: y)
            let to = chart.getTransformer(forAxis: dataSet.axisDependency).valueForTouchPoint(x: x+radius, y: y+radius*2)
            let fromX = Double(from.x)
            let fromY = Double(from.y)
            let toX = Double(to.x)
            let toY = Double(to.y)
            
            let entries = dataSet.values.filter({ (entry) -> Bool in
                return entry.x > fromX && entry.x < toX && entry.y < fromY && entry.y > toY
            })
            
            if let e = entries.last {
                if e.data != nil {
                    let px = chart.getTransformer(forAxis: dataSet.axisDependency).pixelForValues(x: e.x, y: e.y)
                    return Highlight(x: e.x, y: e.y, xPx: px.x, yPx: px.y, dataSetIndex: i, axis: dataSet.axisDependency)
                }
            }
        }
        
        return nil
    }
}
