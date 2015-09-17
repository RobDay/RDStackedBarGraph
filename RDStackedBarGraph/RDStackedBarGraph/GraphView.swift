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

public class GraphView: UIView {
    
    public var barWidth = CGFloat(60)
    public var barSpacing = 20
    public var leftPadding = CGFloat(0)
    public var rightPadding = CGFloat(0)
    public var xAxisTopMargin = CGFloat(0)
    public var xAxisTopPadding = CGFloat(0)
    
    // Customizations
    public var xAxisLabelFont = UIFont.systemFontOfSize(12)
    public var xAxisLabelColor = UIColor.blackColor()
    public let xAxisView = XAxisView()
    public var barCornerRadius: CGFloat = 10
    
    
    public weak var datasource: GraphDatasourceProtocol? {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if let datasource = datasource {

            subviews.forEach({ $0.removeFromSuperview() })

            /*
            Collect data from the datasource and populate a local model to pass around
            */
            let totalBars = datasource.numberOfBarsInGraphView(self)
            var maxBarValue = CGFloat(0)
            var bars = [Bar]()
            
            let totalWidth = barWidth * CGFloat(totalBars)            
            let padding = (bounds.size.width - leftPadding - rightPadding - totalWidth) / CGFloat(totalBars + 1)
            var xPosition = leftPadding + padding + barWidth / 2


            var xAxisLabels = [XAxisLabel]()
            
            
            for barIndex in 0..<totalBars {
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
            
            
            setupXAxisWithAxisLabel(xAxisLabels)
            let xAxisHeight = xAxisView.bounds.size.height
            let plotZoneFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - xAxisHeight - xAxisTopMargin)
            setupPlotZoneWithBars(bars, frame: plotZoneFrame, maxBarValue: maxBarValue)
            
        }
    }
    
    func setupXAxisWithAxisLabel(axisLabels: [XAxisLabel]) {
        xAxisView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: CGFloat.max)
        
        xAxisView.axisLabels = axisLabels
        xAxisView.font = xAxisLabelFont
        xAxisView.textColor = xAxisLabelColor
        
        xAxisView.sizeToFit()
        let xAxisHeight = xAxisView.bounds.size.height + xAxisTopPadding
        
        let newXAxisFrame = CGRect(x: 0, y: bounds.size.height - xAxisHeight, width: bounds.size.width, height: xAxisHeight)
        xAxisView.frame = newXAxisFrame
        addSubview(xAxisView)
    }
    
    func setupPlotZoneWithBars(bars: [Bar], frame: CGRect, maxBarValue: CGFloat) {
        //At this point, we have all the necessary value to build the other components
        let plotZone = PlotZoneView(frame: frame, bars: bars, maxBarValue: maxBarValue)
        plotZone.barCornerRadius = barCornerRadius
        addSubview(plotZone)
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





