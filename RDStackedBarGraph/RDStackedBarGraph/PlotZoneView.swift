//
//  PlotZoneView.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import UIKit

class PlotZoneView: UIView {
    static let DefaultStackedBarAlignment = StackedBarAlignment.Center
    var barSpacing = 20
    var leftPadding = CGFloat(40)
    var rightPadding = CGFloat(40)
    var maxBarValue: CGFloat!
    
    var maxVisibleBars = 7
    var bars: [Bar]! {
        didSet {
        setNeedsLayout()
        }
    }
    var barCornerRadius: CGFloat = 0
    var stackedBarAlignment = PlotZoneView.DefaultStackedBarAlignment
    
    var initialOffset: CGFloat = 200
    var offset: CGFloat = 0.0 {
        didSet {
            //When the offset is changed, shift the bars that are visible
        }
    }
    
    required convenience init(frame: CGRect, bars: [Bar], maxBarValue: CGFloat) {
        self.init(frame:frame)
        self.bars = bars
        self.maxBarValue = maxBarValue
    }
    
    override func layoutSubviews() {
        clipsToBounds = true
        super.layoutSubviews()
        guard let bars = bars else { return }
        subviews.forEach({ $0.removeFromSuperview() })
        
        let height = bounds.size.height
        
        //TODO: Does abs here make sense
        //TODO: May need to allow this negative
        
        
        let currentOffset = initialOffset - offset
        print("Current offset is \(currentOffset)")
        print("Initial offset is \(initialOffset)")
        print("Offset is \(offset)")
        let currentBars = visibleBarsForOffset(currentOffset)
        for bar in currentBars {
            let barHeight = maxBarValue > 0 ? bar.totalValue() / maxBarValue * height : 0.0
            
            
//            The x axis math below is placing the bar on the right side of the graph
//            This could potentially be a preprocessing step on each bar?
            var xPosition = bar.xAxisPosition - (bar.width / 2)
            
            xPosition -= (currentOffset)
            
            let barFrame = CGRect(x: xPosition, y: height - barHeight, width: bar.width, height: barHeight)
            
            let stackedBarView = StackedBarView(frame: barFrame, segments: bar.segments)
            stackedBarView.cornerRadius = barCornerRadius
            addSubview(stackedBarView)
        }

    }
    
    private func visibleBarsForOffset(currentOffset: CGFloat) -> [Bar] {
        //After this is called, even if the same bars are visible, the bars need to be shifted based on the offset
        //Perhaps this can be implemented by subtracting (or omdifying if that doesn't make sense) all of the x positions by the offset.  Then, whatver is in range of my bounds is drawn
            //IN range of bounds means any part of it visible
        //This should also potentially reuse bars that have fallen off the scrolling area.  This would stop the churn of adding and removing bars over and over again
        
        //That said, we'd need to keep a mapping of bars to barViews
        let barWidth = bars[0].width
        let minVisibleXAxisPosition = 0 + currentOffset - (barWidth / 2)
        
        let maxVisibleXAxisPosition = bounds.size.width + currentOffset + (barWidth / 2)
        
//        var newBars = [Bar]()
        
        let newBars = bars.filter {
            return $0.xAxisPosition > minVisibleXAxisPosition && $0.xAxisPosition < maxVisibleXAxisPosition
        }
        
        
//        let newBars = bars[bars.count - 7..<bars.count]
        return Array(newBars)
    }
}