import Foundation

public extension Double {

    /**
     秒数を0:00:00の形式に変換
     */
    func toTimeString() -> String {
        var remained = Int(self + 0.9) // 切り上げ
        let hour = remained / 3600

        remained %= 3600
        let min = remained / 60

        remained %= 60
        let sec = remained

        let time = NSMutableString()
        if hour > 0 {
            time.appendFormat("%d:%02d:%02d", hour, min, sec)
        } else {
            time.appendFormat("%d:%02d", min, sec)
        }
        return time as String
    }
}
