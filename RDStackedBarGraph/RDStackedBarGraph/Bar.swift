//
//  Bar.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import Foundation

struct Bar: Hashable {
    let uniqueIdentifier: Int
    var hashValue: Int {
        return uniqueIdentifier.hashValue
    }
    let segments: [BarSegment]
    let width: CGFloat
    let xAxisPosition: CGFloat
    
    init(uniqueIdentifier: Int, segments: [BarSegment], width: CGFloat, xAxisPosition: CGFloat) {
        self.segments = segments
        self.width = width
        self.xAxisPosition = xAxisPosition
        self.uniqueIdentifier = uniqueIdentifier
    }
    
    
    func totalValue() -> CGFloat {
        return segments.reduce(0) {
            return $0 + $1.value
        }
    }
    
}

func ==(lhs: Bar, rhs: Bar) -> Bool {
    return lhs.uniqueIdentifier == rhs.uniqueIdentifier
}