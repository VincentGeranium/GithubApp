//
//  GithubFollowerAlertViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/13.
//

import UIKit

class GithubFollowerAlertViewController: UIViewController {
    
    // Create white view for create container view.
    let containerView = UIView()
    let titleLabel = GithubFollowerTitleLabel(textAlignment: .center, fontSize: 20)
    let bodyMessageLabel = GithubFollowerBodyLabel(textAlignment: .center)
    let actionButton = GithubFollowerButton(backgroundColor: .systemPink, title: "Ok")
    
    /*
     Discussion: Why create those variable properties for custom init which 'alertTitle', 'bodyMessage' and 'buttonTitle'.
     
     When call this alert some where any view controller or any view and ect, Alert should be show on air.
     It's gonna pass in what's the title should be, what the body message should be and what the button should be say.
     That's gonna happen at the call site.
     Because of that
     */
    
    var alertTitle: String?
    var bodyMessage: String?
    var buttonTitle: String?
    
    //MARK:- Custom init
    /*
     Discussion: Reason of assign nil value to nib and bundle.
     
     I will gonna initialize the view controller by programmatically, So, it doesn't have nib and bundle.
     */
    init(alertTitle: String, bodyMessage: String, buttonTitle: String) {
        /*
         Discussion: Reason of create super.init which is have parameters that 'nibName' and 'bundle'.
         
         Because this 'GithubFollowerAlertViewController' is inheritance UIViewController.
         So, when create custom init, super.init with parameters 'nibName' and 'bundle'
         */
        super.init(nibName: nil, bundle: nil)
        
        // Set this variables to a pass in.
        self.alertTitle = alertTitle
        self.bodyMessage = bodyMessage
        self.buttonTitle = buttonTitle
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Discussion: Set the view back ground color not 100% black but 75% black.
         Because when alert will showing I want view is not the whole black color
         I want to user see the view like blur or little gray.
         */
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)

    }
    

}
