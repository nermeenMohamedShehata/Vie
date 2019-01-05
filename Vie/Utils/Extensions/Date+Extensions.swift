//
//  Date+Extensions.swift
//  Joi
//
//  Created by Meseery on 9/18/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import Foundation

extension Date {
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    var monthAndYear:String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM y"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    var dateAndTime:String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    var date:String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    var time:String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }

    func generateDates(startDate :Date?, addbyUnit:Calendar.Component, value : Int) -> [Date]{
        let calendar = Calendar.autoupdatingCurrent
        var datesArray =  [Date] ()
        if let initalDate = startDate {
            datesArray.append(initalDate)
        }
        for i in 0 ... value {
            if let newDate = calendar.date(byAdding: addbyUnit, value: i + 1, to: startDate!) {
                datesArray.append(newDate)
            }
        }
        
        return datesArray
    }
    
}

extension Date {
    var hour: Int {
        return (Calendar.current as NSCalendar).component(.hour, from: self)
    }
    
    var minute: Int {
        return (Calendar.current as NSCalendar).component(.minute, from: self)
    }
    
    var second: Int {
        return (Calendar.current as NSCalendar).component(.second, from: self)
    }
    
    var year: Int {
        return (Calendar.current as NSCalendar).component(.year, from: self)
    }
    
    var month: Int {
        return (Calendar.current as NSCalendar).component(.month, from: self)
    }
    
    var day: Int {
        return (Calendar.current as NSCalendar).component(.day, from: self)
    }
    
    var weekday: Int {
        return (Calendar.current as NSCalendar).component(.weekday, from: self)
    }
}


