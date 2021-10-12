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
        let button: GithubFollowerButton = GithubFollowerButton(color: .systemGreen,
                                                                title: "Get Followers",
                                                                systemImage: SFSymbols.threePersonImage)
        return button
    }()
    
    /*
     Discussion: About this computed property
     This computed property for validation of the username is empty or non-empty.
     It will return Bool value.
     If return 'true' textField has empty data which is 'username data'.
     Otherwise return 'false' textfield has 'username data.'
     */
    
    var isUsernameEmpty: Bool {
        // This is check the textField text is empty or not empty
        guard let reuslt = usernameTextField.text?.isEmpty else {
            return false
        }
        return reuslt
    }

    // MARK:- View Lifecycle
    
    // MARK:- View Lifecycle which is viewDidLoad
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
        createDismissKeyboardTapGesture()
    }
    
    // MARK:- View Lifecycle which is viewWillAppear
    /*
     c.f : This function is get and called when before view appear in other word called after view did load
     Whenever after view did load, call and excute this function.
     viewWillAppear is call everytime when view is appear.
     reference : View life cycle.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
         Discussion: Why did I implement 'usernameTextField.text = "" '?
         Every time new view will appear I want to show blank textfield.
         So, do this.
         */
        usernameTextField.text = ""
        
        /*
         c.f: About navigationBar hidden
         It can be hidden or non-hidden to specific viewcontroller.
         Another means is can be select to ViewControlller and pick it to hidden or non-hidden.
         */
        // hide navigation bar, everytimes this pops up
        navigationController?.setNavigationBarHidden(true, animated: true)
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK:- function 'createDismissKeyboardTapGesture'
    /// For dismiss, When user tapped any screen that keyboard dismiss.
    ///; c.f: This is one of way to dismiss keyboard, It's has alot of way that dismiss keyboard.
    private func createDismissKeyboardTapGesture() {
        // c.f : gesture have lots of different gesture example that swipe, tap ect,,,
        
        /*
         Discussion: what is 'endEditing'? and why didn't passing parameter?
         
         endEditing(_:) is call when causes the view (or one of its embedded text fields) to resign the first responder status.
         This method looks at the current view and its subview hierarchy for the text field that is currently the first responder.
         If it finds one, it asks that text field to resign as first responder.
         If the force parameter is set to true, the text field is never even asked; it is forced to resign.
         
         And parameter name is 'forece' that is Bool value.
         So, throw back two different kind of result when true and false
         If the force parameter is set to true, the text field is never even asked; it is forced to resign.
         Otherwise if false, this leads to the opposite result.
         Also specify true to force the first responder to resign, regardless of whether it wants to do so.
         */
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        // Added gesture recognizer in the view and the gesture recognizer is the tap gesture that I create.
        view.addGestureRecognizer(tap)
    }
    
    // MARK:- function that 'pushFollowerListViewController'
    /// for push data that username, this 'pushFollowerListViewController' is two ways to call first, when tapped button  which 'GitFollowerButton' or tapped keyboard button that 'go' keyboard button.
    @objc private func pushFollowerListViewController() {
        /*
         Discussion: 'isUsernameEmpty' validation
         This validation is basic text validation
         So, If I want more safty validation, I have to use another validation.
         */
        guard isUsernameEmpty == false else {
            if #available(iOS 15.0, *) {
                presentGFAlertUpToiOS15(alertTitle: "Empty Username", bodyMessage: "Please enter a username. We need to know who to look for 🤔", buttonTitle: "Ok.")
            } else {
                presentGithubFollowerAlertOnMainThread(alertTitle: "Empty Username", bodyMessage: "Please enter a username. We need to know who to look for 🤔", buttonTitle: "Ok")
            }
            return
        }
        
        // resign keybord
        usernameTextField.resignFirstResponder()
        
        print("guard statement is pass : success to get username")
        /*
         Discussion: Passing data workflow for example to below code
         1. Create object
         2. Configure data that I want to pass, In this case I pass username textfield text
         3, Configure data that I want to pass which for the title, In this case I pass username textfield text
         4. Push ViewController on to the stack
         */
        // the code is excute that when tapped button
        // this code for passing data.
        
        // Create followerListVC object which is instance of FolllowerListViewController
        guard let username  = usernameTextField.text else {
            return
        }
        
        let followerListVC = FollowerListViewController(username: username)
        /*
         c.f: About access username variable which in the FollowerListViewController
         I created username variable in the FollowerListViewController.
         So, I can access to the username and can pass the data that user entered username who want to find
         */
        
        /*
         Discussion: Push or pop into the stack.
         I already created UINavigationController.
         So, I can push the FollowerListViewController on top of the stack
         */
        
        // configure to push FollowerListViewController on the top of the stack
        navigationController?.pushViewController(followerListVC, animated: true)
        
    }
    
    func getLogoImage() throws -> UIImage {
        guard let logoImage = ImageResource.logoImage else {
            throw ErrorMessage.unableToGetImage
        }
        return logoImage
    }
    
    func getErrorSystemImage() throws -> UIImage {
        guard let errorSystemImage = ImageResource.errorSystemImage else {
            throw ErrorMessage.init(rawValue: "시스템 이미지를 가져올 수 없습니다.") ?? ErrorMessage.unableToGetImage
        }
        return errorSystemImage
    }
    
    // MARK:- function 'configureLogoImageView'
    /// configure for logo image view
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        #warning("do-catch 로 만들어 보기 - 로고 이미지가 nil일 경우와 아닐 경우")
        logoImageView.image = ImageResource.logoImage
        
        // MARK:- topConstraintsConstant for the down version UI react
        // Create top padding for the top padding space imageView
        let topConstraintsConstant: CGFloat = DeviceTypes.isiPhoneSE2 || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        // Create codes by all the constraint are promatically.
        // In the array, contain all the constraints codes and it's will activate whole code one time
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintsConstant),
            // Positioning imageView to center X in it, and Standarded the self view's X position.
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            // Set the height and width of ImageView.
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK:- function 'configureTextField'
    /// configure input user name texf field
    private func configureTextField() {
        view.addSubview(usernameTextField)
        /*
         Discussion: Why did not create 'translatesAutoresizingMaskIntoConstraints' ??
         Because I already create 'translatesAutoresizingMaskIntoConstraints' in 'GithubFollowerTextField'.
         And when I create the 'usernameTextField', the textField is inheritance the 'GithubFollowerTextField'
         So, the textField doesn't need to create the 'translatesAutoresizingMaskIntoConstraints'
         */
        
        // c.f : 'self' being the 'SearchViewController'
        usernameTextField.delegate = self
        
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
    /// configure button
    private func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        
        /// whenever tapped GithubFollowerButton pushFollowerListViewController function is what's going to called
        callToActionButton.addTarget(self, action: #selector(pushFollowerListViewController), for: .touchUpInside)
        
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

// MARK:- Discussion about digging 'username' data which is the different ways to dig the data
/*
 It has two differents kind of dig 'username' data.
 first way to dig data is when user input the 'username' data and then 'tapped button.'
 second is 'tapped go keyboard'
 */

// MARK:- extension 'UITextFieldDelegate'
extension SearchViewController: UITextFieldDelegate {
    // UITextFieldDelegate -> All hooked up the function, delegated for UITextField
    /*
     Discussion: Delegate
     Delegate is for the listen something for another things.
     Delegate is defining a protocol that encapsulate the delegated resposibillity, such that a confirming type.
     Delegate is guaranteed to provide the functionality the has been delegated.
     
     c.f: Delegate
     If I want to know about delegate, I have to study the pattern which 'delegation' design pattern.
     Delegate is one of part that the delegation design pattern.
     
     c.f: About delegation hook up
     This is make sure delegation all hook up working and then If I pass the data, I will gonna pass data function.
     So, I have to select right function and create code in the extension or whatever I liked.
     */
    
    
    /*
     c.f: About method that UITextFieldDelegate.
     I can see the methods name which UITextFiedlDelegate, I can know that how can take actions when stuffs going on.
     
     Discussion: About 'textFieldShouldReturn'
     As known as by the name of this method, I know how to using.
     This method is calling to when user press the return key.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*
         Discussion: Before pass data
         Before pass the data have to destinataion that for the data's passing
         */
        
        pushFollowerListViewController()
        return true
    }
}
