//
//  GithubFollowerItemInfoViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/14.
//

import UIKit

/*
 Discussion: About this class
 GithubFollowerItemInfoViewController is super class
 GithubFollowerItemInfoViewController is very generic because whole share code amongs all the difference types of viewControllers
 */
// MARK:- Super Class which Item info View Controller
class GithubFollowerItemInfoViewController: UIViewController {
    // MARK:- Definde Properties
    let stackView = UIStackView()
    let itemInfoViewOne = GithubFollowerItemInfoView()
    let itemInfoViewTwo = GithubFollowerItemInfoView()
    
    /*
     Discussion: Why did not implement specific background color and title?
     The reason being because this is 'super class'.
     This is 'generic class' whole of common stuff.
     Like I don't know the button color is purple or green one yet
     So, defined with the basic configureation with not gonna give background color and title yet
     The button object defined generic button, I will gonna do that in the sub class's more specific each type
     */
    let actionButton = GithubFollowerButton()
    
    var user: User?
    /*
     1. Discussion: How to two classes communication pattern is hook up? and why the delegate is defined in here not GithubFollowerItemViewController and GithubFollowerRepoItemViewController?
     Because this is super class of GithubFollowerItemViewController and GithubFollowerRepoItemViewController
     
     2. Discussion: Why did I implement weak?
     For prevent retain cycle
     */
    weak var delegate: UserInfoViewControllerDelegate?
    
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        configureActionButton()
        layoutUI()
        configureStackView()
    }
    
    // MARK:- Configure Background View
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    //MARK:- Configure StackView
    private func configureStackView() {
        /*
         Discussion: Why did I implement asix to stackView?
         Cause I want to be horizontal stackView.
         I don't want vertical.
         */
        stackView.axis = .horizontal
        /*
         Discussion: What is the distribution?
         This is how gonna be item layout in stack view will fill
         For example equalCentering is take the center each items
         */
        stackView.distribution = .equalSpacing
        
        /*
         c.f: 'stackView.spacing'
         spacing mean's give to minimum spacing between each one
         forexample stackView.spacing = 10 is mean's give minimum spacing 10 between each of items
         */
        
        /*
         Discussion:
         If want add some subViews in the stack view, must to use 'addArrangedSubview'
         'addSubview' is not working
         
         */
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    /*
     Discussion: Why did not implement anything in this actionButtonTapped function?
     Becaues this is generic super class, In our sub classes, can override parents class
     So, just make function stuff and If want use the function,
     At the sub class override the method and implements that method.
     */
    @objc func actionButtonTapped() {}
    
    
    // MARK:- Setup Layout UI
    private func layoutUI() {
        let padding: CGFloat = 20
        
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

}
