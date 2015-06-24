//
//  Bar.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import Foundation

struct Bar {
    let segments: [BarSegment]
    let width: CGFloat
    var label: String?
    var xAxisPosition: CGFloat
    
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