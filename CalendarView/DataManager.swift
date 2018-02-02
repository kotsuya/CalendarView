//
//  DataManager.swift
//  CalendarView
//
//  Created by YooSeunghwan on 2018/01/16.
//  Copyright © 2018年 YooSeunghwan. All rights reserved.
//

import Foundation

class DataManager: NSObject {
    var currentMonthOfDates = [Date]()
    var selectedDate = Date()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
    
    func daysAcquisition() -> Int {
        let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth())
        let numberOfWeeks = rangeOfWeeks?.count
        numberOfItems = numberOfWeeks! * daysPerWeek
        return numberOfItems
    }

    func firstDateOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate as Date)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
    }
    
    func dateForCellAtIndexPath(numberOfItems: Int) {
        let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())
        
        for i in 0...numberOfItems {
            let dateComponents = NSDateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay! - 1)
            let date = NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: firstDateOfMonth())
            currentMonthOfDates.append(date!)
        }
    }
    
    func conversionDateFormat(_ indexPath: IndexPath) -> String {
        dateForCellAtIndexPath(numberOfItems: numberOfItems)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: currentMonthOfDates[indexPath.row] as Date)
    }
    
    
    func selectedDateFormat(_ indexPath: IndexPath) -> String {
        dateForCellAtIndexPath(numberOfItems: numberOfItems)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: currentMonthOfDates[indexPath.row] as Date)
    }
    
    func prevMonth(_ date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    
    func nextMonth(_ date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        return selectedDate
    }
    
}

extension Date {
    func monthAgoDate() -> Date {
        let addValue = -1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return calendar.date(byAdding: dateComponents as DateComponents, to: self as Date)!
    }
    
    func monthLaterDate() -> Date {
        let addValue: Int = 1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return calendar.date(byAdding: dateComponents as DateComponents, to: self as Date)!
    }
}
