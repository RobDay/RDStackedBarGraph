//
//  StackedBar.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import UIKit

class StackedBarView: UIView {
    
    var cornerRadius: CGFloat = 0
    
    var segments: [BarSegment]! {
        didSet {
            setNeedsDisplay()
        }
    }
    private var segmentTotal : CGFloat {
        return segments.reduce(0) {
            $0 + $1.value
        }
    }
    
    convenience init(frame: CGRect, segments: [BarSegment]) {
        self.init(frame: frame)
        self.segments = segments

        clipsToBounds = true
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        layer.cornerRadius = cornerRadius
        var runningTotal = CGFloat(0)
        let total = segmentTotal
        //        print("Total is \(total)\n")
        let barHeight = bounds.size.height
        let barWidth = bounds.size.width
        for segment in segments.reverse() {
            let scaledHeight = segment.value / total * barHeight
            //            print("Scaled height: \(scaledHeight)\n")
            
            let yPosition = runningTotal
            //            print("yPosition: \(yPosition)\n")
            let path = UIBezierPath(rect: CGRect(x: 0, y: yPosition, width: barWidth, height: scaledHeight))
            segment.color.setFill()
            path.fill()
            
            runningTotal += scaledHeight
        }
    }
}