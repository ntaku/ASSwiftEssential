import Foundation
import UIKit

public extension UIView {

    @objc func removeAllSubViews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }

    @objc func has(view: UIView) -> Bool {
        return !self.isDescendant(of: view)
    }

    @objc func isSubview(of view: UIView) -> Bool {
        return self.isDescendant(of: view)
    }

    @objc func set(point: CGPoint) {
        var r : CGRect = self.frame
        r.origin = point
        self.frame = r
    }

    @objc func set(x: CGFloat) {
        var r : CGRect = self.frame
        r.origin.x = x
        self.frame = r
    }

    @objc func set(y: CGFloat) {
        var r : CGRect = self.frame
        r.origin.y = y
        self.frame = r
    }

    @objc func set(size: CGSize) {
        var r : CGRect = self.frame
        r.size = size
        self.frame = r
    }

    @objc func set(width: CGFloat) {
        var r : CGRect = self.frame
        r.size.width = width
        self.frame = r
    }

    @objc func set(height: CGFloat) {
        var r : CGRect = self.frame
        r.size.height = height
        self.frame = r
    }
}
