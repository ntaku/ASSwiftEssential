
import Foundation
import UIKit

public extension String {
    
    public var length: Int {
        return self.characters.count
    }

    /**
     セパレーターで分割
     */
    public func split(separator: String) -> [String] {
        return self.componentsSeparatedByString(separator)
    }

    /**
     文字列置換
     */
    public func gsub(from: String, to: String) -> String {
        return self.stringByReplacingOccurrencesOfString(from, withString: to)
    }

    /**
     カタカナに変換
     */
    public func toKatakana() -> String {
        var str = ""
        for c in unicodeScalars {
            if c.value >= 0x3041 && c.value <= 0x3096 {
                str.append(UnicodeScalar(c.value+96))
            } else {
                str.append(c)
            }
        }
        return str
    }
    
    /**
     ひらがなに変換
     */
    public func toHiragana() -> String {
        var str = ""
        for c in unicodeScalars {
            if c.value >= 0x30A1 && c.value <= 0x30F6 {
                str.append(UnicodeScalar(c.value-96))
            } else {
                str.append(c)
            }
        }
        return str
    }
    
    public func height(font: UIFont) -> CGFloat {
        return self.boundingRect(font, size: CGSizeMake(CGFloat.max, CGFloat.max)).size.height
    }

    public func boundingHeight(font: UIFont, width: CGFloat) -> CGFloat {
        return self.boundingRect(font, size: CGSizeMake(width, CGFloat.max)).size.height
    }

    public func width(font: UIFont) -> CGFloat {
        return self.boundingRect(font, size: CGSizeMake(CGFloat.max, CGFloat.max)).size.width
    }

    public func boundingWidth(font: UIFont, height: CGFloat) -> CGFloat {
        return self.boundingRect(font, size: CGSizeMake(CGFloat.max, height)).size.width
    }
    
    public func boundingRect(font: UIFont, size: CGSize) -> CGRect {
        let s = self as NSString
        
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let attr = [NSFontAttributeName: font]
        
        return s.boundingRectWithSize(size,
                                      options: option,
                                      attributes: attr,
                                      context: nil)
    }
}
