//
//  GithubFollowerButton.swift
//  GithubApp
//
//  Created by 김광준 on 2021/07/28.
//

import UIKit

class GithubFollowerButton: UIButton {
    // MARK:- init(frame:)
    /*
     Discussion :
     -> Why did I create default initializer by as with the frame parameter?
        -> Because I have to setup frame of UIButton.(initialize button with the button)
        -> Also if don't create frame of the button, iOS dosen't showing button in the screen.
     
     Discussion :
     -> Why 'override' sufix is added at init(frame:)?
        -> Because the class that 'GithubFollowerButton' is sub class of the 'UIButton'
     */
    override init(frame: CGRect) {
        /*
         Discussion:
         -> The 'super' is basically mean 'calling the super class or parents class'
         
         Discussion:
         -> What happen in this function?
            -> When excute code, method will excute first which is added 'super' by sufix.
            -> So, in this case 'super.init(frame:)' method is excute and then my custom code will be excute.
         c.f:
         -> in this case 'super.init(frame:)' mean 'UIButton initializer with frame parameter' which is create by APPLE Developers
         */
        super.init(frame: frame)
        
        configure(titleColor: .white)
    }
    
    // MARK:- required init?(coder:)
    /*
     Discussion:
     -> Basically this initializer mean's "call the coder when you initialized this GithubFollowerButton the 'Story Board'"
     c.f:
     -> The key is when I using 'Story Board' this initializer is will call.
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- custom init
    // Create custom initializer for the button color and title
    /*
     c.f:
     -> Passing the button color and title when this class initialized.
     -> The button color and title will be chaging and create when every time that initialized this class
     */
    
    convenience init(backgroundColor: UIColor, title: String, titleColor: UIColor) {
        /*
         Discussion:
         -> Why did I gave 'zero' to 'init frame parameter?'
            -> First of all I got a frame already, And just pass through the 'frame'. (can find in the 'override init(frame: CGRect)')
            -> Second I will gonna be create button by custom autolayout, So I initialzed frame by 'zero'
         */
        self.init(frame: .zero)
        
        /*
         Discussion:
         -> Setting background color of the button whatever I passed in when initialized this class
         
         c.f:
         -> 'self' mean the 'GithubFollowerButton'.
         */
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    // MARK:- private function which is 'configure' that for using 'generic'
    /*
     Discussion:
     -> the 'private' mean's 'call only in this class'
     
     c.f:
     -> This function create by 'generic' function because this function will using for reusable stuff.
        Also I will using only in this class, So I create this func by 'private'.
     */
    
    // for common stuff.
    private func configure(titleColor: UIColor) {
        layer.cornerRadius = 10
        
        // set button title color
        // c.f: default button title color is white.
        setTitleColor(titleColor, for: .normal)
        
        // dynamic type of font
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        
        // for autolayout perposes.
        /*
         c.f:
         -> Basically this code means using autolayout.
         */
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /*
     Discussion: Why did I implement this method?
     This method is give to flexiblity
     Because this class already have init method.
     If want to change backgroundColor, title of button, I can do use this function
     That's mean is have many choice and is flexible.
     */
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        
    }
}
