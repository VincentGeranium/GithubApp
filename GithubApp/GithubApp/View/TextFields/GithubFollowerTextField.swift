//
//  GithubFollowerTextField.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/03.
//

/*
 Discussion: About this 'GithubFollowerTextField' class
 
 I don't need different style of textfield.
 So, I created to generic textfield.
 I will make textfield to some other textfield which is each different class or views by use this class.
 */

import UIKit

class GithubFollowerTextField: UITextField {
    // c.f: I will not gonna make custom initializer in this class
    // Create require init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    /*
     c.f: About 'required init?(coder: NSCoder)'
     
     This initializer for the Story board
     So, If dosen't have Story board or make app without the story board (aka programitcally)
     It doesn't related when I make app.
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Discussion: Why did I create this method  by 'private'?
     Create configure function by private because I don't want co-configure or use this function outside of this file.
     And I want use only here.
     */
    
    private func configure() {
        // stylization code
        translatesAutoresizingMaskIntoConstraints = false
        
        // MARK:- layer code group
        layer.cornerRadius = 10
        layer.borderWidth = 2
        // When deal with layer border color, have to use 'cgColor'
        /*
         c.f: About Color when dark mode and light mode
         
         Dark mode and Light mode is different
         Therefore color is different showing being dark mode and light mode even same color.
         So, When develop app carefully choise the color and have to check color when dark mode and light mode.
         
         c.f: About cgColor
         cg means Core Graphic.
         */
        layer.borderColor = UIColor.systemGray4.cgColor
        
        // MARK:- Text code group
        /*
         c.f : About color '.label'
         '.label' color have two color by situation.
         Basically when Dark mode .label is showing white color and otherwise Light mode will be black.
         
         p.s : This is standard color.
         */
        textColor = .label
        
        /*
         c.f: About tintColor
         The tintColor is blinking cursor color
         */
        tintColor = .label
        textAlignment = .center
        
        // I will gonna use dynamic type for this
        font = UIFont.preferredFont(forTextStyle: .title2)
        
        /*
         Discussion: About adjustsFontSizeToFitWidth
         
         Basically what this code means somebody has really long user name
         The font will make smaller for fit the textfield.
         */
        adjustsFontSizeToFitWidth = true
        
        // Create minimum font size
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        
        // Create Auto correction type.
        /*
         c.f: Why did I assign value .no and also what is autocorrectionType ?
         autocorrectionType is make auto correction when user typed something.
         I don't wanna auto correction so, assign value by .no
         That's mean turn off the auto correction on textfield
         */
        autocorrectionType = .no
        
        // Customization the return key type
        /*
         c.f :
         The 'return' key can be customize like 'done','go' and ect..
         And also can change the keyboard type.
         */
        returnKeyType = .go
        
        // Create placeholder and give text.
        placeholder = "Enter a username"
        
        // when user typed something showing 'x' button and if touch that button all literal is clear.
        clearButtonMode = .whileEditing
    }
}
