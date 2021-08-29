//
//  GithubFollowerAvatarImageView.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/24.
//

import UIKit

class GithubFollowerAvatarImageView: UIImageView {
    
    // Placeholder Image
    let placehoderImage = UIImage(named: "avatar-placeholder")
    
    // c.f: In this custom image view, I don't create custom init but create override init with the frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        do {
            try configure()
            print("Success to occur configure method")
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
    //Download Image, cache Image use by network manager
    func dowloadImage(from urlString: String, completion: @escaping (Result<String, ErrorMessage>) -> Void) {
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
        
        // Calling network
        // c.f: this is exactly same with network manager code.
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let strongSelf = self else {
                completion(.failure(ErrorMessage.referenceError))
                return }
            
            if error != nil {
                completion(.failure(ErrorMessage.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(ErrorMessage.invalidResponse))
                return
            }
            
            if response.statusCode != 200 {
                completion(.failure(ErrorMessage.unableToGetResponseCode))
            }
            
            guard let data = data else {
                completion(.failure(ErrorMessage.invalidData))
                return
            }
            
            // get image from data
            guard let image = UIImage(data: data) else {
                completion(.failure(ErrorMessage.invalidData))
                return
            }
            
            // c.f: When update the UI, have to in the main thread
            DispatchQueue.main.async {
                strongSelf.image = image
            }
        }
        // kicks off network call
        task.resume()
    }
}
