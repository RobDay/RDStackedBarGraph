//
//  UIVIew+Border.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import Foundation

public enum BorderSide {
    case Top, Bottom, Left, Right
}

extension UIView {
    
    public func addBorder(side: BorderSide, color: UIColor, width: CGFloat, inset: CGFloat = 0.0) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        
        switch side {
        case .Top:
            println("Adding a border with inset \(inset)")
            let newRect = CGRect(x: 0 + inset, y: 0, width: frame.size.width - (inset * 2), height: width)
            border.frame = newRect
            println("Border frame is \(border.frame)")
            println("Frame is \(frame)")
            
            println("New rect is \(newRect)")
            println("Math is \(0 + inset)")
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width - (inset * 2), height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0 + inset, width: width, height: frame.size.width - (inset * 2) )
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0 + inset, width: width, height: frame.size.width - (inset * 2))
        }
        
        self.layer.addSublayer(border)
    }
}
