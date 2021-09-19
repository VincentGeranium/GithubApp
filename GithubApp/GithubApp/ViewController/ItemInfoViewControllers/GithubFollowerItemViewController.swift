//
//  GithubFollowerItemViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/15.
//

import Foundation
import UIKit

class GithubFollowerItemViewController: GithubFollowerItemInfoViewController {
    var users: User?
    
    
    
    override init(user: User) {
        super.init(user: user)
        self.users = user
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems(with: users)
        actionButtonTapped()
    }
    
    func getUserData(user: User?) throws -> User {
        guard user != nil else {
            print(ErrorMessage.invalidData)
            throw ErrorMessage.invalidData
        }

        guard let userData = user else {
            print(ErrorMessage.unwrapError)
            throw ErrorMessage.unwrapError
        }
        return userData
    }

    private func configureItems(with user: User?) {
        if let userFollowing = try? getUserData(user: user).following {
            itemInfoViewTwo.set(itemInfoType: .following, withCount: userFollowing)
        }
        if let userFollower = try? getUserData(user: user).followers {
            itemInfoViewOne.set(itemInfoType: .followers, withCount: userFollower)
        }
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        let userData = try? getUserData(user: users)
        guard let userData = userData else { return }
        delegate?.didTapGitHubFollowers(for: userData)
    }
}


