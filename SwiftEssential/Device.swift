import Foundation
import UIKit

/*
 Portrait
 iPhone w:C h:R

 Landscape
 iPhone w:C h:C
 iPhone6+ w:R h:C

 iPad
 基本的には w:R h:R
 マルチタスクだと w:C h:R も発生
 */

public class Device {

    @objc public static func iOSVersion() -> Double {
        return (UIDevice.current.systemVersion as NSString).doubleValue
    }

    @objc public static func appVersion() -> String {
        let dict = Bundle.main.infoDictionary as Dictionary!
        return dict!["CFBundleShortVersionString"] as! String
    }

    @objc public static func isLandscape() -> Bool {
        if(UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight){
            return true
        }
        return false
    }

    @objc public static func isRetina() -> Bool {
        if(iOSVersion() >= 8.0){
            return UIScreen.main.traitCollection.displayScale >= 2.0
        }else{
            return UIScreen.main.scale >= 2.0
        }
    }

    // iPhone 4/4s
    @objc public static func isPhone35() -> Bool {
        return isPhone(width: 320, height: 480)
    }

    // iPhone 5/5s
    @objc public static func isPhone40() -> Bool {
        return isPhone(width: 320, height: 568)
    }

    // iPhone 6
    @objc public static func isPhone47() -> Bool {
        return isPhone(width: 375, height: 667)
    }

    // iPhone 6+
    @objc public static func isPhone55() -> Bool {
        return isPhone(width: 414, height: 736)
    }

    // iPhone X
    @objc public static func isPhoneX() -> Bool {
        return isPhone(width: 375, height: 812)
    }

    fileprivate static func isPhone(width: CGFloat, height: CGFloat) -> Bool {
        if(isPad()) { return false }
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        return (w == width && h == height) || (w == height && h == width)
    }

    @objc public static func isPad() -> Bool {
        if(iOSVersion() >= 8.0){
            return UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        }else{
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        }
    }

    // 横Compact, 縦Regular の状態かどうか (iPhoneとiPadのマルチタスク時に該当)
    @objc public static func isSizeClass_wC_hR(viewController vc: UIViewController) -> Bool {
        let hC = UITraitCollection.init(horizontalSizeClass: UIUserInterfaceSizeClass.compact)
        let vR = UITraitCollection.init(verticalSizeClass: UIUserInterfaceSizeClass.regular)

        if(vc.traitCollection.containsTraits(in: hC)){
            if(vc.traitCollection.containsTraits(in: vR)){
                return true
            }
        }
        return false
    }

    // 横Regular, 縦Regular の状態かどうか
    @objc public static func isSizeClass_wR_hR(viewController vc: UIViewController) -> Bool {
        let hR = UITraitCollection.init(horizontalSizeClass: UIUserInterfaceSizeClass.regular)
        let vR = UITraitCollection.init(verticalSizeClass: UIUserInterfaceSizeClass.regular)

        if(vc.traitCollection.containsTraits(in: hR)){
            if(vc.traitCollection.containsTraits(in: vR)){
                return true
            }
        }
        return false
    }

    // iPadがマルチタスク状態かどうか（w:R, h:Rの解像度が複数存在する）
    @objc public static func isSizeClass_wR_hR_Full(viewController vc: UIViewController) -> Bool {
        if(self.isSizeClass_wR_hR(viewController: vc)){
            if(UIScreen.main.bounds.size.width == vc.view.frame.size.width){
                return true
            }
        }
        return false
    }
}
