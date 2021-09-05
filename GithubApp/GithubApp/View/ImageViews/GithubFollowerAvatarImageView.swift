//
//  GithubFollowerAvatarImageView.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/24.
//

import UIKit

class GithubFollowerAvatarImageView: UIImageView {
    
    //MARK:- Create cache instance
    let cache = NetworkManager.shared.cache
    
    // Placeholder Image
    let placehoderImage = UIImage(named: "avatar-placeholder")
    
    // c.f: In this custom image view, I don't create custom init but create override init with the frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        do {
            try configure()
            print("Success to excute 'configure method'")
        } catch {
            print("\(ErrorMessage.unableToOccurMethod.rawValue)")
        }
    }
    
    // c.f: This is storyboard initializer.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() throws {
        // c.f: when make layer's corner rounded use cornerRadius.
        layer.cornerRadius = 10
        
        /*
         Discussion: About clipsToBounds
         
         When put the image in the 'UIImageView', have to clipsToBounds.
         Which clipsToBounds is order to that the image corner radius.
         The reason of image have to clipsToBounds is If UIImageView already get the cornerRadius, otherwise the Image dosen't have clipsToBounds, the image is not round.
         In other words the image view is rounde but image corner is sharpe.
         */
        clipsToBounds = true
        
        
            // c.f: Set the placeholder Image for default image.
        guard let placehoderImage = placehoderImage else {
            throw ErrorMessage.invalidAssetImage
        }
        
        image = placehoderImage
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK:- dowloadImage가 이곳에 위치한 이유
    /*
     Discussion: 'dowloadImage' 이 NetworkManager가 아닌 GithubFollowerAvatarImageView에 위치한 이유
     NetworkManager에 위치했을 경우 보다 조금 더 직관적이라고 생각하기 때문에, 원래의 코드라면 downloadImage function은
     completion이 없다.
     즉, error handling을 안한다는 뜻이다.
     아래에 설명했다시피 error handling을 안하는 이유는 error이 발생했을 경우 placeHolder image를 avatar imagview에 보여지게
     하기 때문이다 placeHolder image가 보인다면 따로 error을 pop up 시키는 것 보다 직관적으로 알 수 있기 때문이다.
     다시말해, 이미 placeHolder image로서 암묵적인 error handling을 하게 되므로 completion 은 없다.
     그렇기 때문에 굳이 error handling 을 안하는데 NetworkManager에 위치하는 것 보다 직접 이 vc 내부에 위치하는 것이
     알맞다고 생각햇기 때문이다.
     만약 아래와 같이 completion이 있다면 (error을 handling 하려 한다면) NetworkManager에 위치하는 것이 더 알맞다.
     */
    
    //Download Image, cache Image use by network manager
    func dowloadImage(from urlString: String, completion: @escaping (Result<String, ErrorMessage>) -> Void) {
        //MARK:- Convert String type to NSString type
        /*
         c.f: explain below code that 'cacheKey'
         
         Which means initialize NSString from the Swift String. It's kind of convert it. and String is passing urlString
         */
        let cacheKey = NSString(string: urlString)
        
        
        //MARK:- Check the cache
        // Purpose of check the cache is image in the cache? or not
        // c.f: Every URL that is tasked image that I download is gonna unique key there
        // c.f: passing 'urlString' is how identify each object in the cache.
        if let image = cache.object(forKey: cacheKey) {
            self.image  = image
            
            /*
             Discussion: Why did I implment 'return'?
             Because the down below code is for avatar image is nil
             In other word that code have to excute when can't get image from cache object.
             That't the means is the image what I want to showing that not captured.
             So, If cached image I will asign the image or not I will get image from url.
             */
            return
        }
        
        
        
        /*
         Discussion: Why dose not handle error in this function?
         
         1. Because I used placeholder image that for empty avatar image.
         If the user's avatar image is empty or occur the error of the network, the placeholder image is showing.
         Which is mean that showing placeholder is occur error.
         So, not have to error handling in here.
         
         2. This functino is call when evertime to 'GithubFollowerAvatarImageView' shows up.
         Which every time new cells comes on screen, that collection view scroll down and every time new cell comes in.
         It's means if error occur, have to pops up alert when every new cell comes in the screen.
         In other word error is pops alot that's not to good at exprience to user and it have alot of cost to divice.
         
         - I used placeholder image to convey error indirectly.
         - Showing placeholder image is good rather then bothering uesr because pops up error alert.
            - using that convey to message.
         */
        
        // get url
        guard let url = URL(string: urlString) else {
            completion(.failure(ErrorMessage.unableToGetURL))
            return }
        completion(.success("Success to get url"))
        
        // MARK:- Network call
        // c.f: this is exactly same with network manager code.
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            // MARK:- Basic Error Checking
            // Handling all the Error
            guard let self = self else {
                completion(.failure(ErrorMessage.unwrapError))
                return }
            completion(.success("Success to unwrap self"))
            
            if error != nil {
                completion(.failure(ErrorMessage.unableToComplete))
                return
            }
            completion(.success("Error is not occur"))
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(ErrorMessage.invalidResponse))
                return
            }
            
            if response.statusCode != 200 {
                completion(.failure(ErrorMessage.unableToGetResponseCode))
            }
            
            completion(.success("Success to get response which code is 200."))
            
            guard let data = data else {
                completion(.failure(ErrorMessage.unwrapError))
                return
            }
            
            completion(.success("Success to unwrap data"))
            
            // MARK:- get the image
            // get image from data
            guard let image = UIImage(data: data) else {
                completion(.failure(ErrorMessage.unableToConvert))
                return
            }
            
            completion(.success("Success to convert from data to image."))
            
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
            self.cache.setObject(image, forKey: cacheKey)
            
            // MARK:- Setting the image.
            // c.f: When update the UI, have to in the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }
        // kicks off network call
        task.resume()
    }
}
