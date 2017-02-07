//
//  PinChartRenderer.swift
//  ChartsSample
//
//  Created by Wayne Yeh on 2017/2/6.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import Charts

public class PinChartRenderer : LineChartRenderer
{
    convenience init(chartView: LineChartView) {
        self.init(dataProvider: chartView, animator: chartView.chartAnimator, viewPortHandler: chartView.viewPortHandler)
    }
    
    public func drawMark (context: CGContext, rect :CGRect, data: AnyObject?) {
        guard
            let image = UIImage(named: "icon_smart_video"),
            let viewPortHandler = self.viewPortHandler
            else { return }
        
        let pt = CGPoint(x: rect.midX, y: rect.midY)
        // make sure the circles don't do shitty things outside bounds
        if (!viewPortHandler.isInBoundsRight(pt.x) || !viewPortHandler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y))
        {
            return
        }
        
        UIGraphicsPushContext(context)
        image.draw(in: rect)
        UIGraphicsPopContext()
    }
    
    public override func drawExtras(context: CGContext)
    {
        guard
            let dataProvider = dataProvider,
            let lineData = dataProvider.lineData,
            let animator = animator
            else { return }
        
        let phaseY = animator.phaseY
        
        let dataSets = lineData.dataSets
        
        var pt = CGPoint()
        var rect = CGRect()
        
        context.saveGState()
        
        for i in 0 ..< dataSets.count
        {
            guard let dataSet = lineData.getDataSetByIndex(i) as? ILineChartDataSet else { continue }
            
            if !dataSet.isVisible || !dataSet.isDrawCirclesEnabled || dataSet.entryCount == 0
            {
                continue
            }
            
            let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
            let valueToPixelMatrix = trans.valueToPixelMatrix
            
            let circleRadius = dataSet.circleRadius
            let circleDiameter = circleRadius * 2.0
            
            let phaseX = Swift.max(0.0, Swift.min(1.0, animator.phaseX ))
            let entryFrom = dataSet.entryForXValue(dataProvider.lowestVisibleX, closestToY: Double.nan, rounding: .down)
            let entryTo = dataSet.entryForXValue(dataProvider.highestVisibleX, closestToY: Double.nan, rounding: .up)
            
            let min = entryFrom == nil ? 0 : dataSet.entryIndex(entry: entryFrom!)
            let max = entryTo == nil ? 0 : dataSet.entryIndex(entry: entryTo!)
            let range = Int(Double(max - min) * phaseX)
            
            for j in stride(from: min, through: range + min, by: 1)
            {
                guard
                    let e = dataSet.entryForIndex(j),
                    let data = e.data
                    else { continue }
                
                pt.x = CGFloat(e.x)
                pt.y = CGFloat(e.y * phaseY)
                pt = pt.applying(valueToPixelMatrix)
                
                rect.origin.x = pt.x - circleRadius
                rect.origin.y = pt.y - circleDiameter
                rect.size.width = circleDiameter
                rect.size.height = circleDiameter
                
                self.drawMark(context: context, rect: rect, data: data)
            }
        }
        
        context.restoreGState()
    }
}

public class TopPinChartRenderer : PinChartRenderer
{
    public override func drawMark (context: CGContext, rect :CGRect, data: AnyObject?) {
        guard
            let image = data as? UIImage,
            let viewPortHandler = self.viewPortHandler
            else { return }
        
        var rect = rect
        rect.origin.y = viewPortHandler.contentTop
        
        let pt = CGPoint(x: rect.midX, y: rect.midY)
        // make sure the circles don't do shitty things outside bounds
        if (!viewPortHandler.isInBoundsRight(pt.x) || !viewPortHandler.isInBoundsLeft(pt.x))
        {
            return
        }
        
        UIGraphicsPushContext(context)
        image.draw(in: rect)
        UIGraphicsPopContext()
    }
}
