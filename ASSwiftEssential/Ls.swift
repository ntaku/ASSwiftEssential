
import Foundation

class Ls {
    
    // Localizableで定義されていなければ、LibLocalizableの定義を利用
    class func key(name: String) -> String {
        let libString = NSBundle.mainBundle().localizedStringForKey(name, value: name, table: "LibLocalizable")
        return NSBundle.mainBundle().localizedStringForKey(name, value: libString, table: "Localizable")
    }    
}
