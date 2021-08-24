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

}
