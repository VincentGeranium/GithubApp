//
//  SearchViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/07/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK:- initialize three objects.
    
    // MARK:- logoImageView
    let logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        return imageView
    }()
    
    // MARK:- usernameTextField
    /*
     Discussion: About initialization and customization.
     As I create 'GithubFollowerTextField()' like this.
     This is I did two kind of action by initialization and customization
     If I writed braket after some kind of class name, type name or other else that is means 'I will initialization of class name, type name or other else'
     Additionally before initialization, If I create custom these things which class, type or other else and then I initialized, I did both of thing to do that initialization and customization.
     */
    
    /*
     c.f: About object which is 'usernameTextField'
     
     -  I created this custom class the 'GithubFollowerTextField'
        - This class is inheritance the 'UITextField'
     - I customization UITextField used create method the 'configure'
     - The method 'configure' is contains lots of custom codes.
        - And the 'configure' method is calling when initialize the 'GithubFollowerTextField', because I assign 'configure' method in 'override init(frame: CGRect)'
     
     c.f: Workflow when 'GithubFollowerTextField' init
     
     initialization 'GithubFollowerTextField' -> excute 'override init(frame: CGRect)' -> excute 'configure()' -> excute contain code which is written in the 'configure' function.
     */
    let usernameTextField: GithubFollowerTextField = {
        let textField: GithubFollowerTextField = GithubFollowerTextField()
        return textField
    }()
    
    // MARK:- Create callToActionButton
    let callToActionButton: GithubFollowerButton = {
        /*
         c.f : About before I created init backGroundColor and title in the custom button class which 'GithubFollowerButton'
         So, I just passing parameter values that will be excute the inside of 'GithubFollowerButton'
         */
        let button: GithubFollowerButton = GithubFollowerButton(backgroundColor: .systemGreen,
                                                                title: "Get Followers")
        return button
    }()

    // MARK:- View Lifecycle
    
    // MARK:- viewDidLoad
    /*
     c.f : Only get and call this function once when view is did load.
     viewDidLoad function is not call and excute when pop the view.
     In other word, If users tap next button and change screen use by navigation. (push)
     And pop the view viewDidLoad is not call.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         c.f: About 'systemBackground'
         
         When light mode it's gonna be white and dark mode it's gonna be black color that backgroundColor.
         */
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
    }
    
    // MARK:- viewWillAppear
    /*
     c.f : This function is get and called when before view appear in other word called after view did load
     Whenever after view did load, call and excute this function.
     viewWillAppear is call everytime when view is appear.
     reference : View life cycle.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide navigation bar, everytimes this pops up
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK:- function 'configureLogoImageView'
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // It will be refactoring
        // Stringly type -> (named: "some image name")
        // Stringly type is very dangerous
        logoImageView.image = UIImage(named: "gh-logo")!
        
        // Create codes by all the constraint are promatically.
        // In the array, contain all the constraints codes and it's will activate whole code one time
        NSLayoutConstraint.activate([
            // Create top padding for the top padding space imageView
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            // Positioning imageView to center X in it, and Standarded the self view's X position.
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            // Set the height and width of ImageView.
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK:- function 'configureTextField'
    private func configureTextField() {
        view.addSubview(usernameTextField)
        /*
         Discussion: Why did not create 'translatesAutoresizingMaskIntoConstraints' ??
         Because I already create 'translatesAutoresizingMaskIntoConstraints' in 'GithubFollowerTextField'.
         And when I create the 'usernameTextField', the textField is inheritance the 'GithubFollowerTextField'
         So, the textField doesn't need to create the 'translatesAutoresizingMaskIntoConstraints'
         */
        
        NSLayoutConstraint.activate([
            /*
             Discussion: About textField top constraint
             Top padding with logoImageView that mean's have empty space between logoImageView bottom and usernameTextField top.
             And layout of usernameTextField top, the logoImageView is the standard position when I positioning the usernameTexrField
             */
            usernameTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 48),
            
            // Create padding right and left edges which mean's create padding the Leading edge and Trailing edge.
            usernameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            // Create height of textField
            // c.f : At least size of button, textField, ect... is 44 points.
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK:- function 'configureCallToActionButton'
    private func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        /*
         Discussion: Why did not create 'translatesAutoresizingMaskIntoConstraints' ??
         Because I already create 'translatesAutoresizingMaskIntoConstraints' in 'GithubFollowerButton'.
         And when I create the 'callToActionButton', the button is inheritance the 'GithubFollowerButton'
         So, the button doesn't need to create the 'translatesAutoresizingMaskIntoConstraints'
         */
        
        /*
         Dicsussion: Abuot the button constraints
         the other objects are pined from the top but the button is pined from view's bottom
         
         c.f: explain about position.
         This button is have Y cordinate, pin from bottom.
         Also this button have width and X coordinate because have padding positioning the leading and trailing
         */
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    

}
