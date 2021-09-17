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
    
    // c.f: override viewDidLoad method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    // c.f: implement custom method that configure items
    private func configureItems() {
        // configure GithubFollowerItemInfoViewController
        guard let user = user else {
            print(ErrorMessage.invalidUsername)
            return
        }
        //c.f: Setting up the UI very simply because done heavy lifting before 
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
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
