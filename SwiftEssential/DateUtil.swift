import Foundation

open class DateUtil {

    // y/m/d -> Date
    open static func date(year: Int, month: Int, day: Int) -> Date {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = 0
        c.minute = 0
        c.second = 0
        return Calendar.init(identifier: .gregorian).date(from: c)!
    }

    // Date -> y/m/d
    open static func component(from date: Date) -> DateComponents {
        let cal = Calendar.init(identifier: .gregorian)
        return cal.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear, .weekOfMonth], from: date)
    }

    // format string
    open static func formatString(date: Date, format: String = "yyyy/MM/dd hh:mm:ss") -> String {
        let formatter = DateFormatter()
        if let langId = Locale.preferredLanguages.first {
            formatter.locale = Locale.init(identifier: langId)
        }
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    open static func weekdayName(date: Date, shortStyle: Bool = true) -> String {
        let cal = Calendar.init(identifier: .gregorian)
        let formatter = DateFormatter()

        let components = cal.dateComponents([.weekday], from: date)
        let weekday = components.weekday ?? 0

        if shortStyle {
            if weekday < formatter.shortWeekdaySymbols.count {
                return formatter.shortWeekdaySymbols[weekday]
            }
        }
        if weekday < formatter.weekdaySymbols.count {
            return formatter.weekdaySymbols[weekday]
        }
        return ""
    }
}
