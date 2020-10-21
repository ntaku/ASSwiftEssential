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
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            return true
        }
        return false
    }

    @objc public static func isPad() -> Bool {
        return UIScreen.main.traitCollection.userInterfaceIdiom == .pad
    }

    // 横Compact, 縦Regular の状態かどうか (iPhoneとiPadのマルチタスク時に該当)
    @objc public static func isSizeClass_wC_hR(viewController vc: UIViewController) -> Bool {
        let hC = UITraitCollection(horizontalSizeClass: .compact)
        let vR = UITraitCollection(verticalSizeClass: .regular)

        if vc.traitCollection.containsTraits(in: hC) {
            if vc.traitCollection.containsTraits(in: vR) {
                return true
            }
        }
        return false
    }

    // 横Regular, 縦Regular の状態かどうか
    @objc public static func isSizeClass_wR_hR(viewController vc: UIViewController) -> Bool {
        let hR = UITraitCollection(horizontalSizeClass: .regular)
        let vR = UITraitCollection(verticalSizeClass: .regular)

        if vc.traitCollection.containsTraits(in: hR) {
            if vc.traitCollection.containsTraits(in: vR) {
                return true
            }
        }
        return false
    }

    // iPadがマルチタスク状態かどうか（w:R, h:Rの解像度が複数存在する）
    @objc public static func isSizeClass_wR_hR_Full(viewController vc: UIViewController) -> Bool {
        if isSizeClass_wR_hR(viewController: vc) {
            if UIScreen.main.bounds.size.width == vc.view.frame.size.width {
                return true
            }
        }
        return false
    }

    private static let CarrierList = [
        "ソフトバンク":       "SOFTBANK",
        "ソフトバンクモバイル": "SOFTBANK",
        "ドコモ":            "DOCOMO",
        "KDDI":             "KDDI",
        "ワイモバイル":       "YMOBILE"
    ]

    // https://gist.github.com/adamawolf/3048717
    // https://gist.github.com/pschmidtboeing/0e6f5f4090089f3d01a7c52a89709d1e
    private static let DeviceList = [
        "i386" : "iOS Simulator 32-bit",
        "x86_64" : "iOS Simulator 64-bit",

        "iPhone1,1" : "iPhone 1st Gen",
        "iPhone1,2" : "iPhone 3G 2nd Gen",
        "iPhone2,1" : "iPhone 3GS 3rd Gen",
        "iPhone3,1" : "iPhone 4",
        "iPhone3,2" : "iPhone 4 (GSM) Rev A",
        "iPhone3,3" : "iPhone 4 (CDMA)",
        "iPhone4,1" : "iPhone 4s",
        "iPhone5,1" : "iPhone 5 (GSM)",
        "iPhone5,2" : "iPhone 5 (CDMA+LTE)",
        "iPhone5,3" : "iPhone 5c (GSM)",
        "iPhone5,4" : "iPhone 5c (Global)",
        "iPhone6,1" : "iPhone 5s (GSM)",
        "iPhone6,2" : "iPhone 5s (Global)",
        "iPhone7,1" : "iPhone 6 Plus",
        "iPhone7,2" : "iPhone 6",
        "iPhone8,1" : "iPhone 6s",
        "iPhone8,2" : "iPhone 6s Plus",
        "iPhone8,4" : "iPhone SE",
        "iPhone9,1" : "iPhone 7",
        "iPhone9,2" : "iPhone 7 Plus",
        "iPhone9,3" : "iPhone 7 (no CDMA)",
        "iPhone9,4" : "iPhone 7 Plus (no CDMA)",
        "iPhone10,1" : "iPhone 8",
        "iPhone10,4" : "iPhone 8 (no CDMA)",
        "iPhone10,2" : "iPhone 8 Plus",
        "iPhone10,5" : "iPhone 8 Plus (no CDMA)",
        "iPhone10,3" : "iPhone X",
        "iPhone10,6" : "iPhone X (no CDMA)",
        "iPhone11,2" : "iPhone Xs",
        "iPhone11,4" : "iPhone Xs Max (China)",
        "iPhone11,6" : "iPhone Xs Max",
        "iPhone11,8" : "iPhone XR",
        "iPhone12,1" : "iPhone 11",
        "iPhone12,3" : "iPhone 11 Pro",
        "iPhone12,5" : "iPhone 11 Pro Max",
        "iPhone12,8" : "iPhone SE 2nd Gen",
        "iPhone13,1" : "iPhone 12 mini",
        "iPhone13,2" : "iPhone 12",
        "iPhone13,3" : "iPhone 12 Pro",
        "iPhone13,4" : "iPhone 12 Pro Max",

        "iPod1,1" : "iPod 1st Gen",
        "iPod2,1" : "iPod 2nd Gen",
        "iPod3,1" : "iPod 3rd Gen",
        "iPod4,1" : "iPod 4th Gen",
        "iPod5,1" : "iPod 5th Gen",
        "iPod7,1" : "iPod 6th Gen",
        "iPod9,1" : "iPod 7th Gen",

        "iPad1,1" : "iPad 1st Gen (WiFi)",
        "iPad1,2" : "iPad 1st Gen (3G)",
        "iPad2,1" : "iPad 2nd Gen (WiFi)",
        "iPad2,2" : "iPad 2nd Gen (GSM)",
        "iPad2,3" : "iPad 2nd Gen (CDMA)",
        "iPad2,4" : "iPad 2nd Gen New Revision",
        "iPad2,5" : "iPad mini 1st Gen (WiFi)",
        "iPad2,6" : "iPad mini 1st Gen (GSM+LTE)",
        "iPad2,7" : "iPad mini 1st Gen (CDMA+LTE)",
        "iPad3,1" : "iPad 3rd Gen (WiFi)",
        "iPad3,2" : "iPad 3rd Gen (CDMA)",
        "iPad3,3" : "iPad 3rd Gen (GSM)",
        "iPad3,4" : "iPad 4th Gen (WiFi)",
        "iPad3,5" : "iPad 4th Gen (GSM+LTE)",
        "iPad3,6" : "iPad 4th Gen (CDMA+LTE)",
        "iPad4,1" : "iPad Air 1st Gen (WiFi)",
        "iPad4,2" : "iPad Air 1st Gen (GSM+CDMA)",
        "iPad4,3" : "iPad Air 1st Gen (China)",
        "iPad4,4" : "iPad mini 2nd Gen (WiFi)",
        "iPad4,5" : "iPad mini 2nd Gen (WiFi+Cellular)",
        "iPad4,6" : "iPad mini 2nd Gen (China)",
        "iPad4,7" : "iPad mini 3rd Gen (WiFi)",
        "iPad4,8" : "iPad mini 3rd Gen (WiFi+Cellular)",
        "iPad4,9" : "iPad mini 3rd Gen (China)",
        "iPad5,1" : "iPad mini 4th Gen (WiFi)",
        "iPad5,2" : "iPad mini 4th Gen (WiFi+Cellular)",
        "iPad5,3" : "iPad Air 2 (WiFi)",
        "iPad5,4" : "iPad Air 2 (WiFi+Cellular)",
        "iPad6,3" : "iPad Pro 1st Gen (9.7 inch, WiFi)",
        "iPad6,4" : "iPad Pro 1st Gen (9.7 inch, WiFi+Cellular)",
        "iPad6,7" : "iPad Pro 1st Gen (12.9 inch, WiFi)",
        "iPad6,8" : "iPad Pro 1st Gen (12.9 inch, WiFi+Cellular)",
        "iPad6,11" : "iPad 5th Gen (WiFi)",
        "iPad6,12" : "iPad 5th Gen (WiFi+Cellular)",
        "iPad7,1" : "iPad Pro 2nd Gen (12.9 inch, WiFi)",
        "iPad7,2" : "iPad Pro 2nd Gen (12.9 inch, WiFi+Cellular)",
        "iPad7,3" : "iPad Pro 2nd Gen (10.5 inch, WiFi)",
        "iPad7,4" : "iPad Pro 2nd Gen (10.5 inch, WiFi+Cellular)",
        "iPad7,5" : "iPad 6th Gen (WiFi)",
        "iPad7,6" : "iPad 6th Gen (WiFi+Cellular)",
        "iPad8,1" : "iPad Pro 3rd Gen (11 inch, WiFi)",
        "iPad8,2" : "iPad Pro 3rd Gen (11 inch, WiFi, 1TB)",
        "iPad8,3" : "iPad Pro 3rd Gen (11 inch, WiFi+Cellular)",
        "iPad8,4" : "iPad Pro 3rd Gen (11 inch, WiFi+Cellular, 1TB)",
        "iPad8,5" : "iPad Pro 3rd Gen (12.9 inch, WiFi)",
        "iPad8,6" : "iPad Pro 3rd Gen (12.9 inch, WiFi, 1TB)",
        "iPad8,7" : "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)",
        "iPad8,8" : "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular, 1TB)",
        "iPad11,1" : "iPad mini 5th Gen (WiFi)",
        "iPad11,2" : "iPad mini 5th Gen (WiFi+Cellular)",
        "iPad11,3" : "iPad Air 3rd Gen (WiFi)",
        "iPad11,4" : "iPad Air 3rd Gen (WiFi+Cellular)",
        "iPad7,11" : "iPad 7th Gen (WiFi)",
        "iPad7,12" : "iPad 7th Gen (WiFi+Cellular)",
        "iPad8,9" : "iPad Pro 4th Gen (11 inch, WiFi)",
        "iPad8,10" : "iPad Pro 4th Gen (11 inch, WiFi+Cellular)",
        "iPad8,11" : "iPad Pro 4th Gen (12.9 inch, WiFi)",
        "iPad8,12" : "iPad Pro 4th Gen (12.9 inch, WiFi+Cellular)",
        "iPad11,6" : "iPad 8th Gen (WiFi)",
        "iPad11,7" : "iPad 8th Gen (WiFi+Cellular)",
        "iPad13,1" : "iPad Air 4th Gen (WiFi)",
        "iPad13,2" : "iPad Air 4th Gen (WiFi+Cellular)",

        "Watch1,1" : "Apple Watch 1st Gen 38mm case",
        "Watch1,2" : "Apple Watch 1st Gen 42mm case",
        "Watch2,6" : "Apple Watch Series 1 38mm case",
        "Watch2,7" : "Apple Watch Series 1 42mm case",
        "Watch2,3" : "Apple Watch Series 2 38mm case",
        "Watch2,4" : "Apple Watch Series 2 42mm case",
        "Watch3,1" : "Apple Watch Series 3 38mm case (GPS+Cellular)",
        "Watch3,2" : "Apple Watch Series 3 42mm case (GPS+Cellular)",
        "Watch3,3" : "Apple Watch Series 3 38mm case (GPS)",
        "Watch3,4" : "Apple Watch Series 3 42mm case (GPS)",
        "Watch4,1" : "Apple Watch Series 4 40mm case (GPS)",
        "Watch4,2" : "Apple Watch Series 4 44mm case (GPS)",
        "Watch4,3" : "Apple Watch Series 4 40mm case (GPS+Cellular)",
        "Watch4,4" : "Apple Watch Series 4 44mm case (GPS+Cellular)",
        "Watch5,1" : "Apple Watch Series 5 40mm case (GPS)",
        "Watch5,2" : "Apple Watch Series 5 44mm case (GPS)",
        "Watch5,3" : "Apple Watch Series 5 40mm case (GPS+Cellular)",
        "Watch5,4" : "Apple Watch Series 5 44mm case (GPS+Cellular)",
        "Watch6,1" : "Apple Watch Series 6 40mm case (GPS)",
        "Watch6,2" : "Apple Watch Series 6 44mm case (GPS)",
        "Watch6,3" : "Apple Watch Series 6 40mm case (GPS+Cellular)",
        "Watch6,4" : "Apple Watch Series 6 44mm case (GPS+Cellular)",
        "Watch5,9" : "Apple Watch SE 40mm case (GPS)",
        "Watch5,10" : "Apple Watch SE 44mm case (GPS)",
        "Watch5,11" : "Apple Watch SE 40mm case (GPS+Cellular)",
        "Watch5,12" : "Apple Watch SE 44mm case (GPS+Cellular)"
    ]
}
