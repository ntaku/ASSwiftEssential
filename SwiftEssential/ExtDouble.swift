import Foundation

public extension Double {

    /**
     秒数を0:00:00の形式に変換
     */
    public func toTimeString() -> String {
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

    /**
     秒数を00:00.00の形式に変換（最大99:59.99）
     */
    public func toMsecTimeString() -> String {
        var remained = self

        let hour = Int(remained / 3600.0)
        remained -= Double(hour * 3600)

        var min = Int(remained / 60.0)
        remained -= Double(min * 60)

        var sec = Int(remained)
        remained -= Double(sec)

        var msec = Int(remained * 100)

        // 99.99.99が上限
        min += hour * 60
        if min > 99 {
            min = 99
            sec = 59
            msec = 99
        }

        let time = NSMutableString()
        time.appendFormat("%02d:%02d.%02d", min, sec, msec)
        return time as String
    }
}
