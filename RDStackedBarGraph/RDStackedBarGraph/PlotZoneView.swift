//
//  PlotZoneView.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import UIKit

class PlotZoneView: UIView {
    var barSpacing = 20
    var leftPadding = CGFloat(40)
    var rightPadding = CGFloat(40)
    var maxBarValue: CGFloat!
    var bars: [Bar]!
    var barCornerRadius: CGFloat = 0
    
    required convenience init(frame: CGRect, bars: [Bar], maxBarValue: CGFloat) {
        self.init(frame:frame)
        self.bars = bars
        self.maxBarValue = maxBarValue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let bars = bars {
            
            //TODO: Should do this reduce more efficiently
            let totalWidth = bars.reduce(0) {
                return $0 + $1.width
            }
            var xPosition = leftPadding
            let height = bounds.size.height
            //TODO: Need to enforce a minimum padding by shrinking the bar width if it goes over
            let padding = (bounds.size.width - leftPadding - rightPadding - totalWidth) / CGFloat(bars.count - 1 > 0 ? bars.count - 1 : 1)
            
            var xAxisLabels = [XAxisLabel]()
            for bar in bars {
                let barHeight = bar.totalValue() / maxBarValue * height
                let stackedBar = StackedBar(frame: CGRect(x: xPosition, y: height - barHeight, width: bar.width, height: barHeight), segments: bar.segments)
                stackedBar.cornerRadius = barCornerRadius
                addSubview(stackedBar)
                xPosition += padding + bar.width
            }
        }
    }
}