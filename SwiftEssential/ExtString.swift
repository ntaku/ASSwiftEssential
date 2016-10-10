
import Foundation
import UIKit

public extension String {

    public var length: Int {
        return self.characters.count
    }

    /**
     セパレーターで分割
     */
    public func split(by separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }

    /**
     文字列置換
     */
    public func gsub(from: String, to: String) -> String {
        return self.replacingOccurrences(of: from, with: to)
    }

    /**
    文字サイズ取得
     */
    public func boundingRect(with font: UIFont, size: CGSize) -> CGRect {
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let attr = [NSFontAttributeName: font]

        let s = self as NSString
        return s.boundingRect(with: size,
                              options: option,
                              attributes: attr,
                              context: nil)
    }

    public func height(with font: UIFont) -> CGFloat {
        return self.boundingRect(with: font,
                                 size: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                              height: CGFloat.greatestFiniteMagnitude)).size.height
    }

    public func width(with font: UIFont) -> CGFloat {
        return self.boundingRect(with: font,
                                 size: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                              height: CGFloat.greatestFiniteMagnitude)).size.width
    }

    public func boundingHeight(with font: UIFont, width: CGFloat) -> CGFloat {
        return self.boundingRect(with: font,
                                 size: CGSize(width: width,
                                              height: CGFloat.greatestFiniteMagnitude)).size.height
    }

    public func boundingWidth(with font: UIFont, height: CGFloat) -> CGFloat {
        return self.boundingRect(with: font,
                                 size: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                              height: height)).size.width
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
}
