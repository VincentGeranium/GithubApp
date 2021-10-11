//
//  NetworkManager.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/19.
//

import Foundation
import UIKit

/*
 Discussion: About Network Manager
 
 이곳에는 대표적인 3가지의 network call이 있다.
 
 1. getFollowers
 2. getUserInfo
 3. downloadImage
 */

class NetworkManager {
    //MARK:- Create Singleton instance
    /*
     c.f: Singleton has just one instance for restrict of singleton class.
     
     c.f: What's the meaning of static?
     For example in this class.
     'static' means every NetworkManager will have this variable on it that 'static let shared = NetworkManager()'.
     */
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    //MARK:- private baseURL
    /*
     c.f: About Base URL
     In the network manager typically have base url
     Because working with the API, If not have base url, it's difficult to send and get data many times.
     Base url is seem like start line.
     
     reference : Resources in the REST API in GitHub Docs
     
     All API access is over HTTPS, and accessed from https://api.github.com. All data is sent and received as JSON.
     */
    private let baseURL = "https://api.github.com/users/"
    
    //MARK:- Create cache
    /*
     Discussion: Why did I create cache in NetworkManager?
     Because I want singular cache.
     If I create cache in'FollowerListViewController', Evertime when cell recreate cache will be calling, in other words cache is create many times.
     So, I create singular cache in NetworkManager.
     
     c.f: How to access singular cache?
     Access by shared instance.
     For example 'networkManager.shared.cache'
     */
    
    /*
     Discussion: NSCache
     - NSCache takes in key, value pair
        - It's very similaly with Dictionary
     
     c.f: Why NSCache is takes KeyType by NSString not the String?
     Because NSCache has not String type, NSCache is create when NEXT company
     NSObjects are gonna convert to swift style.
     */
    let cache = NSCache<NSString, UIImage>()
    
    //MARK:- private init
    /*
     c.f: Singleton have private init
     Because Singleton is only one that can call from anywhere.
     */
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    /*
     Discussion: About this function completion handler (@escaping)
     I will explain by this function which is 'getFollowers'
     
     completion handler is call when after called main function.
     
     After successfully call and get follower data from the function, It will return array of follower data.
     But [Follower] it could be error so, create by optional(not gurantee the return the array follower)
     And It can be occur error, so added String in bracket of the escaping.
     Also String value create optional because if all the gose fine it's not to use error, in other words if not occur error, not return String.
     That's why did I create these two things are optional.
     
     */
    
    // MARK: - getFollowersDownToiOS15 (the old version)
    func getFollowersDownToiOS15(for username: String, perpage: Int, page: Int, completion: @escaping(Result<[Follower], ErrorMessage>) -> Void) {
        // c.f: url that end point of API
        let endPoint = baseURL + "\(username)/followers?per_page=\(perpage)&page=\(page)"
        
        /*
         c.f: Convert end point for into URL Object.
         In other words validate endPoint string to URL
         If endPoint dosen't return URL have return Error message.
         So, I used alert and String which String is from completion
         */
        guard let url = URL(string: endPoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        // c.f: dataTask of URLSession is actually get data from url
        // c.f: 'data, response, error' is optional because these can be nil value.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // The Fundamental Basic native way of network call code
            
            /*
             c.f: Actuall what to do in this closure block?
             - Parse the data.
             - Handle the response.
             - Handle the error.
             */
            
            // Handle the error
            // c.f: Error is usually using for internet connect error
            // c.f: If error exist if block will excute
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            /*
             c.f : Same code with 'if let _ = error { }'
             guard error == nil else {
                completion(nil, "Error: This is network error, unable to request.")
                return
             }
             */
            
            // Handle the response
            // c.f: Response is showing the number that status code which is 404, 200, ect.
            /*
             Discussion: Explain of the code
             First check is If response is not nil, go ahead put in as response.
             Secondary check on that if response is not nil let's check that status code on the response
             */
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            /*
             c.f: Explain this code.
             If data is not exist occur Error
             */
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            
            
            /*
             c.f: About Encoder and Decoder can throw the error.
             When throw error using 'do, try, catch' that handle the Error.
             
             c.f: About do - catch block
             Start Parsing the JSON and handle the Error code.
             */
            
            // If data is exist start Parsing the JSON and handle the Error code
            do {
                // try will be here
                
                /*
                 Discussion: About decoder and encoder
                 Decoder is taking the data from the server and decoding it into the object.
                 Encoder is taking the object and converted it to the data.
                 */

                /*
                 c.f:
                 - Convert from snake case to camel case.
                 - key is mean that dictionary, key and value pair.
                 */
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
                // recreate follower objcet.
                /*
                 c.f:
                 - 'try' is 'throw the decoder' in this code.
                 - 'Throws' is meaning that 'throws the error
                 - Decode function's parameter which 'type' is somthing that confirms the Decodable Protocol
                    - That's why I did structure which 'Follower' confirm the 'Codable'
                        - If confirm the 'Codable', Actually confirm the 'Decodable' and 'Encodable'.
                          In other words 'Codable' is combination of 'Decodable' and 'Encodable'.
                 */
                
                /*
                 Dicussion: About this code explain which declare by constant array is the 'followers'
                 Try decode that type is array of 'Follower' and create that array of 'Follower' from 'data' which is validate from this 'getFollowers' block.
                 */
                
                /*
                 c.f: Remember the when 'try' failed
                 If 'try' fail's it's going to throw 'error'
                 And throws the error in the 'catch' block.
                 */
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                // If 'try' fails throw the 'error' and the 'catch block' is the error handle it.
                completion(.failure(.invalidData))
                
                /*
                 Discussion: Error localizedDescription
                 
                 Typically error localized description is for the developer not a user.
                 (some times error localized description show error message that hard to readable for user.)
                 
                 Example Code:
                 completion(nil, error.localizedDescription)
                 */
            }
        }
        // Actuall start network call
        task.resume()
    }
    
