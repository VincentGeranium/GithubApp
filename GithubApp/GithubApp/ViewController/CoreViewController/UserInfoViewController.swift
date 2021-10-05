//
//  UserInfoViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/09/07.
//

protocol UserInfoViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

import UIKit

/*
 c.f: This ViewController will be modal present transition, not the whole screen.
 So, in here need just transition working that point is have to do minimum setup here.
 */

/*
 UserInfoViewController가 GFDataLoadingViewController를 상속 받는 이유는
 GFDataLoadingViewController를 상속 받는 FavoritesListViewController과 FollowerListViewController을
 스택뷰로 묶어 사용하기 때문에 UserInfoViewController에서도 GFDataLoadingViewController를 상속받아야 한다.
 심지어 UserInfoViewController에서는 GFDataLoadingViewController의 함수를 사용하지 않을지라도 말이다.
 */

class UserInfoViewController: GFDataLoadingViewController {
    
    // Container view which is contain by child that GithubUserInfoHeaderViewController
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GithubFollowerBodyLabel(textAlignment: .center)
    
    var itemViews: [UIView] = []
    
    var username: String?
    
    // MARK:- set the delegate which is FollowerListViewContollerDelegate
    // initilialized user info view controller which set the delegate
    weak var delegate: UserInfoViewControllerDelegate?
    
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
        
        /*
         두 가지 방법이 있다
         1. followerItemVC 처럼 따로 인스턴스를 만들어 델리게이트를 주어 코드를 짜는 방법
         2. self.add(childVC: GithubFollowerRepoItemViewController(user: user, delegate: self), to: self.itemViewOne) 처럼
         한줄에 모든 것을 다 짜는 방법
         
         나는 1을 선호한다 리팩토링이 필요할 경우 한 줄로 코드를 만들엇을 경우 너무 강한 응집력을 가지고 있어 분해하여 고치기 힘들 것 같기 때문이다.
         아래와 같이 코드를 나누어 짠 이유는 두 가지 방법이 있다는 것을 알고싶어서 두 가지 방법이지만 똑같은 동작을 하는 코드를 짜본것이다.
         */
        
        let followerItemVC = GithubFollowerItemViewController(user: user)
        // c.f: communication pattern is hook up
        // MARK:- GithubFollowerItemViewController Delegate setup
        followerItemVC.delegate = self
        
        // c.f: communication pattern is hook up
        // MARK:- GithubFollowerRepoItemViewController Delegate setup

        /*
         Discussion: What to do in this block?
         Pluged In view controller in the container view
         */
        self.add(childVC: GithubUserInfoHeaderViewController(user: user), to: self.headerView)
        // c.f: communication pattern is hook up
        // MARK:- GithubFollowerRepoItemViewController Delegate setup and addChildVC, make one line code.
        self.add(childVC: GithubFollowerRepoItemViewController(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
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
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
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
extension UserInfoViewController: GFRepoItemViewControllerDelegate {
    // MARK:- Did tap Github Profile Button
    // discussion: when did tap github profile button show safari view controller
    func didTapGithubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGithubFollowerAlertOnMainThread(alertTitle: "Invaild URL", bodyMessage: ErrorMessage.invalidURL.rawValue, buttonTitle: "OK")
            return
        }
        presentSafariViewController(url: url)
    }
    
}

// c.f: Conform to the delegate here
extension UserInfoViewController: GFItemViewControllerDelegate {
    // discussion: when did tap github follower button dismiss view controller and create other delegate tell follower list screen the new user
    func didTapGetFollowers(for user: User) {
        print("did Tap github followers button")
        guard user.followers != 0 else {
            presentGithubFollowerAlertOnMainThread(alertTitle: "No Followers", bodyMessage: ErrorMessage.noFollower.rawValue, buttonTitle: "Try again.")
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismissViewController()
    }
}
