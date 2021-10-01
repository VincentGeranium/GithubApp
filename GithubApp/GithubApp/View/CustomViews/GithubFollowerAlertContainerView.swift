//
//  GithubFollowerAlertContainerView.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/13.
//

import UIKit
/*
 추후에 GithubFollowerAlertViewController 내에 정의된 containerView를 따로 만들기.
 */
class GithubFollowerAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        // Breaking down cornerRadius and border
        layer.cornerRadius = 16
        /*
         Discussion: Why did I give border width and color that white to container view
         The reason is the iOS is two kind of display which is 'dark-mode' and 'light-mode'
         When user set divice to light mode the border can't see because border color is 'white'
         Otherwise user set the divice to the dark mode, user can see alert's border line.
         Because it have two point of width and color is white.
         */
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
