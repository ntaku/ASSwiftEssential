
import Foundation
import UIKit

public extension String {
    
    public var length: Int {
        return self.characters.count
    }

    public func split(separator: String) -> [String] {
        return self.componentsSeparatedByString(separator)
    }
    
    public func gsub(from: String, to: String) -> String {
        return self.stringByReplacingOccurrencesOfString(from, withString: to)
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
}
