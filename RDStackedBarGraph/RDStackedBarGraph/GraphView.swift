//
//  Graph.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import UIKit

@objc public protocol GraphDatasourceProtocol: class {
    func numberOfBarsInGraphView(graphView: GraphView) -> Int
    func graphView(graphView: GraphView, numberOfSegmentsInBarAtIndex atIndex: Int) -> Int
    func graphView(graphView: GraphView, valueForSegmentAtIndex segmentIndex: Int, inBarWithIndex barIndex: Int) -> CGFloat
    func graphView(graphView: GraphView, colorForSegmentAtIndex segmentIndex: Int, inBarWithIndex barIndex: Int) -> UIColor
    optional func graphView(graphView: GraphView, labelForBarAtIndex barIndex: Int) -> String
}

public enum StackedBarAlignment {
    case Left, Center, Right
}

public class GraphView: UIScrollView {
    
    public var barWidth = CGFloat(60)
    public var barSpacing = 20
    public var leftPadding = CGFloat(0)
    public var rightPadding = CGFloat(0)
    public var xAxisTopMargin = CGFloat(0)
    public var xAxisTopPadding = CGFloat(0)
    
    public var maxVisibleBars = 7
    
    // Customizations
    public var xAxisLabelFont = UIFont.systemFontOfSize(12)
    public var xAxisLabelColor = UIColor.blackColor()
    public let xAxisView = XAxisView()
    public var barCornerRadius: CGFloat = 10
    private var initialLaunchComplete = false
    private var barsAndLabels : (bars: [Bar], xAxisLabels: [XAxisLabel], maxBarValue: CGFloat)!
    
    public var stackedBarAlignment : StackedBarAlignment {
        get {
            return plotZone.stackedBarAlignment ?? PlotZoneView.DefaultStackedBarAlignment
        } set {
            plotZone.stackedBarAlignment = newValue
        }
    }
    
    public weak var datasource: GraphDatasourceProtocol? {
        didSet {
            guard let datasource = datasource else { return }
            //TODO: totalBars needs to move
            let totalBars = datasource.numberOfBarsInGraphView(self)
            barsAndLabels = barsAndLabelsForBarCount(totalBars)
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    private var plotZone = PlotZoneView()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard let datasource = datasource else { return }
        
        
        /*
        Collect data from the datasource and populate a local model to pass around
        */
        let totalBars = datasource.numberOfBarsInGraphView(self)
        
        //        var bars = [Bar]()
        
        let visibleBars = min(totalBars, maxVisibleBars)
        
        let totalWidth = barWidth * CGFloat(visibleBars)
        
        
        let padding = (bounds.size.width - leftPadding - rightPadding - totalWidth) / CGFloat(visibleBars + 1)
        
        
        var initialOffset : CGFloat = 0
        if !initialLaunchComplete {
            
            let cumumlativeWidth = barWidth * CGFloat(totalBars) + CGFloat(padding * CGFloat(totalBars - 1)) + leftPadding + barWidth
            
            var size = bounds.size
            size.width = cumumlativeWidth
            contentSize = size
            initialLaunchComplete = true
            self.showsHorizontalScrollIndicator = true

            initialOffset = cumumlativeWidth - bounds.width
            contentOffset.x = initialOffset
//            plotZone.initialOffset = contentOffset.x
        }

        let bars = barsAndLabels.bars
        let xAxisLabels = barsAndLabels.xAxisLabels
        let maxBarValue = barsAndLabels.maxBarValue
        
        setupXAxisWithAxisLabel(xAxisLabels)
        let xAxisHeight = xAxisView.bounds.size.height
        let plotZoneFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - xAxisHeight - xAxisTopMargin)
        setupPlotZoneWithBars(bars, frame: plotZoneFrame, maxBarValue: maxBarValue)
        
    }
    
    private func barsAndLabelsForBarCount(barCount: Int) -> (bars: [Bar], xAxisLabels: [XAxisLabel], maxBarValue: CGFloat) {
        guard let datasource = datasource else { return (bars: [Bar](), xAxisLabels: [XAxisLabel](), maxBarValue:  0) }
        var maxBarValue = CGFloat(0)
        let visibleBars = min(barCount, maxVisibleBars)
        let totalWidth = barWidth * CGFloat(visibleBars)
        let padding = (bounds.size.width - leftPadding - rightPadding - totalWidth) / CGFloat(visibleBars + 1)
        var xPosition = leftPadding + padding + barWidth / 2
        //TODO: Come back here to account for initial offset
    
        var xAxisLabels = [XAxisLabel]()
        
        var bars = [Bar]()
        for barIndex in 0..<barCount {
            let totalSegments = datasource.graphView(self, numberOfSegmentsInBarAtIndex: barIndex)
            var barTotalValue = CGFloat(0)
            var segments = [BarSegment]()
            
            //Gather the segments that make up the bar
            for segmentIndex in 0..<totalSegments {
                let value = datasource.graphView(self, valueForSegmentAtIndex: segmentIndex, inBarWithIndex: barIndex)
                barTotalValue += value
                let color = datasource.graphView(self, colorForSegmentAtIndex: segmentIndex, inBarWithIndex: barIndex)
                let segment = BarSegment(color: color, value: value)
                segments.append(segment)
            }
            
            let bar = Bar(segments: segments, width: barWidth, xAxisPosition: xPosition)
            bars.append(bar)
            
            if let barLabel = datasource.graphView?(self, labelForBarAtIndex: barIndex) {
                let axisLabel = XAxisLabel(text: barLabel, xPosition: xPosition)
                xAxisLabels.append(axisLabel)
            }
            
            maxBarValue = max(maxBarValue, barTotalValue)
            xPosition += padding + barWidth
        }
        
        return (bars: bars, xAxisLabels: xAxisLabels, maxBarValue: maxBarValue)
    }
    
    func setupXAxisWithAxisLabel(axisLabels: [XAxisLabel]) {
        xAxisView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: CGFloat.max)

        xAxisView.axisLabels = axisLabels
        xAxisView.font = xAxisLabelFont
        xAxisView.textColor = xAxisLabelColor
        xAxisView.offset = contentOffset.x
        xAxisView.sizeToFit()
        
        
        let xAxisHeight = xAxisView.bounds.size.height + xAxisTopPadding

        var newXAxisFrame = CGRect(x: 0, y: bounds.size.height - xAxisHeight, width: bounds.size.width, height: xAxisHeight)
        newXAxisFrame.origin.x = contentOffset.x
        xAxisView.frame = newXAxisFrame
        if xAxisView.superview == nil {
            addSubview(xAxisView)
        }
    }
    
    func setupPlotZoneWithBars(bars: [Bar], frame: CGRect, maxBarValue: CGFloat) {
        
        var newFrame = frame
        newFrame.origin.x = contentOffset.x
        
        plotZone.frame = newFrame
        plotZone.bars = bars
        plotZone.maxBarValue = maxBarValue
        plotZone.barCornerRadius = barCornerRadius
        plotZone.offset = contentOffset.x
        
        if plotZone.superview == nil {
            addSubview(plotZone)
        }
        plotZone.setNeedsDisplay()
        
    }
    
}

extension GraphView {
    var xAxisFont: UIFont {
        get {
            return xAxisView.font
        } set {
            xAxisView.font = newValue
        }
    }
    
    var xAxisTextColor: UIColor {
        get {
            return xAxisView.textColor
        } set {
            xAxisView.textColor = newValue
        }
    }
    
}





