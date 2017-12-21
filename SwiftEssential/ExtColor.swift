import Foundation
import UIKit

public extension UIColor {

    // 0x000000 の書式でカラーを取得
    @objc public class func hex(_ hex : Int, alpha : CGFloat = 1.0) -> UIColor {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }

    // "0x000000" の書式でカラーを取得
    @objc public class func hex(string: String, alpha: CGFloat = 1.0) -> UIColor {
        let range = NSMakeRange(0, string.count)
        let hex = (string as NSString).replacingOccurrences(of: "[^0-9a-fA-F]", with: "", options: NSString.CompareOptions.regularExpression, range: range)
        var c: UInt32 = 0
        Scanner(string: hex).scanHexInt32(&c)
        return UIColor.hex(Int(c), alpha: alpha)
    }

    // 現在のカラーを "0x000000" の書式で取得
    @objc public func toString() -> String? {
        return self.cgColor.toString()
    }

    // 現在のカラーの成分要素を取得
    public func toRGBA() -> (red: Int, green: Int, blue: Int, alpha: CGFloat)? {
        return self.cgColor.toRGBA()
    }
}

public extension CGColor {

    public func toString() -> String? {
        if let x = self.toRGBA() {
            let hex = x.red * 0x10000 + x.green * 0x100 + x.blue
            return NSString(format:"%06x", hex) as String
        } else {
            return nil
        }
    }

    public func toRGBA() -> (red: Int, green: Int, blue: Int, alpha: CGFloat)? {
        let colorSpace = self.colorSpace
        let colorSpaceModel = colorSpace?.model
        if colorSpaceModel?.rawValue == 1 {
            let x = self.components
            let r: Int = Int(x![0] * 255.0)
            let g: Int = Int(x![1] * 255.0)
            let b: Int = Int(x![2] * 255.0)
            let a: CGFloat = x![3]
            return (r, g, b, a)
        } else {
            return nil
        }
    }
}
