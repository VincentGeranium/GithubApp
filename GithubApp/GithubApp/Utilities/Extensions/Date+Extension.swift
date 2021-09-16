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
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
