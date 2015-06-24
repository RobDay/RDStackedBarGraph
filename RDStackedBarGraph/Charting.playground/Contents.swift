//: Playground - noun: a place where people can play

import UIKit
//import RDStackedBarGraph



var str = "Hello, playground"

import Foundation
import UIKit

import RDStackedBarGraph



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
    
    func graphView(graphView: GraphView, labelForBarAtIndex barIndex: Int) -> String {
        return "Label \(barIndex)"
    }
}

let myTestDatasource = TestDatasource()
let testGraph = GraphView(frame: CGRect(x: 0, y: 0, width: 700, height: 500))
testGraph.datasource = myTestDatasource


print("HI")
testGraph.setNeedsLayout()

testGraph.xAxisView.addBorder(.Top, color: UIColor.lightGrayColor(), width: 1.0, inset: 20.0)
testGraph.xAxisTopPadding = 30
testGraph.xAxisTopMargin = 20 //Rename
testGraph.barWidth = 60


//testGraph.backgroundColor = UIColor.whiteColor()

testGraph.setNeedsLayout()





