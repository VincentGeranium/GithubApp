//
//  GithubFollowerItemInfoView.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/13.
//

import UIKit
/*
 Discussion: What Items I need?
 1. UIImageView - for the SFSymbol
 2. UILabel - for the 'public repos' that the title
 3. UILabel - for the count
 */
class GithubFollowerItemInfoView: UIView {
    
    // MARK:- Properties
    let symbolImageView: UIImageView = UIImageView()
    let titleLabel: UILabel = GithubFollowerTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel: UILabel = GithubFollowerTitleLabel(textAlignment: .center, fontSize: 14)
    
    // MARK:- Custom init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Configure method
    // Discussion: Layout everything in this method
    private func configure() {
        addSubview(symbolImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        /*
         Discussion: Why did not implement 'translatesAutoresizingMaskIntoConstraints' to both of titleLabel and countLabel?
         Because titleLabel and countLabel are inheritance the 'GithubFollowerTitleLabel' class
         In the 'GithubFollowerTitleLabel' class already defined 'translatesAutoresizingMaskIntoConstraints' by 'false'.
         So, I didn't implement that code.
         */
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        
        /*
         Discussion: Why did I defined symbolImageView contentMode as 'scaleAspectFill'?
         Because any passing in any number of symbols, got the hard for the followers, folder for the repos and basically don't defined contentMode as 'scaleAspectFill'
         The image will not scale aspect fill the a image view.
         */
        symbolImageView.contentMode = .scaleAspectFill
        
        // c.f: I want match the title color, and my title label color is the label color, So I implement label tintColor to symbolImageView.
        symbolImageView.tintColor = .label
        
        // MARK:- Constraints setup the symbolImageView
        NSLayoutConstraint.activate([
            
            /*
             1. Discussion: symbolImageView pined at left by square (20x20)
             2. Dissussion: Why did not defined padding at the symbolImageView?
             Because this view is will reuse so, it will be child view and give padding at parents view controller.
             */
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        // MARK:- Constraints setup the titleLabel
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        // MARK:- Constraints setup the countLabel
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    /*
     Discussion: Why this method is not private?
     Because this method will be using outside of this class
     So, must not to private.
     */
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image = SFSymbols.reposImage
            titleLabel.text = "Public Repos"
        case .gists:
            symbolImageView.image = SFSymbols.gistsImage
            titleLabel.text = "Public Gists"
        case .followers:
            symbolImageView.image = SFSymbols.followersImage
            titleLabel.text = "Followers"
        case .following:
            symbolImageView.image = SFSymbols.followingImage
            titleLabel.text = "Following"
        }
        countLabel.text = String(count)
    }
}