    // MARK: - getFollowersUpToiOS15 (the new version)
    
    /*
     Discussion: About code meaning
     async = async way, throws = throw error
     So, 'async throws' means = Throws an error in an asynchronous way.
     
     If I use 'async throws', don't need to use completion handler
     
     and also '-> [Follower]' means success case will return array of Follower
     */
    func getFollowersUpToiOS15(for username: String, page: Int) async throws -> [Follower] {
        #warning("endpoint를 URLComponent를 이용하여 다시 만들어서 사용하자.")
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        /// valid url
        guard let url = URL(string: endpoint) else {
            /// when faliure case
            throw ErrorMessage.invalidUsername
        }
        
        /// URLSession new awaitable method
        /// c.f : (data, respones) is tuple, because the '.data' method  is return (Data, URLResponse) tuple.
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ErrorMessage.invalidResponse
        }
        
        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw ErrorMessage.invalidData
        }
    }
    
    
    
    // MARK: - Get User Info
    func getUserInfo(for username: String, completion: @escaping (Result<User, ErrorMessage>) -> Void) {
        let endPoint = baseURL + "\(username)"
        
        // Convert endPoint which the type of String to URL and unwrapping
        guard let url = URL(string: endPoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        // MARK:- Data Task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error  {
                completion(.failure(.unableToComplete))
                print("Error is occur : \(error)")
                return
            }
            print("Success to pass the error.")
            
            
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            print("Success to pass the Invalid Response error.")
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            print("Success to pass the InvalidData error.")
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                print("😍 \(user)")
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    // MARK:- download Image function
    /*
     1. Discussion: why escaping result which 'UIImage' is optional?
     Because users are couldn't set their own image, so it can be nil.
     This is the reason of the implement that UIImage is optional.
     
     2. Discussion: why @escaping is not using 'Result' type?
     Because If user dosen't have image which mean return nil, I will showing the place holder image.
     So, it's not necessary behavior which is occur Error.
     When using 'Result' type must to return two kind of type 1. success 2. failure
     But in this case I don't need to occur 'Error' or 'failure' case
     Just showing placeholder image is more directly to user.
     */
    func downloadImage(from url: String, completed: @escaping (UIImage?) -> Void) {
        // create cacheKey
        /*
         c.f: explain below code that 'cacheKey'
         
         Which means initialize NSString from the Swift String. It's kind of convert it. and String is passing urlString
         */
        let cacheKey = NSString(string: url)
        
        /*
         Discussion: About this code means.
         
         Checking the image in the cache? if not in the cache, it's going to call the network call.
         If image is in the cache is going to return the image and not make the network call.
         */
        // Purpose of check the cache is image in the cache? or not
        // c.f: Every URL that is tasked image that I download is gonna unique key there
        // c.f: passing 'urlString' is how identify each object in the cache.
        if let image = cache.object(forKey: cacheKey) {
            // complete and pass back the image
            completed(image)
            return
        }
        
        // make sure the url is good
        /*
         Discussion: why implement 'completed(nil)'
         
         Because when I created this function I impleted @escaping paramter which type is '(UIImage?) -> Void'
         So, It can't just return. have to return UIImage or nil
         That's the reason why did I implement 'completed(nil)'.
         */
        guard let url = URL(string: url) else {
            completed(nil)
            return
        }
        
        // network call
        /*
         1. Discussion: Why dose need capture list([weak self]) in the this function?
         
         Because access own cache. when set the objcet into the cache.
         */
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, urlResponse, error in
            guard let self = self,
                  error == nil,
                  let urlResponse = urlResponse as? HTTPURLResponse, urlResponse.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            //MARK:- set the image into the cache
            // In other word capture the image.
            /*
             Discussion: Why did I create cache?
             The Idea is a download image just once, So I creat cache and set the image into the cache.
             If the image in the cache, It's not to download image, Just get cache object.
             But If the image is not in cache, It must download image.
             The donwload image is have cost to OS.
             The performance is lower, If evertime download image.
             */
            // set the object into the cache
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}

