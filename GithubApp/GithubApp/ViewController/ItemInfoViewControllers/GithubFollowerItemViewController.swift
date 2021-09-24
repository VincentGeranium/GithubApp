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
//        actionButtonTapped() -> Bug 발견. 이것으로 인해 자동으로 버튼이 계속 실행되었다.
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
    
    /*
     이 메소드는 커스텀 버튼의 액션 메소드 즉, 버튼을 눌렀을 때 실행되는 메소드를 오버라이드 한 것이다.
     이 메소드 안에는 버튼이 눌렸을 경우에 실행되는 로직 및 코드를 넣어야 한다.
     나는 이 안에 그런 로직과 코드를 넣고 viewDidLoad에 이 메소드를 다시 implement해서 계속해서 버튼이 자동으로 실행(눌리는)것 과 같은 버그를 발현시켰고 그것을 발견하여 bug를 debugging을 통해 고쳤다.
     
     */
    override func actionButtonTapped() {
        if let userData = users {
            delegate?.didTapGetFollowers(for: userData)
        }
        print("👺Action Button Tapped👺")
//        delegate?.didTapGetFollowers(for: userData)
        // MARK:- delegate setup
//        delegate?.didTapGetFollowers(for: users)
    }
}


