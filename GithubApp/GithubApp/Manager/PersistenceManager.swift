//
//  PersistenceManager.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/25.
//

import Foundation

// this enum for the managing user default?
enum PersistenceActionType {
    case add
    case remove
}

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
    
    // not passing the array of follower just one individual follower
    static func update(with favorite: Follower, actionType: PersistenceActionType, completed: @escaping (ErrorMessage?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                /*
                 Discussion: Why did I implement this variable name of 'retrievedFavorites' code?
                 'let favorites' is immutable array but I need to add and delete favorite user function.
                 So, I create variable.
                
                 c.f : Abuot 'var retrievedFavorites'
                 var retrievedFavorites is new array.
                 */
                var retrievedFavorites = favorites
                
                //MARK:- switch based on action type
                switch actionType {
                case .add:
                    /// handle the retrievedFavorites
                        /// 1. check the array -> the user is alread in the array or not
                    guard !retrievedFavorites.contains(favorite) else {
                        completed(.alreadInFavorites)
                        return
                    }
                        /// 2. add user in the favorite.
                    retrievedFavorites.append(favorite)
                case .remove:
                    /// handle the retrievedFavorites
                        /// 1. Bascially need to go through the array in remove all instances where the these followers match
                    /*
                     c.f : About $0
                     $0 is each items as iterating through.
                     In here $0 is Follower objcet
                     */
                    /*
                     Discussion: About 'removeAll(where:)'
                     Removes all the elements that satisfy the given predicate.
                     */
                    retrievedFavorites.removeAll { $0.login == favorite.login }
                }
                
                // update either add or remove and then save again
                
                completed(save(favorites: retrievedFavorites))
            case .failure(let error):
                completed(error)
            }
        }
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
    // MARK:- retrieveFavorites function which for trieving the array.
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
            // Basically if this is nil, that mean noting save anything, kind like first time use.
            // So, don't return error because no favorite ever in there, so I will gonna return empty array.
            // c.f: very first time access this -> empty array of followers.
            completion(.success([]))
            return
        }
        // MARK:- do-catch, try for the decode -> Decode Follower array
        do {
            // create to JSONDecoder
            let decoder = JSONDecoder()
            // try decode it into array of follower accept from favoriteData
            let favorites = try decoder.decode([Follower].self, from: favoriteData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    // MARK:- save(favorites:) function which is for the Save the Array.
    /*
     1. Discussion: Why dose this save function return 'ErrorMessage'?
     Because when saving it that's mean encoding it.
     Retrieving the data that's mean decoding it the data.
     When saving follower array to the userDefault, need to encode the data.
     That's why does this function is return 'ErrorMessage'
     */
    static func save(favorites: [Follower]) -> ErrorMessage? {
        // doing encoding the data
        do {
            let encoder = JSONEncoder()
            let favoritesEncoded = try encoder.encode(favorites)
            // Saving the data in the used default
            defaults.setValue(favoritesEncoded, forKey: Keys.favorites)
            return nil
            // handle the error
        } catch {
            return .unableToFavorite
        }
    }
}
