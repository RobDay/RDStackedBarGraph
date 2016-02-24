//
//  BarSegment.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import Foundation

public struct BarSegment: Equatable {
    public let color: UIColor
    public let value: CGFloat
    public init(color: UIColor, value: CGFloat) {
        self.color = color
        self.value = value
    }
}

public func ==(lhs: BarSegment, rhs: BarSegment) -> Bool {
    return lhs.color == rhs.color && lhs.value == rhs.value
}