
import Foundation
import UIKit

public extension UIView {

    public func removeAllSubViews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }

    public func hasView(_ view: UIView) -> Bool {
        return !self.isDescendant(of: view)
    }

    public func isSubviewOf(_ view: UIView) -> Bool {
        return self.isDescendant(of: view)
    }

    public func setPoint(_ point: CGPoint) {
        var r : CGRect = self.frame
        r.origin = point
        self.frame = r
    }

    public func setX(_ x: CGFloat) {
        var r : CGRect = self.frame
        r.origin.x = x
        self.frame = r
    }

    public func setY(_ y: CGFloat) {
        var r : CGRect = self.frame
        r.origin.y = y
        self.frame = r
    }

    public func setSize(_ size: CGSize) {
        var r : CGRect = self.frame
        r.size = size
        self.frame = r
    }

    public func setW(_ w: CGFloat) {
        var r : CGRect = self.frame
        r.size.width = w
        self.frame = r
    }

    public func setH(_ h: CGFloat) {
        var r : CGRect = self.frame
        r.size.height = h
        self.frame = r
    }
}
