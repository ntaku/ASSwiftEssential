
import Foundation
import UIKit

public extension UITableViewCell {

    public func removeMargins() {
        if self.respondsToSelector(Selector("setSeparatorInset:")) {
            self.separatorInset = UIEdgeInsetsZero
        }
        if self.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            self.preservesSuperviewLayoutMargins = false
        }
        if self.respondsToSelector(Selector("setLayoutMargins:")) {
            self.layoutMargins = UIEdgeInsetsZero
        }
    }
}