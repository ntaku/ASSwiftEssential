import Foundation

// Other Swift Flags に -D DEBUG を追加する
open class Logger {

    open class func d(_ message: String, function: String = #function, file: String = #file) {
        dump("\(message)", function: function, file: file)
    }

    open class func dPrint(_ items: Any...) {
        #if DEBUG
        debugPrint(items)
        #endif
    }

    // Error log
    open class func e(_ error: Error, function: String = #function, file: String = #file) {
        dump("[ERROR]", function: function, file: file)
        dPrint(error)
    }

    fileprivate class func dump(_ message: String, function: String = #function, file: String = #file) {
        #if DEBUG
            var filename = file
            if let match = filename.range(of: "[^/]*$", options: .regularExpression) {
                filename = String(filename[match]).gsub(from: ".swift", to: "")
            }
            print("[\(filename).\(function)] \(message)")
        #endif
    }
}
