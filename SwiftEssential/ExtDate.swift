
import Foundation

public extension NSDate {

    public var startOfDay: NSDate {
        let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        return cal.startOfDayForDate(self)
    }

    public var endOfDay: NSDate {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        return cal.dateByAddingComponents(components, toDate: startOfDay, options: NSCalendarOptions())!
    }

    public func isSame(date: NSDate) -> Bool {
        let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        return cal.isDate(self, inSameDayAsDate: date)
    }
}