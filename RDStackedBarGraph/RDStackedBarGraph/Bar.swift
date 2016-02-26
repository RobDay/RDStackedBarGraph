//
//  Bar.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import Foundation

struct Bar: Hashable {
    let hashValue: Int
    let segments: [BarSegment]
    let width: CGFloat
    let xAxisPosition: CGFloat
    
    init(segments: [BarSegment], width: CGFloat, xAxisPosition: CGFloat) {
        self.segments = segments
        self.width = width
        self.xAxisPosition = xAxisPosition
        
        let segmentHashValue = segments.reduce(0, combine: {$0 ^ $1.hashValue})
        self.hashValue = width.hashValue ^ xAxisPosition.hashValue ^ segmentHashValue
    }
    
    
    func totalValue() -> CGFloat {
        return segments.reduce(0) {
            return $0 + $1.value
        }
    }
    
}

func ==(lhs: Bar, rhs: Bar) -> Bool {
    return lhs.segments == rhs.segments &&
        lhs.width == rhs.width &&
        lhs.xAxisPosition == rhs.xAxisPosition
}