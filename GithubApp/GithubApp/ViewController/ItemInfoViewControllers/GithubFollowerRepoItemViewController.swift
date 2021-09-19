//
//  GithubFollowerRepoItemViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/14.
//

import Foundation
import UIKit
// c.f: GithubFollowerRepoItemViewController is inheritance that all the logic of GithubFollowerItemInfoViewController
/*
 Discussion: GithubFollowerRepoItemViewController is inheritance that all the logic of GithubFollowerItemInfoViewController
 So, can use all the logic and also make custom logic.
 */
class GithubFollowerRepoItemViewController: GithubFollowerItemInfoViewController {
    
    var users: User?
    
    override init(user: User) {
        super.init(user: user)
        self.users = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // c.f: override viewDidLoad method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems(with: user, vc: self)
    }
    
    private func getUserData(user: User?) throws -> User {
        guard user != nil else {
            throw ErrorMessage.invalidData
        }
        
        guard let userData = user else {
            throw ErrorMessage.unwrapError
        }
        return userData
    }
    
    private func tryingGetUserData(user: User?, vc: GithubFollowerRepoItemViewController) throws -> User {
        var userData: User?
        
        do {
            try userData = vc.getUserData(user: user)
            // implment here -> 오류가 발생하지 않으면 실행할 코드.
        } catch ErrorMessage.invalidData {
            print(ErrorMessage.invalidData)
        } catch ErrorMessage.unwrapError {
            print(ErrorMessage.unwrapError)
        } catch {
            print("\(error)")
        }
        
        guard let userData = userData else { throw ErrorMessage.unwrapError }
        
        return userData
    }
    
    // c.f: implement custom method that configure items
    private func configureItems(with user: User?, vc: GithubFollowerRepoItemViewController) {
        if let userPublicRepos = try? tryingGetUserData(user: user, vc: vc).publicRepos {
            itemInfoViewOne.set(itemInfoType: .repos, withCount: userPublicRepos)
        }
        if let userPublicGists = try? tryingGetUserData(user: user, vc: vc).publicGists {
            itemInfoViewTwo.set(itemInfoType: .gists, withCount: userPublicGists)
        }
        
        //c.f: Setting up the UI very simply because done heavy lifting before
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
    override func actionButtonTapped() {
        guard let user = user else {
            print(ErrorMessage.invalidUsername)
            return
        }
        delegate?.didTapGithubProfile(for: user)
    }
}
