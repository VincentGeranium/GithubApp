//
//  GithubFollowerAlertViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/13.
//

import UIKit

class GithubFollowerAlertViewController: UIViewController {
    
    // Create white view for create container view.
    let containerView = GithubFollowerAlertContainerView()
    
    let titleLabel = GithubFollowerTitleLabel(textAlignment: .center, fontSize: 20)
    let bodyMessageLabel = GithubFollowerBodyLabel(textAlignment: .center)
    let actionButton = GithubFollowerButton(backgroundColor: .systemPink, title: "Ok", titleColor: .white)
    
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
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureBodyMessaageLabel()

    }
    
    //MARK:- configure element of screen individually
    
    /*
     c.f : About container view
     The containerView is white squre and hold everything.
     That is gonna be view controller but 'titleLabel','bodyMessageLabel' and 'actionButton' that actually into the container view.
     
     */
    
    // MARK:- Configure of containerView.
    func configureContainerView() {
        // MARK:- ContainerView's UI setup.
        // add subview
        view.addSubview(containerView)
        
        //setup constraint
        NSLayoutConstraint.activate([
            // setup containerView vertically(Y) and horizontally(X)
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Give height and width by hard coding
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
        ])
    }
    
    // MARK:- Configure of titleLable.
    /*
     c.f: hierarchy of 'titleLabel'
     The titleLabel is put in the 'containerView'
     So, titleLabel have to add in the containerView
     In other word the 'titleLabel' is sub view of the 'containerView'
     */
    func configureTitleLabel() {
        // added titleLable in containerView
        containerView.addSubview(titleLabel)
        
        /*
         Discussion: Why doesn't exist code which associated with UILabel's UI, in other words doesn't configure UI?
         Because all the titleLabel UI's already configured at 'GithubFollowerTitleLabel'
         */
        
        // Unwraped alertTitle.
        /*
         c.f: alertTitle data passing from initializer
         */
        guard let alertTitle = alertTitle else {
            /*
             c.f: About 'Nil Coalescing' term. (example code : alertTitle ?? "Empty title")
             The Nil Coalesing purpose is unwraped optional.
             And give to default value that's positioned after the '??'
             So, It can be replace by 'guard - let' statement.
             For example 'alertTitle ?? "Empty title"' this code is meaning about
             "use alertTitle but if it's nil use default value which is 'Empty title'"
             */
            print("Error : Can get alert title, somthing went wrong")
            return
        }
        

        // Setup titleLabel text
        titleLabel.text = alertTitle
        
        // Setup constraints
        NSLayoutConstraint.activate([
            /*
             c.f: padding in the top between containerView
             */
            
            // MARK:- pined top, sizes, x cordinate and width of titleLabel
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            
            /*
             Discussion: Why titleLable height constant is 28?
             I already know about font size is 20 and This is gonna be just one line.
             Also I want to give little bit of padding it.
             This is the reason of the height constant value is 28.
             */
            // setup height by hard coding
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
        ])
    }
    
    // MARK:- Configure of actionButton.
    /*
     Discussion: Why did I create actionButton first than bodyMessageLabel?
     Because base on the alert design, the containerView have titleLabel.
     The titleLabel is pined top of the containerView.
     And also base on the alert design actionButton's bottom(become a padding of the bottom) is pined bottom which containerView's and that is have space between.
     So, first create button and filled the space by bodyMessageLabel
     As a result the space between titleLabel and actionButton will filled by bodyMessageLabel
     That't the reason why did I create the button before bodyMessageLabel.
     */
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        
        // c.f: The buttonTitle is pass from custom initializer
        if let buttonTitle = self.buttonTitle {
            actionButton.setTitle(buttonTitle, for: .normal)
        } else if self.buttonTitle == nil {
            actionButton.setTitle("", for: .disabled)
            print("Error: Can't get actionButton Title")
        }
        
        actionButton.addTarget(self, action: #selector(didTappedActionButton), for: .touchUpInside)
        
        // setup constraints actionButton
        NSLayoutConstraint.activate([
            // padding it to bottom
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
    }
    
    // MARK:- Configure of bodyMessaageLabel.
    func configureBodyMessaageLabel() {
        containerView.addSubview(bodyMessageLabel)
        
        if let bodyMessage = self.bodyMessage {
            bodyMessageLabel.text = bodyMessage
        } else if bodyMessage == nil {
            bodyMessageLabel.text = "Unable to complete request."
            print("Error: Unable to complete get text request.")
        }
        
        /*
         Discussion: Why did I create numberOfLines ?
         Because the label is always can be possible to differents lines.
         */
        // setup number of lines which bodyMessageLabel
        bodyMessageLabel.numberOfLines = 4
        
        // setup UI
        NSLayoutConstraint.activate([
            bodyMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyMessageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            bodyMessageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            bodyMessageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
        ])
    }
    
    
    // MARK:- actionButton 'action' function.
    /// When user tapped button, this function will excute
    @objc func didTappedActionButton() {
        dismiss(animated: true) {
            print("Success to dismiss")
        }
    }
    

}
