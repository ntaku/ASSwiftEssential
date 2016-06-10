
import Foundation
import UIKit

public extension UIView {
    
    public func removeAllSubViews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
    public func hasView(view: UIView) -> Bool {
        return !self.isDescendantOfView(view)
    }
    
    public func isSubviewOf(view: UIView) -> Bool {
        return self.isDescendantOfView(view)
    }
    
    public func setPoint(point: CGPoint) {
        var r : CGRect = self.frame
        r.origin = point
        self.frame = r
    }
    
    public func setX(x: CGFloat) {
        var r : CGRect = self.frame
        r.origin.x = x
        self.frame = r
    }
    
    public func setY(y: CGFloat) {
        var r : CGRect = self.frame
        r.origin.y = y
        self.frame = r
    }

    public func setSize(size: CGSize) {
        var r : CGRect = self.frame
        r.size = size
        self.frame = r
    }

    public func setW(w: CGFloat) {
        var r : CGRect = self.frame
        r.size.width = w
        self.frame = r
    }

    public func setH(h: CGFloat) {
        var r : CGRect = self.frame
        r.size.height = h
        self.frame = r
    }
}
