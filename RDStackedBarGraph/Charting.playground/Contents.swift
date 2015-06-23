//: Playground - noun: a place where people can play

import UIKit
//import RDStackedBarGraph



var str = "Hello, playground"

import Foundation
import UIKit

import RDStackedBarGraph



//
//struct BarSegment {
//    let color: UIColor
//    let value: CGFloat
//    
//}
//
//struct Bar {
////    let borderColor: UIColor?
//    
//    let segments: [BarSegment]
//    let width: CGFloat
//    var label: String?
//    
//    init(segments: [BarSegment], width: CGFloat) {
//        self.segments = segments
//        self.width = width
//    }
//    
//    
//    func totalValue() -> CGFloat {
//        return segments.reduce(0) {
//            return $0 + $1.value
//        }
//    }
//}
//
//struct Graph {
//    let bars: [Bar]
//}
//
//
///*
//# Chart components
//The chart will have a few different zones:
//- Plot zone
//- x-axis
//- y-axix
//
//*/
//
////TODO: Option for rounded
//class StackedBar: UIView {
//    
//    var segments: [BarSegment]!
//    var segmentTotal : CGFloat {
//        return segments.reduce(0) {
//            $0 + $1.value
//        }
//    }
//    
//    convenience init(frame: CGRect, segments: [BarSegment]) {
//        self.init(frame: frame)
//        self.segments = segments
//        layer.cornerRadius = 5.0
//        clipsToBounds = true
//    }
//    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        var runningTotal = CGFloat(0)
//        let total = segmentTotal
////        print("Total is \(total)\n")
//        let barHeight = bounds.size.height
//        let barWidth = bounds.size.width
//        for segment in segments.reverse() {
//            let scaledHeight = segment.value / total * barHeight
////            print("Scaled height: \(scaledHeight)\n")
//            
//            let yPosition = runningTotal
////            print("yPosition: \(yPosition)\n")
//            let path = UIBezierPath(rect: CGRect(x: 0, y: yPosition, width: barWidth, height: scaledHeight))
//            segment.color.setFill()
//            path.fill()
//            
//            runningTotal += scaledHeight
//        }
//    }
//}
//
//
//let testSegments = [
//    BarSegment(color: UIColor.greenColor(), value: 40),
//    BarSegment(color: UIColor.redColor(), value: 20),
//    BarSegment(color: UIColor.orangeColor(), value: 20),
//    BarSegment(color: UIColor.purpleColor(), value: 20)
//]
//
//let myBar = StackedBar(frame: CGRect(x: 0, y: 0, width: 100, height: 300), segments: testSegments)
//
//
//
//@objc protocol GraphDatasourceProtocol: class {
//    func numberOfBarsInGraphView(graphView: GraphView) -> Int
//    func graphView(graphView: GraphView, numberOfSegmentsInBarAtIndex atIndex: Int) -> Int
//    func graphView(graphView: GraphView, valueForSegmentAtIndex segmentIndex: Int, inBarWithIndex barIndex: Int) -> CGFloat
//    func graphView(graphView: GraphView, colorForSegmentAtIndex segmentIndex: Int, inBarWithIndex barIndex: Int) -> UIColor
//    optional func graphView(graphView: GraphView, labelForBarAtIndex barIndex: Int) -> String
//}
//
//
//class GraphView: UIView {
//    
//    var barWidth = CGFloat(60)
//    var barSpacing = 20
//    var leftPadding = CGFloat(40)
//    var rightPadding = CGFloat(40)
//    var xAxisOffset = CGFloat(0)
//    var xAxisTopPadding = CGFloat(0)
//    
//    // Customizations
//    var xAxisLabelFont = UIFont.systemFontOfSize(12)
//    var xAxisLabelColor = UIColor.blackColor()
//    let xAxisView = XAxisView()
//    
//    
//    //TODO: Is it possible to calculate the xAxisLabel positions & bar positions once and pass it around?
//    //      If a bar width is not set, should calculate an optimal bar width / padding size based on the bounds and number of bars
//    //          Should enforce a maximum bar size and if the computed bar size exceeds it, increase the padding
//    //          Similarly, should have a minimum padding size that should cause the bars to shrink
//    
//    
//    weak var datasource: GraphDatasourceProtocol?
//
////    override func layoutSubviews() {
////        super.layoutSubviews()
//    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        
//        
//        //Calculate the xaxis rect
//        //Build the xaxis
//        
//        //Calculate teh yaxis Rect
//        //Build the yaxis
//        
//        //Calculate teh plot zone
//        //Build the plot zone
//        
//        
//        if let datasource = datasource {
//            subviews.map({ $0.removeFromSuperview() })
//            println("Bar width is \(barWidth)")
//            /*
//                Collect data from the datasource and populate a local model to pass around
//            */
//            let totalBars = datasource.numberOfBarsInGraphView(self)
//            var maxBarValue = CGFloat(0)
//            var bars = [Bar]()
//            for barIndex in 0..<totalBars {
//                let totalSegments = datasource.graphView(self, numberOfSegmentsInBarAtIndex: barIndex)
//                var barTotalValue = CGFloat(0)
//                var segments = [BarSegment]()
//                for segmentIndex in 0..<totalSegments {
//                    let value = datasource.graphView(self, valueForSegmentAtIndex: segmentIndex, inBarWithIndex: barIndex)
//                    barTotalValue += value
//                    let color = datasource.graphView(self, colorForSegmentAtIndex: segmentIndex, inBarWithIndex: barIndex)
//                    let segment = BarSegment(color: color, value: value)
//                    segments.append(segment)
//                }
//                var bar = Bar(segments: segments, width: barWidth)
//                bar.label = "LABEL \(barIndex)"
//                bars.append(bar)
//                maxBarValue = max(maxBarValue, barTotalValue)
//            }
//            
//            
//            
//            
//            /*
//                X axis
//            */
//            var xPosition = leftPadding + barWidth / 2
//            var xAxisLabels = [XAxisLabel]()
//            let totalWidth = barWidth * CGFloat(bars.count)
//            let padding = (bounds.size.width - leftPadding - rightPadding - totalWidth) / CGFloat(bars.count - 1 > 0 ? bars.count - 1 : 1)
//            for bar in bars {
//                if let barLabel = bar.label {
//                    let axisLabel = XAxisLabel(text: barLabel, xPosition: xPosition)
//                    xAxisLabels.append(axisLabel)
//                }
//                
//                xPosition += padding + barWidth
//            }
//            
//            let xAxisFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: CGFloat.max)
//            
//            xAxisView.frame = xAxisFrame
//            
//            
//            
//            //TODO: REmove me
//            xAxisTopPadding = 10
//            xAxisView.topBorderColor = UIColor.lightGrayColor()
//            xAxisView.topBorderWidth = 1.0
//            xAxisView.borderInset = 20.0
//            xAxisView.topBorder = true
//
//            
//            
//            
//            xAxisView.axisLabels = xAxisLabels
//            xAxisView.font = xAxisLabelFont
//            xAxisView.textColor = xAxisLabelColor
//            
//            xAxisView.sizeToFit()
//            let xAxisHeight = xAxisView.bounds.size.height + xAxisTopPadding
//            
//            let newXAxisFrame = CGRect(x: 0, y: bounds.size.height - xAxisHeight, width: bounds.size.width, height: xAxisHeight)
////            xAxisView.frame.origin = CGPoint(x: 0, y: bounds.size.height - xAxisHeight)
//            xAxisView.frame = newXAxisFrame
//            addSubview(xAxisView)
//
//            
//            println("Top padding is \(xAxisTopPadding)")
//            /*
//                Plot zone
//            */
//            //TODO: Perhaps I should add barPosition to the bars struct
//            let plotZoneFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - xAxisHeight - xAxisOffset)
//            //At this point, we have all the necessary value to build the other components
//            let plotZone = PlotZoneView(frame: plotZoneFrame, bars: bars, maxBarValue: maxBarValue)
//            addSubview(plotZone)
//        }
//    }
//    
//}
//
//
//class PlotZoneView: UIView {
//    var barSpacing = 20
//    var leftPadding = CGFloat(40)
//    var rightPadding = CGFloat(40)
//    var maxBarValue: CGFloat!
//    var bars: [Bar]!
//    
//    required convenience init(frame: CGRect, bars: [Bar], maxBarValue: CGFloat) {
//        self.init(frame:frame)
//        self.bars = bars
//        self.maxBarValue = maxBarValue
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if let bars = bars {
//
//            let totalWidth = bars.reduce(1) {
//                return $0 + $1.width
//            }
//            var xPosition = leftPadding
//            let height = bounds.size.height
//            //TODO: Need to enforce a minimum padding by shrinking the bar width if it goes over
//            let padding = (bounds.size.width - leftPadding - rightPadding - totalWidth) / CGFloat(bars.count - 1 > 0 ? bars.count - 1 : 1)
//            
//            for bar in bars {
//                let barHeight = bar.totalValue() / maxBarValue * height
//                let stackedBar = StackedBar(frame: CGRect(x: xPosition, y: height - barHeight, width: bar.width, height: barHeight), segments: bar.segments)
//                
//                addSubview(stackedBar)
//                xPosition += padding + bar.width
//            }
//        }
//    }
//}
//
//struct XAxisLabel {
//    let text: String
//    let xPosition: CGFloat
//}
//
//class XAxisView : UIView {
//    var font = UIFont.systemFontOfSize(12)
//    var textColor = UIColor.blackColor()
//    
//    var borderInset : CGFloat = 0
//
//    var topBorderWidth: CGFloat = 1.0
//    var topBorderColor = UIColor.grayColor()
//    var topBorder = false {
//        didSet {
//            println("Drawing border")
//            addBorder(.Top, color: topBorderColor, width: topBorderWidth, inset: borderInset)
//        }
//    }
//    
//    var bottomBorderWidth: CGFloat = 1.0
//    var bottomBorderColor = UIColor.grayColor()
//    var bottomBorder = false {
//        didSet {
//            addBorder(.Bottom, color: bottomBorderColor, width: bottomBorderWidth, inset: borderInset)
//        }
//    }
//    
//    var leftBorderWidth: CGFloat = 1.0
//    var leftBorderColor = UIColor.grayColor()
//    var leftBorder = false {
//        didSet {
//            addBorder(.Left, color: leftBorderColor, width: leftBorderWidth, inset: borderInset)
//        }
//    }
//    
//    var rightBorderWidth: CGFloat = 1.0
//    var rightBorderColor = UIColor.grayColor()
//    var rightBorder = false {
//        didSet {
//            addBorder(.Right, color: rightBorderColor, width: rightBorderWidth, inset: borderInset)
//        }
//    }
//    
//    
//    var axisLabels : [XAxisLabel]? {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    private var labels = [UILabel]()
//    
//    override func layoutSubviews() {
//        if let axisLabels = axisLabels {
//            subviews.map({ $0.removeFromSuperview() })
//            labels.removeAll(keepCapacity: true)
//            var previousLabelPosition: CGRect?
//            let centerY = bounds.size.height / 2
//            for axisLabel in axisLabels {
//                let label = UILabel()
//                label.font = font
//                label.textColor = textColor
//                
//                
//
//                label.text = axisLabel.text
//                
//                label.sizeToFit()
//                let labelCenter = CGPoint(x: axisLabel.xPosition, y: centerY)
//                label.center = labelCenter
//                if let previousLabelPosition = previousLabelPosition {
//                    //If the frames don't intersect, add the label
//                    if !CGRectIntersectsRect(previousLabelPosition, label.frame) {
//                        addSubview(label)
//
//                    }
//                } else {
//                    addSubview(label)
//                }
//                labels.append(label)
//                previousLabelPosition = label.frame
//            }
//        }
//    }
//    
//    override func sizeThatFits(size: CGSize) -> CGSize {
//        setNeedsLayout()
//        var size: CGSize = CGSizeZero
//        for label in labels {
//            let labelSize = label.bounds.size
//            size = size.height > labelSize.height ? size : labelSize
//        }
//        return CGSize(width: bounds.size.width, height: size.height)
//    }
//}
//
//let testXAxisView = XAxisView(frame: CGRect(x: 0, y: 0, width: 500, height: 20))
//testXAxisView.backgroundColor = UIColor.redColor()
//let testLabels = [
//    XAxisLabel(text: "First", xPosition: 20),
//    XAxisLabel(text: "Second", xPosition: 80),
//    XAxisLabel(text: "Third", xPosition: 140),
//    XAxisLabel(text: "Forth", xPosition: 200)
//]
//testXAxisView.axisLabels = testLabels
//
//
//
//
//
//
@objc class TestDatasource : GraphDatasourceProtocol {

    
    
    func numberOfBarsInGraphView(graphView: GraphView) -> Int {
        return 7
    }
    
    func graphView(graphView: GraphView, colorForSegmentAtIndex segmentIndex: Int, inBarWithIndex barIndex: Int) -> UIColor {
        var color = UIColor.blueColor()
        switch segmentIndex {
        case 0:
            return UIColor.seaGreen()
        case 1:
            return UIColor.rose()
        case 2:
            return UIColor.gold()
        case 3:
            return UIColor.grimace()
        case 4:
            return UIColor.slate()
        default:
            return color
        }
    }
    
    func graphView(graphView: GraphView, numberOfSegmentsInBarAtIndex atIndex: Int) -> Int {
        return 5
    }
    
    func graphView(graphView: GraphView, valueForSegmentAtIndex segmentIndex: Int, inBarWithIndex barIndex: Int) -> CGFloat {
//        return CGFloat(arc4random_uniform(40) + 1)
        return CGFloat(40)
    }
}


let myTestDatasource = TestDatasource()
let testGraph = GraphView(frame: CGRect(x: 0, y: 0, width: 700, height: 500))
testGraph.datasource = myTestDatasource

testGraph
testGraph.xAxisOffset = 10


testGraph.backgroundColor = UIColor.whiteColor()
print("HI")


//testGraph.xAxisView.topBorderColor = UIColor.lightGrayColor()
//testGraph.xAxisView.topBorderWidth = 1.0
//testGraph.xAxisView.borderInset = 20.0
//testGraph.xAxisView.topBorder = true
testGraph.xAxisTopPadding = 10
//testGraph.barWidth = 401

testGraph.backgroundColor = UIColor.whiteColor()

testGraph.setNeedsLayout()


testGraph.backgroundColor = .whiteColor()



