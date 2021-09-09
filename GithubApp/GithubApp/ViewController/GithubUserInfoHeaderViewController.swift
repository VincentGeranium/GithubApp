//
//  GithubUserInfoHeaderViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/09.
//

import UIKit

class GithubUserInfoHeaderViewController: UIViewController {
    
    let avatarImageView = GithubFollowerAvatarImageView(frame: .zero)
    let usernameLabel = GithubFollowerTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GithubFollowerSecondaryTitleLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel = GithubFollowerSecondaryTitleLabel(fontSize: 18)
    let bioLable = GithubFollowerBodyLabel(textAlignment: .left)
    
    // MARK:-  user object
    var user: User?
    
    // MARK:- Custom Init
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        layoutUI()
    }
    
    // MARK:- to do addSubview all the objects
    private func addSubViews() {
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.addSubview(bioLable)
    }
    
    private func layoutUI() {
        // c.f: what padding is? -> It's the left and right side of screen
        let padding: CGFloat = 20
        
        // c.f: what textPadding is? -> It's the length between image and text label
        let textImagePadding: CGFloat = 12
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        /*
         Discussion: why avatarImageView pinded topAnchor by constant padding?
         Because This VC will filled up to super view.
         To avatarImageView, this VC is the same like Superview.
         That's the reason of did I implement padding to the topAnchor.
         */
        NSLayoutConstraint.activate([
            // 20 point from the top of the view controller
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            // 20 point from the leading of the view controller
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            // Discussion: I want avatarImageView be the square so to do hard code width and height.
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
        ])
        
    }

    
    
    

}
