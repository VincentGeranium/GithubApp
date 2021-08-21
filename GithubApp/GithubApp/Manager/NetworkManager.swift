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
    let baseURL = "https://api.github.com/users/"
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
        let endPoint = baseURL + "\(username)/followers?per_page=\(perpage)&page=\(page)"
        
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
            
            /*
             c.f: Explain this code.
             If data is not exist occur Error
             */
            guard let data = data else {
                completion(nil, "Error: The data received from the server was invalid.")
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
                completion(followers, nil)
            } catch {
                // If 'try' fails throw the 'error' and the 'catch block' is the error handle it.
                completion(nil, "Decode Error: The data recived from the server was invalid.")
                
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
}
