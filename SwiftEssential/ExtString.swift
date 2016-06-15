
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

    public func boundingHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let s = self as NSString
        
        let size = CGSizeMake(width, CGFloat.max)
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let attr = [NSFontAttributeName: font]
     
        return s.boundingRectWithSize(size,
                                      options: option,
                                      attributes: attr,
                                      context: nil).size.height
    }
}
