//
//  GithubFollowerEmptyStateView.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/05.
//

import UIKit

class GithubFollowerEmptyStateView: UIView {
    
    //MARK:- setup properties
    let messageLabel: GithubFollowerTitleLabel = GithubFollowerTitleLabel(textAlignment: .center, fontSize: 28)
    
    let logoImageView: UIImageView = UIImageView()
    
    // setup typical init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- convenience init
    init(message: String) {
        super.init(frame: .zero)
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
        setupMessageLabel()
        setupLogoImageView()
        
    }
    
    // MARK:- setupMessageLabel function
    private func setupMessageLabel() {
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
        
        
        NSLayoutConstraint.activate([
            /* Discussion: About constant point which Center Y anchor.
             Give -150 point to constant which center Y anchor that means moving it up 150 point from the center.
             In other words center vertically and then shift up a little bit
             */
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
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
    // MARK:- setupLogoImageView function
    private func setupLogoImageView() -> Void {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)
        
        #warning("Test Guard state")
        logoImageView.image = UIImage(named: AssetImage.assetEmptyImage.rawValue)
        
        guard logoImageView.image != nil else {
            logoImageView.image = UIImage(named: AssetImage.errorSystemImage.rawValue)
            return
        }
        
        NSLayoutConstraint.activate([
            // c.f: this code means 30% larager then the actual width of the screen
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40),
        ])
        
    }
}
