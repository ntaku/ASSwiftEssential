import Foundation
import UIKit

public extension String {

    public var length: Int {
        return count
    }

    public func split(by separator: String) -> [String] {
        return components(separatedBy: separator)
    }

    public func gsub(from: String, to: String) -> String {
        return replacingOccurrences(of: from, with: to)
    }

    public func boundingRect(with font: UIFont, size: CGSize) -> CGRect {
        return (self as NSString).boundingRect(with: size,
                                               options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                               attributes: [NSAttributedStringKey.font: font],
                                               context: nil)
    }

    public func height(with font: UIFont) -> CGFloat {
        return boundingRect(with: font,
                            size: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                         height: CGFloat.greatestFiniteMagnitude)).size.height
    }

    public func width(with font: UIFont) -> CGFloat {
        return boundingRect(with: font,
                            size: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                         height: CGFloat.greatestFiniteMagnitude)).size.width
    }

    public func boundingHeight(with font: UIFont, width: CGFloat) -> CGFloat {
        return boundingRect(with: font,
                            size: CGSize(width: width,
                                         height: CGFloat.greatestFiniteMagnitude)).size.height
    }

    public func boundingWidth(with font: UIFont, height: CGFloat) -> CGFloat {
        return boundingRect(with: font,
                            size: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                         height: height)).size.width
    }
}
