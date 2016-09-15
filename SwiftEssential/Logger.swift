
import Foundation

// Other Swift Flags に -D DEBUG を追加する

open class Logger {

    // Debug log
    open class func d(_ message: String, function: String = #function, file: String = #file) {
        dump("[D] \(message)", function: function, file: file)
    }

    // Error log
    open class func e(_ error: NSError?, function: String = #function, file: String = #file) {
        if let e = error {
            dump("[E] \(e.description)", function: function, file: file)
        }else{
            dump("[E] error is nil", function: function, file: file)
        }
    }

    fileprivate class func dump(_ message: String, function: String = #function, file: String = #file) {
        #if DEBUG
            var filename = file
            if let match = filename.range(of: "[^/]*$", options: .regularExpression) {
                filename = filename.substring(with: match)
            }
            print("[\(filename):\(function)] \(message)")
        #endif
    }
}
