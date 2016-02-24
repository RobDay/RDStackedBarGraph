//
//  Bar.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import Foundation

struct Bar: Hashable {
    var hashValue: Int {
        //TODO: Come up with a better hash value
        return totalValue().hashValue
    }
    let segments: [BarSegment]
    let width: CGFloat
    let xAxisPosition: CGFloat
    
    init(segments: [BarSegment], width: CGFloat, xAxisPosition: CGFloat) {
        self.segments = segments
        self.width = width
        self.xAxisPosition = xAxisPosition
    }
    
    
    func totalValue() -> CGFloat {
        return segments.reduce(0) {
            return $0 + $1.value
        }
    }
    
}

func ==(lhs: Bar, rhs: Bar) -> Bool {
    if lhs.segments == rhs.segments &&
        lhs.width == rhs.width &&
        lhs.xAxisPosition == rhs.xAxisPosition {
            return true
    } else {
        return false
    }
}