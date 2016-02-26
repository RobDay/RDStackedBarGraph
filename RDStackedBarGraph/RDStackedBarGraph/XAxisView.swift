//
//  XAxisView.swift
//  RDStackedBarGraph
//
//  Created by Robert Day on 6/22/15.
//  Copyright (c) 2015 Robert Day. All rights reserved.
//

import UIKit

struct XAxisLabel: Hashable {
    var hashValue: Int {
        return uniqueIdentifier.hashValue
    }
    let uniqueIdentifier: Int
    let text: String
    let xPosition: CGFloat
}

func ==(lhs: XAxisLabel, rhs: XAxisLabel) -> Bool {
    return lhs.uniqueIdentifier == rhs.uniqueIdentifier
}


public class XAxisView : UIView {
    var font = UIFont.systemFontOfSize(12)
    var textColor = UIColor.blackColor()
    
    var maxVisibleLabels = 7 //TODO: Centralize this
    
    var labelSizes : [XAxisLabel: CGRect]!
    var maxLabelHeight : CGFloat = 0
    var axisLabels : [XAxisLabel]! {
        didSet {
            guard let axisLabels = axisLabels else { return }
            if let oldValue = oldValue {
                if oldValue == axisLabels {
                    return
                }
            }
            
            labelSizes = [XAxisLabel: CGRect]()
            maxLabelHeight = 0
            for axisLabel in axisLabels {
                let label = UILabel()
                label.textAlignment = .Center
                label.numberOfLines = 0
                label.font = font
                label.textColor = textColor
                
                label.text = axisLabel.text
                label.sizeToFit()
                labelSizes[axisLabel] = label.frame
                if label.bounds.size.height > maxLabelHeight {
                    maxLabelHeight = label.bounds.size.height
                }
            }
            setNeedsLayout()
        }
    }
    
    var offset: CGFloat = 0 {
        didSet {
            if oldValue != offset {
                setNeedsLayout()
            }
        }
    }
    
    private var axisLabelToLabel = [XAxisLabel: UILabel]()
    
    private var labelQueue = [UILabel]()

    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard axisLabels != nil else {
            return
        }
        clipsToBounds = true
        
        let existingLabels = Set (axisLabelToLabel.keys)
        let newVisibleLabels = visibleLabels()
        let newVisibleLabelsSet = Set(newVisibleLabels)
        
        let removedLabels = existingLabels.subtract(newVisibleLabelsSet)
        
        for axisLabel in removedLabels {
            if let label = axisLabelToLabel[axisLabel] {
                label.removeFromSuperview()
                labelQueue.append(label)
                axisLabelToLabel.removeValueForKey(axisLabel)
            } else {
                assertionFailure("Should never get here.  Should always have tracked label")
            }
        }
        
        

        var previousLabelPosition: CGRect?
        for axisLabel in newVisibleLabels {
            let label: UILabel
            if let existingLabel = axisLabelToLabel[axisLabel] {
                label = existingLabel
            } else {
                label = dequeueLabelForAxisLabel(axisLabel)
                axisLabelToLabel[axisLabel] = label
            }
            
            let centerY = bounds.size.height / 2
            let labelCenter = CGPoint(x: axisLabel.xPosition - offset, y: centerY)
            label.center = labelCenter
            

            if let myPreviousLabelPosition = previousLabelPosition {
                //If the frames don't intersect, add the label
                if !CGRectIntersectsRect(myPreviousLabelPosition, label.frame) && CGRectIntersectsRect(self.bounds, label.frame) {
                    addSubview(label)
                    previousLabelPosition = label.frame
                }
            } else {
                if CGRectIntersectsRect(self.bounds, label.frame) {
                    addSubview(label)
                    previousLabelPosition = label.frame
                }
            }
           
            
        }
    }
    
    private func visibleLabels() -> [XAxisLabel] {
        let minVisibleXAxisPosition = CGFloat(0)
        
        let maxVisibleXAxisPosition = bounds.size.width
        
        let newAxisLabels = axisLabels.filter {
            guard let frameForLabel = labelSizes[$0] else { return false }
            let labelWidth = frameForLabel.size.width
            
            let labelLeftXAxisPosition = $0.xPosition - offset - (labelWidth / 2)
            let labelRightXAxisPosition = $0.xPosition - offset + (labelWidth / 2)
            
            return labelRightXAxisPosition > minVisibleXAxisPosition && labelLeftXAxisPosition < maxVisibleXAxisPosition
        }
        
        
        return newAxisLabels
    }
    
    private func dequeueLabelForAxisLabel(axisLabel: XAxisLabel) -> UILabel {
        
        
        let label: UILabel
        if labelQueue.count > 0 {
            label = labelQueue.removeFirst()
        } else {
            label = newUILabelForAxisLabel()
        }

        label.text = axisLabel.text
        guard let frameForLabel = labelSizes[axisLabel] else { return label }

        label.bounds = frameForLabel
        return label
    }
    
    private func newUILabelForAxisLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.font = font
        label.textColor = textColor
        
        return label
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
//        layoutIfNeeded()
        return CGSize(width: bounds.size.width, height: maxLabelHeight)
    }
}