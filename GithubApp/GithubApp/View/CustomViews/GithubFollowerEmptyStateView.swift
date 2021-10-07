//
//  GithubFollowerEmptyStateView.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/05.
//

import UIKit

/*
 Discussion: Have to know when reuse this GithubFollowerEmptyStateView
 When I create this view, I configure the objects are pinded at safeArea which label and imageView.
 So, I have to think about that when reuse this class, In other words when configure the frame of this view
 where from other view.
 Because I already pinded safeArea and design in this class.
 */

class GithubFollowerEmptyStateView: UIView {
    
    //MARK:- setup properties
    let messageLabel: GithubFollowerTitleLabel = GithubFollowerTitleLabel(textAlignment: .center, fontSize: 28)
    
    var logoImageView: UIImageView = UIImageView()
    
    // setup typical init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- convenience init
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
        configures()
    }
    
    // MARK:- configure function
    /*
     c.f: What's the purpose of the configure function?
     How gonna configure whole this GithubFollowerEmptyStateView
     */
    private func configures() {
        
        /*
         Discussion: What are needs in this view?
         In this view needs two things
         1. label that show message for user.
         2. imageView that decorate the view.
         */
        configureMessageLabel()
        configureLogoImageView()
        
    }
    
    // MARK:- Configure MessageLabel function
    private func configureMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        /*
         Discussion: Why did I implement 'numberOfLines'?
         Because 'messageLabel' is only for show infomation that "this user haven't follower"
         So, I know already how many lines in label and screen.
         That's the reason of implement this 'numberOfLines'
         */
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        // MARK:- UI Code devide with DevideTypes.
        // c.f: This code means if DeviceTypes.isiPhoneSE or isiPhone8Zoomed is true, centerYConstant is -50 otherwise false -150.
        let centerYConstant: CGFloat = DeviceTypes.isiPhoneSE2 || DeviceTypes.isiPhone8Zoomed ? -80 : -150
        
        NSLayoutConstraint.activate([
            /* Discussion: About constant point which Center Y anchor.
             Give -150 point to constant which center Y anchor that means moving it up 150 point from the center.
             In other words center vertically and then shift up a little bit
             */
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: centerYConstant),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            /*
             Discussion: Why did I hard coding the height ?
             I will passing the message which is not dynamic.
             I know exactly what does this label going to say, It jsut only three lines.
             So, I did hard coding the height.
             */
            messageLabel.heightAnchor.constraint(equalToConstant: 200),

        ])
    }
    // MARK:- Configure LogoImageView function
    private func configureLogoImageView() -> Void {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)
        
        if let backgroundImage = ImageResource.emptyStateLogo {
            logoImageView.image = backgroundImage
            print("🎯ImageResource.emptyStateLogo is not nil")
        } else if let errorSystemImage = ImageResource.errorSystemImage {
            logoImageView.image = errorSystemImage
            print("🎯ImageResource.emptyStateLogo is nil")
            print("🎯ImageResource.errorSystemImage is not nil")
        } else {
            print(ErrorMessage.unwrapError)
            print("🎯both image resources is nil")
        }
        // MARK:- UI Code devide with DevideTypes.
        // c.f: This code means if DeviceTypes.isiPhoneSE or isiPhone8Zoomed is true, centerYConstant is -50 otherwise false -150.
        let bottomConstant: CGFloat = DeviceTypes.isiPhoneSE2 || DeviceTypes.isiPhone8Zoomed ? 80 : 50
        
        NSLayoutConstraint.activate([
            // c.f: this code means 30% larager then the actual width of the screen
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 240),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomConstant)
        ])
        
    }
}
