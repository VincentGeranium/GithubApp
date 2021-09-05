//
//  GithubFollowerTitleLabel.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/13.
//

import UIKit

class GithubFollowerTitleLabel: UILabel {

    // MARK:- Typical initializer
    /*
     c.f: About 'override init(frame: CGRect)'
     This initializer is 'typical init'
     */
    override init(frame: CGRect) {
        // c.f : passing the 'frame' which override init parameter to super init parameter that 'frame'
        super.init(frame: frame)
        configure()
    }
    
    // MARK:- For Storyboard init
    /*
     c.f: About 'required init?(coder: NSCoder)'
     
     This initializer for story board.
     If developer create app use the story board, This initializer have to use
     But if developer do not use the story board, In other word create app to programmatically not use this initializer.
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Custom initializer
    /*
     Discussion: About this custom initializer
     
     This custom initializer is overall label.
     
     c.f: About naming
     This custom init is get about label stuff, In other word this is overall to UILabel.
     So, naming of parameter is have to specific.
     Also have another reason that parameter naming have to specific Which the 'GithubFollowerTitleLabel' class purpose is for create generic custom label so dosen't confusing about initializer and even other whole things.
     
     c.f : About parameter which is custom init
     I not gonna prefer font type cause I gonna get the dynamic type.
     So, I do not create parameter which fontType.
     */
    
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        // c.f: I wanna the font weight always bold so, fontSize is gonna passing from parameter but weight is hard coding.
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    // MARK:- configure function
    /*
     Discussion: Why did I this function access by 'private'?
     Because I want to use this function only this class.
     So, I use the 'access control syntax that private'.
     */
    private func configure() {
        /*
         c.f:  How to gonna be configure textLabel
         
         1, Set the text color.
         */
        textColor = UIColor.label
        
        /*
         c.f: Why did I create method that 'adjustFontSizeToFitWidth' and why set that the 'true' ?
         
         Because This title label text is gonna be one line, So I just want to fit the text in the textLabel
         */
        adjustsFontSizeToFitWidth = true
        
        // This 'minimumScaleFactor' purpose is for the label’s text(String).
        minimumScaleFactor = 0.90
        
        // This 'lineBreakMode' is for 'The technique for wrapping and truncating the label’s text.'
        lineBreakMode = .byTruncatingTail
        
        // Do the constraints
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
