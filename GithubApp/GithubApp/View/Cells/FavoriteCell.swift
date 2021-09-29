//
//  FavoriteCell.swift
//  GithubApp
//
//  Created by Morgan Kang on 2021/09/29.
//

import UIKit

class FavoriteCell: UITableViewCell {
    // MARK:- Create basic elements of cell
    static let reuseID = "FavoriteCell"
    let avatarImageView: GithubFollowerAvatarImageView = GithubFollowerAvatarImageView(frame: .zero)
    let usernameLabel: GithubFollowerTitleLabel = GithubFollowerTitleLabel(textAlignment: .left, fontSize: 26)
    
    // MARK:- Create initializer
    // c.f: override of tableview's init method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    // c.f: This is storyboard initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Set method
    public func set(favorite: Follower) {
        usernameLabel.text = favorite.login
        
        avatarImageView.dowloadImage(from: favorite.avatarUrl) { result in
            switch result {
            case .success(let success):
                print("get image: \(success)")
            case .failure(let errorMessage):
                print("failed to get image: \(errorMessage)")
            }
        }
    }
    
    // MARK:- Configure method
    // c.f: This method is for configure custom UI
    private func configure() {
        let padding: CGFloat = 12
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        // c.f: tableview have accessory view and accessory type
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
