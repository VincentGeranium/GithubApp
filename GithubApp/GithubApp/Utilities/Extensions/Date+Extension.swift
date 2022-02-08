//
//  Date+Extension.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/16.
//

import Foundation

extension Date {
    /*
     Discussion: If you want to convert to github api 'createAt' data to Date
     The 'createAt' data is 'String' type therefore convert to 'Date' type first.
     And then convert to 'String' that easy to read that user.
     As a result String -> Date -> String.
     */
    
    func convertToMonthYearFormatTheOldVersion() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func convertToMonthYearFormatTheNewVersion() -> String {
        // c.f : the default version of 'formatted code' -> formatted(.dateTime.month().year())
        /*
         Discussion: About .month() and .year()
         It can be has another options.
         So, It could return different style.
         For example, 'formatted(.dateTime.month().year())' the default code is showing like
         "Jul 2015", however, 'formatted(.dateTime.month(.wide).year(.twoDigits))' this code is showing "May 11" It mean's 'May 2011'
         In additional implement just 'formatted()', it will return like '5/14/2011, 10:14 PM'
         */
        if #available(iOS 15.0, *) {
            return formatted(.dateTime.month().year())
        } else {
            return convertToMonthYearFormatTheOldVersion()
        }
    }
}
