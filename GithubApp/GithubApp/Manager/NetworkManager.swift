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
        // url that end point of API
        let endPoint = baseURL + "/users/\(username)/followers?per_page=\(perpage)&page=\(page)"
        
        //
    }
}
