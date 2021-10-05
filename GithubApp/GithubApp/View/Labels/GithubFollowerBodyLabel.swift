//
//  GithubFollowerBodyLabel.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/13.
//

import UIKit

class GithubFollowerBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        /*
         c.f: About difference custom init parameter between 'GithubFollowerTitleLabel' and 'GithubFollowerBodyLabel'
         The Body Label is gonna be dynaic type So, not gonna pass font size.
         But the Body Label still passing textAlignment because some view's body can be left alignment other view's can be another alignment.
         
         c.f: Purpose of passing 'textAlignment'
         Passing textAlignment for the configure text label.
         */
        self.textAlignment = textAlignment
    }
    
    private func configure() {
        textColor = UIColor.secondaryLabel
        
        /*
         Dicsussion: About adjustsFontForContentSizeCategory
         If adjustsFontForContentSizeCategory is true, text size will dynamic.
         So, It can be change by user text setting.
         */
        adjustsFontForContentSizeCategory = true
        
        /*
         Discussion: Why did I create 'preferredFont'?
         Because I want this body label is gonna be dynamic.
         When I assign the 'preferredFont(forTextStyle: .body)' to the body label font, It's going to be the size and will see Apple semantic UI.
         */
        font = UIFont.preferredFont(forTextStyle: .body)
        
        adjustsFontSizeToFitWidth = true
        
        /*
         Discussion: For giving more ratio with body label text.
         
         Because body label have lots of text.
         The Body label have more text than title.
         So, give more text minimum scale factor than the title label.
         In other word give less point than title label text.
         It's gonna be smaller font size than title label text.
         */
        minimumScaleFactor = 0.75
        
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
}
