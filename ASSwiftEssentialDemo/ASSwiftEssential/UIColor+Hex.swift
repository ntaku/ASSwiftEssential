
import Foundation
import UIKit

extension UIColor {

    // 0x000000 の書式でカラーを取得
    class func hexColor(hex : Int, alpha : CGFloat = 1.0) -> UIColor {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }

    // "0x000000" の書式でカラーを取得
    class func hexStringColor(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        let range = NSMakeRange(0, hexString.characters.count)
        let hex = (hexString as NSString).stringByReplacingOccurrencesOfString("[^0-9a-fA-F]", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: range)
        var color: UInt32 = 0
        NSScanner(string: hex).scanHexInt(&color)
        return hexColor(Int(color), alpha: alpha)
    }

    // 現在のカラーを "0x000000" の書式で取得
    var hexString: String? {
        return self.CGColor.hexString
    }
    
    var RGBa: (red: Int, green: Int, blue: Int, alpha: CGFloat)? {
        return self.CGColor.RGBa
    }
}

extension CGColor {
    
    var hexString: String? {
        if let x = self.RGBa {
            let hex = x.red * 0x10000 + x.green * 0x100 + x.blue
            return NSString(format:"%06x", hex) as String
        } else {
            return nil
        }
    }
    
    var RGBa: (red: Int, green: Int, blue: Int, alpha: CGFloat)? {
        let colorSpace = CGColorGetColorSpace(self)
        let colorSpaceModel = CGColorSpaceGetModel(colorSpace)
        if colorSpaceModel.rawValue == 1 {
            let x = CGColorGetComponents(self)
            let r: Int = Int(x[0] * 255.0)
            let g: Int = Int(x[1] * 255.0)
            let b: Int = Int(x[2] * 255.0)
            let a: CGFloat = x[3]
            return (r, g, b, a)
        } else {
            return nil
        }
    }
}
