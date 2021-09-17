//
//  UserInfoViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/07.
//

/*
 c.f: Difined Protocol which is UserInfoViewControllerDelegate
 protocol is one of kind communication pattern.
 */

protocol UserInfoViewControllerDelegate: AnyObject {
    func didTapGithubProfile(for user: User)
    func didTapGitHubFollowers(for user: User)
}

import UIKit
import SafariServices

/*
 c.f: This ViewController will be modal present transition, not the whole screen.
 So, in here need just transition working that point is have to do minimum setup here.
 */

class UserInfoViewController: UIViewController {
    
    // Container view which is contain by child that GithubUserInfoHeaderViewController
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GithubFollowerBodyLabel(textAlignment: .center)
    
    var itemViews: [UIView] = []
    
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
                DispatchQueue.main.async { self.configureUIElements(with: user) }
                print(user)
            case .failure(let error):
                self.presentGithubFollowerAlertOnMainThread(alertTitle: "Something went wrong", bodyMessage: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: User) {
        let followerItemVC = GithubFollowerItemViewController(user: user)
        // c.f: communication pattern is hook up
        followerItemVC.delegate = self
        
        let repoItemVC = GithubFollowerRepoItemViewController(user: user)
        // c.f: communication pattern is hook up
        repoItemVC.delegate = self

        /*
         Discussion: What to do in this block?
         Pluged In view controller in the container view
         */
        self.add(childVC: GithubUserInfoHeaderViewController(user: user), to: self.headerView)
        self.add(childVC: followerItemVC, to: self.itemViewOne)
        self.add(childVC: repoItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "Github since \(user.createdAt.convertDisplayFormat())"
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
    
        
        //MARK:- Create constraint the headerView to layout

        /*
         Discussion: safaAreaLayoutGuide
         This is how deal with the safe area with the noach.
         When layout the UI warried about the noach or the device top
         have to notice the safe area.
         */
        // c.f: give to vertically UI layout contraints
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
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

/*
 Discussion: About Delegate
 The delegate is wait to act want it to something happen.
 In this case did tap github profile button or did tap github followers button.
 So, need to set up communication path way, and that way is defined delegate.
 */

// c.f: Conform to the delegate here
extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGithubProfile(for user: User) {
        print("did Tap github profile button")
        // discussion: when did tap github profile button show safari view controller
        
    }
    
    func didTapGitHubFollowers(for user: User) {
        print("did Tap github followers button")
        // discussion: when did tap github follower button dismiss view controller and create other delegate tell follower list screen the new user
        
    }
    
    
}
