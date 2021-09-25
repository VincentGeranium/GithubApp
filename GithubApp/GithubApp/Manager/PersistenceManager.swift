//
//  PersistenceManager.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/25.
//

import Foundation

/*
 Discussion: Why did I implement Enumeration not a Structure?
 
 Enumeration(enum) and Structure(struct) have minor difference.
 Struct can initialized empty struct kind like safety thing.
 But enum couldn't initialized empty enum.
 */

enum PersistenceManager {
    // create instance of userDefault.
    static private let defaults = UserDefaults.standard
    
    /*
     c.f: Create Enum to hold are constants for Key
     */
    enum Keys {
        static let favorites = "favorites"
    }
    
    /*
     Discussion: About this function.
     This function doing for retrieve the array.
     This is similrary with network call function, because this function have result type and completion handler.
     And this is the reason of function have result type and completion handler, which is function call failure with error can have to decode.
     */
    /*
     c.f: Save custom object.
     Anytime saving custom object to UserDefaults have to incode and decode get saves the data.
     If just saving Int, String, Boolean somthing super basic like that developer doesn't do that UserDefaults hold those
     no problem.
     But saving custom object just like 'Follower' object. I have to do through this.
     */
    static func retrieveFavorites(completion: @escaping (Result<[Follower], ErrorMessage>) -> Void) {
        /*
         c.f: What is 'forKey'?
         When save something in UserDefault have to give identifier which is a key
         And than that is String.
         */
        // pull favoriteData
        // c.f: 'object(forKey:)' is 'Any?' type. this mean's os doesn't know type. So, have to notice type that use by typecast.
        guard let favoriteData = defaults.object(forKey: Keys.favorites) as? Data else {
            // I will not gonna return Error here
            
        }
        
    }
}
