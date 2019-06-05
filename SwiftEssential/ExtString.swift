import Foundation
import UIKit

public extension String {

    var length: Int {
        return count
    }

    func split(by separator: String) -> [String] {
        return components(separatedBy: separator)
    }

    func gsub(from: String, to: String) -> String {
        return replacingOccurrences(of: from, with: to)
    }

    func boundingRect(with font: UIFont, size: CGSize) -> CGRect {
        return (self as NSString).boundingRect(with: size,
                                               options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                               attributes: [NSAttributedString.Key.font: font],
                                               context: nil)
    }

    func height(with font: UIFont) -> CGFloat {
        return boundingRect(with: font,
                            size: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                         height: CGFloat.greatestFiniteMagnitude)).size.height
    }

    func width(with font: UIFont) -> CGFloat {
        return boundingRect(with: font,
                            size: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                         height: CGFloat.greatestFiniteMagnitude)).size.width
    }

    func boundingHeight(with font: UIFont, width: CGFloat) -> CGFloat {
        return boundingRect(with: font,
                            size: CGSize(width: width,
                                         height: CGFloat.greatestFiniteMagnitude)).size.height
    }

    func boundingWidth(with font: UIFont, height: CGFloat) -> CGFloat {
        return boundingRect(with: font,
                            size: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                         height: height)).size.width
    }
}
