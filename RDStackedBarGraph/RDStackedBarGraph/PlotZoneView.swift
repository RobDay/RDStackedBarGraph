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
            let height = bounds.size.height
            
            for bar in bars {
                let barHeight = maxBarValue > 0 ? bar.totalValue() / maxBarValue * height : 0.0
                //TODO: the x position should not be a hacked calculation
                let stackedBar = StackedBarView(frame: CGRect(x: bar.xAxisPosition - (bar.width / 2), y: height - barHeight, width: bar.width, height: barHeight), segments: bar.segments)
                stackedBar.cornerRadius = barCornerRadius
                addSubview(stackedBar)
            }
        }
    }
}