//
//  FollowerCell.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/24.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let cellIdentifier: String = "FollowerCell"
    
    // c.f: The .zero cause I gonna just being all this via constraints
    let avatarImageView = GithubFollowerAvatarImageView(frame: .zero)
    let usernameLabel: GithubFollowerTitleLabel = GithubFollowerTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Discussion: What does 'set' function when call it.
     Passing the Follower that from the indexPath and that's gonna be usernameLabel's text
     */
    
    /*
     c.f: Run throught actually happen 'set' function in the FollowerListViewController
     In configuring data source, I was getting the cell, everytime configure the cell
     With the cell.set(follower) -> that's how do I configure cell and come on the screen
     
     c.f: 'set' function's follower paramert is passing the model of Follower.
     Follower model is create by struct and it have 'login' and 'avatarUrl' properties.
     */
    
    func set(follower: Follower) {
        avatarImageView.downloadImage(fromURL: follower.avatarUrl)
        usernameLabel.text = follower.login
    }
    
    private func configure() {
        /*
         Discussion: Separate each objects or not
         From 'GithubFollowerAlertViewController' have 3 objects that titleLabel, bodyMessageLabel and actionButton
         So I create each objects configure functions by separatly.
         But in this case only have two objects.
         So, I think it's not have to create seperatly which configure function.
         If it has lots of items in here, I will create function individually.
         */
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            // MARK:- Setup constraints which is avatarImageView.
            // c.f: All the cell have 'contentView'
            // Top anchor pined 8 point from the contentView top and Leading and Trailing same setup as well
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: followerCellPadding),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: followerCellPadding),
            avatarImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -followerCellPadding),
            
            /*
             Discussion: explain the height constraints
             
             Set the leading and trailing is give to width how wide cells are.
             Construct collection view's width of the cell is gonna be based on how wide screen is.
             Like iPhone SE's screen alot skinner than iPhone 11 pro max.
             So width of the cell can vary.
             "But however always height is equal to the width", if create be square view.
             */
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            // MARK:- Setup constraints which is usernameLabel.
     
            // usernameLabel design pined this to the bottom of the GithubFollowerAvatarImageView.
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: followerCellPadding),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -followerCellPadding),
            /*
             Discussion: Why did I give 20 points of the height anchor constant?
             I passing the usernameLabel fontSize is 16.
             If I may Label height 16 the bottom part of letters would cut off
             Cause the lettes hang down in the alphabet for example like 'y,g,j'
             So, I give litte bit a padding from the baseline.
             This is the reason of the give 20 points to height
             */
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
}
