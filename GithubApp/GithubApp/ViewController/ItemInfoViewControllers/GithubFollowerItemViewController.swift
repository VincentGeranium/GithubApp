//
//  GithubFollowerItemViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/15.
//

import Foundation
import UIKit

class GithubFollowerItemViewController: GithubFollowerItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        guard let user = user else {
            print(ErrorMessage.invalidUsername)
            return
        }
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(background: .systemGreen, title: "Get Followers")
    }
}
