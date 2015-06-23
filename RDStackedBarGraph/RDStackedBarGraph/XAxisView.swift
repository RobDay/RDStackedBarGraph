//
//  XAxisView.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import UIKit

struct XAxisLabel {
    let text: String
    let xPosition: CGFloat
}

public class XAxisView : UIView {
    public var font = UIFont.systemFontOfSize(12)
    public var textColor = UIColor.blackColor()
    
    public var borderInset : CGFloat = 0
    
    public var topBorderWidth: CGFloat = 1.0
    public var topBorderColor = UIColor.grayColor()
    public var topBorder = false {
        didSet {
            println("Drawing border")
            addBorder(.Top, color: topBorderColor, width: topBorderWidth, inset: borderInset)
        }
    }
    
    public var bottomBorderWidth: CGFloat = 1.0
    public var bottomBorderColor = UIColor.grayColor()
    public var bottomBorder = false {
        didSet {
            addBorder(.Bottom, color: bottomBorderColor, width: bottomBorderWidth, inset: borderInset)
        }
    }
    
    public var leftBorderWidth: CGFloat = 1.0
    public var leftBorderColor = UIColor.grayColor()
    public var leftBorder = false {
        didSet {
            addBorder(.Left, color: leftBorderColor, width: leftBorderWidth, inset: borderInset)
        }
    }
    
    public var rightBorderWidth: CGFloat = 1.0
    public var rightBorderColor = UIColor.grayColor()
    public var rightBorder = false {
        didSet {
            addBorder(.Right, color: rightBorderColor, width: rightBorderWidth, inset: borderInset)
        }
    }
    
    
    var axisLabels : [XAxisLabel]? {
        didSet {
            setNeedsLayout()
        }
    }
    private var labels = [UILabel]()
    
    override public func layoutSubviews() {
        if let axisLabels = axisLabels {
            subviews.map({ $0.removeFromSuperview() })
            labels.removeAll(keepCapacity: true)
            var previousLabelPosition: CGRect?
            let centerY = bounds.size.height / 2
            for axisLabel in axisLabels {
                let label = UILabel()
                label.font = font
                label.textColor = textColor
                
                label.text = axisLabel.text
                
                label.sizeToFit()
                let labelCenter = CGPoint(x: axisLabel.xPosition, y: centerY)
                label.center = labelCenter
                //TODO: Clean this up
                if let myPreviousLabelPosition = previousLabelPosition {
                    //If the frames don't intersect, add the label
                    if !CGRectIntersectsRect(myPreviousLabelPosition, label.frame) &&
                        CGRectContainsRect(self.bounds, label.frame) {
                        addSubview(label)
                        previousLabelPosition = label.frame
                    }
                } else {
                    if CGRectContainsRect(self.bounds, label.frame) {
                        addSubview(label)
                        previousLabelPosition = label.frame
                    }
                }
                labels.append(label)
                
            }
        }
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        layoutIfNeeded()
//        println("Font is \(font)")
        var size: CGSize = CGSizeZero
        for label in labels {
            let labelSize = label.bounds.size
            size = size.height > labelSize.height ? size : labelSize
        }
//        println("Size is \(size)")
        return CGSize(width: bounds.size.width, height: size.height)
    }
}