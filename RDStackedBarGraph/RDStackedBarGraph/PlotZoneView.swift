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
    
    private var barToBarViews = [Bar: StackedBarView]()
    private var stackedBarViewQueue = [StackedBarView]()
    
    
    required convenience init(frame: CGRect, bars: [Bar], maxBarValue: CGFloat) {
        self.init(frame:frame)
        self.bars = bars
        self.maxBarValue = maxBarValue
    }
    
    override func layoutSubviews() {
        clipsToBounds = true
        super.layoutSubviews()
        guard let bars = bars else { return }
//        subviews.forEach({ $0.removeFromSuperview() })
        
        let height = bounds.size.height
        
        //TODO: Does abs here make sense
        //TODO: May need to allow this negative
        
        
        let currentOffset = initialOffset - offset
//        print("Current offset is \(currentOffset)")
//        print("Initial offset is \(initialOffset)")
//        print("Offset is \(offset)")
        let newVisibleBars = visibleBarsForOffset(currentOffset)
        
        
        
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
            var xPosition = bar.xAxisPosition - (bar.width / 2)
            
            xPosition -= (currentOffset)
            
            let barFrame = CGRect(x: xPosition, y: height - barHeight, width: bar.width, height: barHeight)
            
//            let stackedBarView = StackedBarView(frame: barFrame, segments: bar.segments)
            let stackedBarView: StackedBarView
            if let existingStackedBarView = barToBarViews[bar] {
                stackedBarView = existingStackedBarView
                stackedBarView.frame = barFrame
//                stackedBarView.segments = bar.segments
            } else {
                stackedBarView = dequeueStackedBarWithFrame(barFrame, segments: bar.segments)
                barToBarViews[bar] = stackedBarView
                addSubview(stackedBarView)
            }
//            if stackedBarView.superview == nil {
//                addSubview(stackedBarView)
//            }
            
            stackedBarView.cornerRadius = barCornerRadius
        }

    }
    
    private func dequeueStackedBarWithFrame(frame: CGRect, segments: [BarSegment]) -> StackedBarView {
        // This should probably sync?
        
        let stackedBarView : StackedBarView
        if stackedBarViewQueue.count > 0 {
            stackedBarView = stackedBarViewQueue.removeFirst()
        } else {
            stackedBarView = StackedBarView()
        }
        
        stackedBarView.frame = frame
        stackedBarView.segments = segments
        return stackedBarView
        
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
    
        
        let newBars = bars.filter {
            return $0.xAxisPosition > minVisibleXAxisPosition && $0.xAxisPosition < maxVisibleXAxisPosition
        }
        
        
//        let newBars = bars[bars.count - 7..<bars.count]
        return Array(newBars)
    }
}