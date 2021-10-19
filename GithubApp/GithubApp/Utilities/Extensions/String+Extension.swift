//
//  String+Extension.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/16.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        
        // c.f: passing the string
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        /*
         Discussion: About Locale
         This is passing Locale, this could be different depending on where you at in the world.
         And This is passing String also at the identifier.
         
         c.f: en_US_POSIX is common Locale if live in the us
         ko_kr is Korea locale.
         */
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        /*
         Discussion: about timezone.
         The timezone make sure your getting the current time zone
         */
        dateFormatter.timeZone = .current
        
        /*
         Discussion: About dateFormatter.date(from:) is why optional? and why passing 'self'?
         The reason of I passing 'self' cause is extension on a String.
         So, on a String we gonna able to call 'convertToDate'
         The reason this is optional is because the String which target the convert to Date has to match with "yyyy-MM-dd'T'HH:mm:ssZ" this format exactly, If the String is "Morgan" it will be return "nil" in other word can't convert date.
         If I get the String that exactly match with this format which user model 'cratedAt' it will work on the date.
         But it's not work with that format it will be crush.
         
         */
        return dateFormatter.date(from: self)
    }
    
    func convertDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormatTheNewVersion()
    }
}
