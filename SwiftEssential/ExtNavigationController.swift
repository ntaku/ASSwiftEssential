
import Foundation
import UIKit

public extension UINavigationController {

    open override var preferredStatusBarStyle : UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }

    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .all
    }

    open override var shouldAutorotate : Bool {
        return self.topViewController?.shouldAutorotate ?? true
    }
}
