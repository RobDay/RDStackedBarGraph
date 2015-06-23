//
//  PlotZoneView.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import UIKit

class PlotZoneView: UIView {
    var barWidth = CGFloat(60)
    var barSpacing = 20
    var leftPadding = CGFloat(40)
    var rightPadding = CGFloat(40)
    var maxBarValue: CGFloat!
    var bars: [Bar]!
    
    required convenience init(frame: CGRect, bars: [Bar], maxBarValue: CGFloat) {
        self.init(frame:frame)
        self.bars = bars
        self.maxBarValue = maxBarValue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let bars = bars {
            
            let totalWidth = barWidth * CGFloat(bars.count)
            var xPosition = leftPadding
            let height = bounds.size.height
            //TODO: Need to enforce a minimum padding by shrinking the bar width if it goes over
            let padding = (bounds.size.width - leftPadding - rightPadding - totalWidth) / CGFloat(bars.count - 1 > 0 ? bars.count - 1 : 1)
            
            var xAxisLabels = [XAxisLabel]()
            for bar in bars {
                let barHeight = bar.totalValue() / maxBarValue * height
                let stackedBar = StackedBar(frame: CGRect(x: xPosition, y: height - barHeight, width: barWidth, height: barHeight), segments: bar.segments)
                
                addSubview(stackedBar)
                xPosition += padding + barWidth
            }
        }
    }
}