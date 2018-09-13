//
//  DateExtension.swift
//  Calendar
//
//  Created by Sasha on 12.09.18.
//  Copyright © 2018 Sasha. All rights reserved.
//



import Foundation

extension Date {
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var prevoisMonthDate: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: noon)!
    }
    
    var nextMonthDate: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    func toString(dateFormat format: DateFormatType = .monthAndYear ) -> String {
        let dateFormatter = DateFormatter.dateFormatter(with: format)
        
        return dateFormatter.string(from: self)
    }
    
    func getShortInfo() -> (year: Int,
        month: Int,
        stringMonth: String,
        countDaysInMonth: Int,
        day: Int,
        hours: Int,
        minutes: Int) {
            
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: self)
            let month = calendar.component(.month, from: self)
            let day = calendar.component(.day, from: self)
            let hours = calendar.component(.hour, from: self)
            let minutes = calendar.component(.minute, from: self)
            
            let range = calendar.range(of: .day, in: .month, for: self)!
            let numDays = range.count
            
            let stringMonth = toString(dateFormat: .month)
            return (year, month, stringMonth, numDays, day, hours, minutes)
    }
    
    func getMonthStart() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    func getMonthEnd() -> Date? {
        
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    func getNumberDayOfWeek() -> Int {
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter.dateFormatter(with: .day)
        
        return dateFormatter.string(from: self).capitalized
    }
    
    func dateToFull() -> Date {
        let dateFormatter = DateFormatter.dateFormatter(with: .full)
        let sting = dateFormatter.string(from: self)
        
        return dateFormatter.date(from: sting)!
    }
    
    static func getDate(with dateComponents: DateComponents) -> Date {
        
        return  Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    func getLocaleDate() -> Date {
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        components.hour = self.getShortInfo().hours
        components.minute = self.getShortInfo().minutes
        return Calendar.current.date(from: components)!
    }
    
    static  func getDateFromString(string: String) -> Date {
        
        let dFormatter = DateFormatter.dateFormatter(with: .fullWithSeconds)
        dFormatter.timeZone = TimeZone.current
        dFormatter.locale = Locale.current
        
        return  dFormatter.date(from: string)!
    }
    
    static func convertDateFullStringTo12DateFormat(date dateString: String) -> String {
        
        guard let dateTime =  DateFormatter.dateFormatter(with: .fullWithSeconds).date(from: dateString) else {
            return ""
        }
        
        let time =  DateFormatter.dateFormatter(with: .format12HWithoutSeconds).string(from: dateTime)
        let month =  DateFormatter.dateFormatter(with: .month).string(from: dateTime)
        let shortInfo = dateTime.getShortInfo()
        let dateString = "\(shortInfo.year) \(month) \(shortInfo.day) \(time)"
        
        return  dateString
    }
    
    static func convertDateStringFrom24to12DateFormat(date dateString: String) -> String {
        
        guard let dateTime =  DateFormatter.dateFormatter(with: .format24HWithSeconds).date(from: dateString) else {
            return ""
        }
        
        return  DateFormatter.dateFormatter(with: .format12HWithoutSeconds).string(from: dateTime).lowercased()
    }
    
    static func generateDatesArrayBetweenTwoDates(startDate: Date, endDate: Date) -> [Date]
    {
        var datesArray = [Date]()
        var startDate = startDate
        let calendar = Calendar.current
        
        while startDate <= endDate {
            datesArray.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            
        }
        if !datesArray.contains(endDate) {
            datesArray.append(endDate)
        }
        
        return datesArray
    }
    
}
