//
//  NetworkManager.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/19.
//

import Foundation

class NetworkManager {
    /*
     c.f: Singleton has just one instance for restrict of singleton class.
     
     c.f: What's the meaning of static?
     For example in this class.
     'static' means every NetworkManager will have this variable on it that 'static let shared = NetworkManager()'.
     */
    static let shared = NetworkManager()
    
    /*
     c.f: About Base URL
     In the network manager typically have base url
     Because working with the API, If not have base url, it's difficult to send and get data many times.
     Base url is seem like start line.
     
     reference : Resources in the REST API in GitHub Docs
     
     All API access is over HTTPS, and accessed from https://api.github.com. All data is sent and received as JSON.
     */
    let baseURL = "https://api.github.com/"
    /*
     c.f: Singleton have private init
     Because Singleton is only one that can call from anywhere.
     */
    private init() {}
    
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
    
    func getFollowers(for username: String, perpage: Int, page: Int, completion: @escaping([Follower]?, String?) -> Void) {
        // c.f: url that end point of API
        let endPoint = baseURL + "/users/\(username)/followers?per_page=\(perpage)&page=\(page)"
        
        /*
         c.f: Convert end point for into URL Object.
         In other words validate endPoint string to URL
         If endPoint dosen't return URL have return Error message.
         So, I used alert and String which String is from completion
         */
        guard let url = URL(string: endPoint) else {
            completion(nil, "Error: This username created an invalid request.")
            return
        }
        //c.f: dataTask of URLSession is actually get data from url
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
            if let _ = error {
                completion(nil, "Error: This is network error, unable to request.")
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
                completion(nil, "Error: Invalid response from the server.")
                return
            }
            
            
            
        }
        
        // Actuall start network call
        task.resume()
    }
}
