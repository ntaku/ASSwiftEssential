import Foundation
import UIKit
import CoreTelephony

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
        if let dict = Bundle.main.infoDictionary as [String: Any]? {
            if let version = dict["CFBundleShortVersionString"] as? String {
                return version
            }
        }
        return ""
    }

    @objc public static func deviceModel(getRawName: Bool = false) -> String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)

        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)

        let code: String = String(cString:machine)
        if getRawName {
            return code
        }
        return DeviceList[code] ?? code
    }

    @objc public static func cdid() -> String {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return "ios:\(uuid)"
        }
        return "null"
    }

    @objc public static func carrierName() -> String {
        guard let provider = CTTelephonyNetworkInfo().subscriberCellularProvider else { return "null" }
        guard let name = provider.carrierName else { return "null" }
        return CarrierList[name] ?? name
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

    private static let CarrierList = [
        "ソフトバンク": "SOFTBANK",
        "ソフトバンクモバイル": "SOFTBANK",
        "ドコモ": "DOCOMO",
        "KDDI": "KDDI",
        "ワイモバイル": "YMOBILE"
    ]

    private static let DeviceList = [
        "iPhone3,1": "iPhone 4",
        "iPhone3,2": "iPhone 4",
        "iPhone3,3": "iPhone 4",
        "iPhone4,1": "iPhone 4S",
        "iPhone5,1": "iPhone 5",
        "iPhone5,2": "iPhone 5",
        "iPhone5,3": "iPhone 5C",
        "iPhone5,4": "iPhone 5C",
        "iPhone6,1": "iPhone 5S",
        "iPhone6,2": "iPhone 5S",
        "iPhone7,1": "iPhone 6 Plus",
        "iPhone7,2": "iPhone 6",
        "iPhone8,1": "iPhone 6S",
        "iPhone8,2": "iPhone 6S Plus",
        "iPhone8,4": "iPhone SE",
        "iPhone9,1": "iPhone 7",
        "iPhone9,2": "iPhone 7 Plus",
        "iPhone9,3": "iPhone 7",
        "iPhone9,4": "iPhone 7 Plus",
        "iPhone10,1": "iPhone 8",
        "iPhone10,2": "iPhone 8 Plus",
        "iPhone10,3": "iPhone X",
        "iPhone10,4": "iPhone 8",
        "iPhone10,5": "iPhone 8 Plus",
        "iPhone10,6": "iPhone X",
        "iPad2,1": "iPad 2",
        "iPad2,2": "iPad 2",
        "iPad2,3": "iPad 2",
        "iPad2,4": "iPad 2",
        "iPad2,5": "iPad Mini",
        "iPad2,6": "iPad Mini",
        "iPad2,7": "iPad Mini",
        "iPad3,1": "iPad 3",
        "iPad3,2": "iPad 3",
        "iPad3,3": "iPad 3",
        "iPad3,4": "iPad 4",
        "iPad3,5": "iPad 4",
        "iPad3,6": "iPad 4",
        "iPad4,1": "iPad Air",
        "iPad4,2": "iPad Air",
        "iPad4,3": "iPad Air",
        "iPad4,4": "iPad Mini 2",
        "iPad4,5": "iPad Mini 2",
        "iPad4,6": "iPad Mini 2",
        "iPad4,7": "iPad Mini 3",
        "iPad4,8": "iPad Mini 3",
        "iPad4,9": "iPad Mini 3",
        "iPad5,1": "iPad Mini 4",
        "iPad5,2": "iPad Mini 4",
        "iPad5,3": "iPad Air 2",
        "iPad5,4": "iPad Air 2",
        "iPad6,7": "iPad Pro",
        "iPad6,8": "iPad Pro",
        "iPod5,1": "iPod Touch 5",
        "iPod7,1": "iPod Touch 6",
        "x86_64": "Simulator",
        "i386": "Simulator"
    ]
}
