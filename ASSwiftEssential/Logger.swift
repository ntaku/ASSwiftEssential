
import Foundation

// Other Swift Flags に -D DEBUG を追加する

public class Logger {

    // Debug log
    class func d(message: String, function: String = #function, file: String = #file) {
        dump("[D] \(message)", function: function, file: file)
    }

    // Error log
    class func e(error: NSError?, function: String = #function, file: String = #file) {
        if let e = error {
            dump("[E] \(e.description)", function: function, file: file)
        }else{
            dump("[E] error is nil", function: function, file: file)
        }
    }
    
    class func dump(message: String, function: String = #function, file: String = #file) {
#if DEBUG
        var filename = file
        if let match = filename.rangeOfString("[^/]*$", options: .RegularExpressionSearch) {
            filename = filename.substringWithRange(match)
        }
        print("[\(filename):\(function)] \(message)")
#endif
    }
}