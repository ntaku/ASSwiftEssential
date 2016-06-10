
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
    
    public static func iOSVersion() -> Double {
        return (UIDevice.currentDevice().systemVersion as NSString).doubleValue
    }
    
    public static func appVersion() -> String {
        let dict = NSBundle.mainBundle().infoDictionary as Dictionary!
        return dict["CFBundleShortVersionString"] as! String
    }
    
    public static func isLandscape() -> Bool {
        if(UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight){
                return true
        }
        return false
    }
    
    public static func isRetina() -> Bool {
        if(iOSVersion() >= 8.0){
            return UIScreen.mainScreen().traitCollection.displayScale >= 2.0
        }else{
            return UIScreen.mainScreen().scale >= 2.0
        }
    }

    // iPhone 4/4s
    public static func isPhone35() -> Bool {
        return isPhone(width: 320, height: 480)
    }
    
    // iPhone 5/5s
    public static func isPhone40() -> Bool {
        return isPhone(width: 320, height: 568)
    }
    
    // iPhone 6
    public static func isPhone47() -> Bool {
        return isPhone(width: 375, height: 667)
    }
    
    // iPhone 6+
    public static func isPhone55() -> Bool {
        return isPhone(width: 414, height: 736)
    }
    
    private static func isPhone(width width: CGFloat, height: CGFloat) -> Bool {
        if(isPad()) { return false }
        let w = UIScreen.mainScreen().bounds.width
        let h = UIScreen.mainScreen().bounds.height
        return (w == width && h == height) || (w == height && h == width)
    }
    
    public static func isPad() -> Bool {
        if(iOSVersion() >= 8.0){
            return UIScreen.mainScreen().traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        }else{
            return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        }
    }
    
    // 横Compact, 縦Regular の状態かどうか (iPhoneとiPadのマルチタスク時に該当)
    public static func isSizeClass_wC_hR(viewController vc: UIViewController) -> Bool {
        let hC = UITraitCollection.init(horizontalSizeClass: UIUserInterfaceSizeClass.Compact)
        let vR = UITraitCollection.init(verticalSizeClass: UIUserInterfaceSizeClass.Regular)
        
        if(vc.traitCollection.containsTraitsInCollection(hC)){
            if(vc.traitCollection.containsTraitsInCollection(vR)){
                return true
            }
        }
        return false
    }
    
    // 横Regular, 縦Regular の状態かどうか
    public static func isSizeClass_wR_hR(viewController vc: UIViewController) -> Bool {
        let hR = UITraitCollection.init(horizontalSizeClass: UIUserInterfaceSizeClass.Regular)
        let vR = UITraitCollection.init(verticalSizeClass: UIUserInterfaceSizeClass.Regular)
        
        if(vc.traitCollection.containsTraitsInCollection(hR)){
            if(vc.traitCollection.containsTraitsInCollection(vR)){
                return true
            }
        }
        return false
    }
    
    // iPadがマルチタスク状態かどうか（w:R, h:Rの解像度が複数存在する）
    public static func isSizeClass_wR_hR_Full(viewController vc: UIViewController) -> Bool {
        if(self.isSizeClass_wR_hR(viewController: vc)){
            if(UIScreen.mainScreen().bounds.size.width == vc.view.frame.size.width){
                return true
            }
        }
        return false
    }
}