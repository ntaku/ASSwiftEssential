
import Foundation
import UIKit

public extension String {

    public var length: Int {
        return self.characters.count
    }

    /**
     セパレーターで分割
     */
    public func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }

    /**
     文字列置換
     */
    public func gsub(_ from: String, to: String) -> String {
        return self.replacingOccurrences(of: from, with: to)
    }

    /**
     カタカナに変換
     */
    public func toKatakana() -> String {
        var str = ""
        for c in unicodeScalars {
            if c.value >= 0x3041 && c.value <= 0x3096 {
                str.append(String(describing: UnicodeScalar(c.value+96)))
            } else {
                str.append(String(c))
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
                str.append(String(describing: UnicodeScalar(c.value-96)))
            } else {
                str.append(String(c))
            }
        }
        return str
    }

    public func height(_ font: UIFont) -> CGFloat {
        return self.boundingRect(font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).size.height
    }

    public func boundingHeight(_ font: UIFont, width: CGFloat) -> CGFloat {
        return self.boundingRect(font, size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).size.height
    }

    public func width(_ font: UIFont) -> CGFloat {
        return self.boundingRect(font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).size.width
    }

    public func boundingWidth(_ font: UIFont, height: CGFloat) -> CGFloat {
        return self.boundingRect(font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).size.width
    }

    public func boundingRect(_ font: UIFont, size: CGSize) -> CGRect {
        let s = self as NSString

        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let attr = [NSFontAttributeName: font]

        return s.boundingRect(with: size,
                              options: option,
                              attributes: attr,
                              context: nil)
    }
}
