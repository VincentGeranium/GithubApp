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
        try? configureItems()
        actionButtonTapped()
    }
    
    
    
    func getUserData() throws -> User {
        guard let user = users else {
            throw ErrorMessage.invalidUsername
        }
        return user
  
    }
    
    
    private func configureItems() throws {
        do {
            
            let userData = try? getUserData()
            guard let userData = userData else { return }
            itemInfoViewOne.set(itemInfoType: .followers, withCount: userData.followers)
            itemInfoViewTwo.set(itemInfoType: .following, withCount: userData.following)
        } catch ErrorMessage.unwrapError {
            print(ErrorMessage.unwrapError)
        }
        
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        do {
            let userData = try? getUserData()
            guard let userData = userData else { return }
            delegate?.didTapGitHubFollowers(for: userData)
        } catch ErrorMessage.unwrapError {
            print(ErrorMessage.unwrapError)
        }
    }
}
