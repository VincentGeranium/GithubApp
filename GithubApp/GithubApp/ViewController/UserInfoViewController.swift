//
//  UserInfoViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/07.
//

import UIKit

/*
 c.f: This ViewController will be modal present transition, not the whole screen.
 So, in here need just transition working that point is have to do minimum setup here.
 */

class UserInfoViewController: UIViewController {
    
    // Container view which is contain by child that GithubUserInfoHeaderViewController
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    
    var username: String?
    
    lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(dismissViewController))
    
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK:- Methods
        configureViewController()
        setupNavigationRightBarButtonItem()
        layoutUI()
        getUserInfo()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    private func setupNavigationRightBarButtonItem() {
        navigationItem.rightBarButtonItem = doneButton
    }

    
    func configureViewController() {
        self.view.backgroundColor = .systemBackground
    }
    
    func getUserInfo() {
        guard let username = username else { return }
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GithubUserInfoHeaderViewController(user: user), to: self.headerView)
                }
                
                print(user)
                
            case .failure(let error):
                self.presentGithubFollowerAlertOnMainThread(alertTitle: "Something went wrong", bodyMessage: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func layoutUI() {
        view.addSubview(headerView)
        view.addSubview(itemViewOne)
        view.addSubview(itemViewTwo)
        
        itemViewOne.backgroundColor = .systemPink
        itemViewTwo.backgroundColor = .systemBlue
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK:- Create constraint the headerView to layout

        /*
         Discussion: safaAreaLayoutGuide
         This is how deal with the safe area with the noach.
         When layout the UI warried about the noach or the device top
         have to notice the safe area.
         */
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
    }
    /*
     Discussion: About this method.
     I will adding multiple child view controller to specific container view.
     So, make this method flexible enough which passing whatever child view controller whatever container view
     */
    func add(childVC: UIViewController, to containerView: UIView) {
        //
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true) {
            print("Success to dismiss ViewController")
        }
    }
}
