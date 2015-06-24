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
    var font = UIFont.systemFontOfSize(12)
    var textColor = UIColor.blackColor()
    
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
                
                if CGRectContainsRect(self.bounds, label.frame) {
                    if let myPreviousLabelPosition = previousLabelPosition {
                        //If the frames don't intersect, add the label
                        if !CGRectIntersectsRect(myPreviousLabelPosition, label.frame) {
                                addSubview(label)
                                previousLabelPosition = label.frame
                        }
                    } else {
                        addSubview(label)
                        previousLabelPosition = label.frame
                    }

                }
                
                
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
        var size: CGSize = CGSizeZero
        for label in labels {
            let labelSize = label.bounds.size
            size = size.height > labelSize.height ? size : labelSize
        }
        return CGSize(width: bounds.size.width, height: size.height)
    }
}