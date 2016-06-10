
import Foundation
import UIKit

extension UIView {
    
    func moveTo(point: CGPoint) {
        var r : CGRect = self.frame;
        r.origin = point;
        self.frame = r;
    }
    
    func moveXto(x: CGFloat) {
        var r : CGRect = self.frame;
        r.origin.x = x;
        self.frame = r;
    }
    
    func moveYto(y: CGFloat) {
        var r : CGRect = self.frame;
        r.origin.y = y;
        self.frame = r;
    }
    
    func scaleTo(size: CGSize) {
        var r : CGRect = self.frame;
        r.size = size;
        self.frame = r;
    }
}
