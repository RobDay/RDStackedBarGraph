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

    
    private var barToBarViews = [Bar: StackedBarView]()
    private var stackedBarViewQueue = [StackedBarView]()
    
    
    required convenience init(frame: CGRect, bars: [Bar], maxBarValue: CGFloat) {
        self.init(frame:frame)
        self.bars = bars
        self.maxBarValue = maxBarValue
    }
    
    override func layoutSubviews() {
        guard bars != nil else { return }
        clipsToBounds = true
        super.layoutSubviews()

        
        let height = bounds.size.height
        let newVisibleBars = visibleBars()
        let newVisibleBarsSet = Set(newVisibleBars)
        let existingBars = Set(barToBarViews.keys)
        
        let removedBars = existingBars.subtract(newVisibleBarsSet)
        for bar in removedBars {
            // Get the stackedBarView, removeFromSuperview, add back to queue
            if let stackedBarView = barToBarViews[bar] {
                stackedBarView.removeFromSuperview()
                stackedBarViewQueue.append(stackedBarView)
                barToBarViews.removeValueForKey(bar)
            } else {
                assertionFailure("Should never get here.  Should always have tracked view")
            }
            
        }
        
        
        for bar in newVisibleBars {
            let barHeight = maxBarValue > 0 ? bar.totalValue() / maxBarValue * height : 0.0
            
//            The x axis math below is placing the bar on the right side of the graph
//            This could potentially be a preprocessing step on each bar?
            let xPosition = bar.xAxisPosition - (bar.width / 2)
            
            let barFrame = CGRect(x: xPosition, y: height - barHeight, width: bar.width, height: barHeight)
            
            let stackedBarView: StackedBarView
            if let existingStackedBarView = barToBarViews[bar] {
                stackedBarView = existingStackedBarView
                stackedBarView.frame = barFrame
            } else {
                stackedBarView = dequeueStackedBarWithFrame()
                
                stackedBarView.frame = barFrame
                stackedBarView.segments = bar.segments
                barToBarViews[bar] = stackedBarView
                addSubview(stackedBarView)
            }
        }

    }
    
    
    private func dequeueStackedBarWithFrame() -> StackedBarView {
        // This should probably sync?
        
        let stackedBarView : StackedBarView
        if stackedBarViewQueue.count > 0 {
            stackedBarView = stackedBarViewQueue.removeFirst()
        } else {
            stackedBarView = StackedBarView()
            stackedBarView.cornerRadius = barCornerRadius
            
        }
        return stackedBarView
        
    }
    
    private func visibleBars() -> [Bar] {
        guard bars.count > 0 else { return [Bar]() }
        let barWidth = bars[0].width
        let minVisibleXAxisPosition = 0 - (barWidth / 2)
        
        let maxVisibleXAxisPosition = bounds.size.width + (barWidth / 2)
        let newBars = bars.filter {
            return $0.xAxisPosition > minVisibleXAxisPosition && $0.xAxisPosition < maxVisibleXAxisPosition
        }
        
        
        return Array(newBars)
    }
}