
import Foundation

// Other Swift Flags に -D DEBUG を追加する
// http://qiita.com/qmihara/items/a6b88b74fe64e1e05ca4

class Logger {

    // Debug log
    class func d(message: String, function: String = #function, file: String = #file) {
        dump("[D] \(message)", function: function, file: file)
    }

    // Error log
    class func e(message: String, function: String = #function, file: String = #file) {
        dump("[E] \(message)", function: function, file: file)
    }

    // Objective-Cからの簡易アクセス用
    class func log(message: String) {
#if DEBUG
        print("\(message)")
#endif
    }
    
    private class func dump(message: String, function: String = #function, file: String = #file) {
#if DEBUG
        var filename = file
        if let match = filename.rangeOfString("[^/]*$", options: .RegularExpressionSearch) {
            filename = filename.substringWithRange(match)
        }
        print("[\(filename):\(function)] \(message)")
#endif
    }
}