//
// This file (and all other Swift source files in the Sources directory of this playground) will be precompiled into a framework which is automatically made available to Charting.playground.
//

import UIKit

//public enum BorderSide {
//    case Top, Bottom, Left, Right
//}
//
//extension UIView {
//    
//    public func addBorder(side: BorderSide, color: UIColor, width: CGFloat, inset: CGFloat = 0.0) {
//        let border = CALayer()
//        border.backgroundColor = color.CGColor
//        
//        switch side {
//        case .Top:
//            border.frame = CGRect(x: 0 + inset, y: 0, width: frame.size.width - (inset * 2), height: width)
//        case .Bottom:
//            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width - (inset * 2), height: width)
//        case .Left:
//            border.frame = CGRect(x: 0, y: 0 + inset, width: width, height: frame.size.width - (inset * 2) )
//        case .Right:
//            border.frame = CGRect(x: self.frame.size.width - width, y: 0 + inset, width: width, height: frame.size.width - (inset * 2))
//        }
//        
//        self.layer.addSublayer(border)
//    }
//}

public extension UIColor {
    public convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = advance(rgba.startIndex, 1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                if count(hex) == 6 {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if count(hex) == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    print("invalid rgb string, length should be 7 or 9")
                }
            } else {
                println("scan hex error")
            }
        } else {
            print("invalid rgb string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

public extension UIColor {
    class func flood() -> UIColor {
        return UIColor(rgba: "#367DC1")
        //        return UIColor(red: 44/255.0, green: 103/255.0, blue: 180/255.0, alpha: 1.0)
    }
    //TODO: Denim or flood needs to be updated with proper code
    class func denim() -> UIColor {
        return UIColor(rgba: "#416A91")
    }
    class func paleBlue() -> UIColor {
        return UIColor(rgba: "#416A91")
    }
    class func midnight() -> UIColor {
        return UIColor(rgba: "#122435")
    }
    class func seaGreen() -> UIColor {
        return UIColor(rgba: "#00C3A9")
    }
    class func rose() -> UIColor {
        return UIColor(rgba: "#F06060")
    }
    class func gold() -> UIColor {
        return UIColor(rgba: "#FFC925")
    }
    class func grimace() -> UIColor {
        return UIColor(rgba: "#8965AD")
    }
    class func slate() -> UIColor {
        return UIColor(rgba: "#97A3AF")
    }
    class func stone() -> UIColor {
        return UIColor(rgba: "#D8E0E6")
    }
    class func ice() -> UIColor {
        return UIColor(rgba: "#F2F6F9")
    }
}