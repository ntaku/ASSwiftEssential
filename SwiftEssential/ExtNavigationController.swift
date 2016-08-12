
import Foundation
import UIKit

public extension UINavigationController {

    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle() ?? .Default
    }

    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations() ?? .All
    }

    public override func shouldAutorotate() -> Bool {
        return self.topViewController?.shouldAutorotate() ?? true
    }
}