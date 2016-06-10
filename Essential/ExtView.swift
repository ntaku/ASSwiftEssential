
import Foundation
import UIKit

public extension UIView {
    
    func removeAllSubViews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
    func hasView(view: UIView) -> Bool {
        return !self.isDescendantOfView(view)
    }
    
    func isSubviewOf(view: UIView) -> Bool {
        return self.isDescendantOfView(view)
    }
    
    func setPoint(point: CGPoint) {
        var r : CGRect = self.frame
        r.origin = point
        self.frame = r
    }
    
    func setX(x: CGFloat) {
        var r : CGRect = self.frame
        r.origin.x = x
        self.frame = r
    }
    
    func setY(y: CGFloat) {
        var r : CGRect = self.frame
        r.origin.y = y
        self.frame = r
    }

    func setSize(size: CGSize) {
        var r : CGRect = self.frame
        r.size = size
        self.frame = r
    }

    func setW(w: CGFloat) {
        var r : CGRect = self.frame
        r.size.width = w
        self.frame = r
    }

    func setH(h: CGFloat) {
        var r : CGRect = self.frame
        r.size.height = h
        self.frame = r
    }
}
