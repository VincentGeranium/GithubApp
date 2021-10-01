//
//  GithubFollowerSecondaryTitleLabel.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/09.
//

import UIKit

class GithubFollowerSecondaryTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Custom init
    /*
     Discussion: Why did not passnated textAliment from initializer?
     Because text aliment always be the left.
     */
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        
    }
    
    // MARK:- UILable configure method
    private func configure() {
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
