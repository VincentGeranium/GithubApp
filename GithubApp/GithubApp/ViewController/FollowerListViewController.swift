//
//  FollowerListViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/10.
//

import UIKit

class FollowerListViewController: UIViewController {
    
    /*
     Discussion: property and data
     When I passing data essentially I have to have variable on the screen to set
     For example I create 'username' property, that is when I pass the data which is username data.
     The username property will receive the data and stored in it.
     
     c.f: This 'username' is set when I pass the data to it
     */
    
    var username: String?
    var followers: [Follower] = []
    // first page init
    var page: Int = 1
    var collectionView: UICollectionView?
    // check user's limit follower
    // c.f: the flag about user has follower
    var hasMoreFollower: Bool = true
    

    
    
    // MARK:- Discussion about UICollectionViewDiffableDataSource
    /*
     Discussion: UICollectionViewDiffableDataSource()
     New from iOS 13
     - New way to handle data source of UICollectionView
     - It's very shine(good), when data has change alot.
        For example in this app, when user search and typed each alphabet latter of user id
        the collectionView data is change alot.
     - This is dynamic
     
     - UICollectionViewDiffableDataSource is taken two parameters that are generic.
        But the two parameter have to confirm hashable protocol, when compair the snapShots, it can be compair, when these are hashable.
     
     Discussion: About hashable
     - A type that can be hashed into a Hasher to produce an integer hash value.
     
     Discussion: What is the means Hashing a value
     - The Hashing a value means feeding its essential components into a hash function, represented by the Hasher type.
        Essential components are those that contribute to the type’s implementation of Equatable.
        Two instances that are equal must feed the same values to Hasher in hash(into:), in the same order.
     
     Discussion: About two parameters of the UICollectionViewDiffableDataSource
     - Passing Section is the section which is my collectionView
        Passing Follower is the item
        It hashing the section and hasing the item which is Follower
     */
    var dataSource: DataSource?
    
    /*
     c.f: the two parameter which Section and Follower
     - Section and Follower is generic
     - Section means section of collection view
     - Follower is individual item
     - Section and Follower is confirm Hashable
     - Those are have unique value cause Hashable.
     */
    var snapShot: SnapShot?
    
    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowersWithUsernameAndPage()
        configureDataSource()
    }
    
    // MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigaitonController()
    }
    
    // MARK:- getFollowers
    func getFollowersWithUsernameAndPage() {
        guard let username = username else {
            return
        }
        getFollowers(username: username, page: page)
    }
    
    private func getFollowers(username: String, page: Int) {
        // when loading data this function will be occur
        /*
         c.f: How can work the method 'showLoadingView'? -> process
         First getFollowers is calling
         And showLoadingView function start
         And then Network Manager will doing and once network call done the completion block will happen
         */
        showLoadingView()
        
        NetworkManager.shared.getFollowers(for: username, perpage: 100, page: page) {[weak self] result in
            /*
             Discussion: explain ARC and weak self of the network call
             First my network call has two strong reference which self.followers and self.updateData().
             What is the 'self' is in this case my 'FollowerListViewController'
             In other words my networkManager have strong reference between my 'FollowerListViewController', This get cause memory leak.
             So, solution is self.followers and self.updateData()'s 'self' change the weak variable
             How to create weak variable to self?
             Crate [weak self] in front of result, this is essentially make self weak
             When make self weak, it will has to be optional becuase self can be nil
             */
            
            // unwrapping self optinal
            guard let self = self else { return }
            
            self.dismissLoadingView()
            #warning("Dissmiss loading View")
            
            /*
             Discussion: If user have not follower what happen?
             If user have any follwer but still success.
             Because only haven't follower, user is exist.
             So, still get back array of followers from network call, however it will be zero.
             */
            
            switch result {
            case .success(let followers):
                // flip the flag which mean turn to false that 'hasMoreFollower' value
                /*
                 Discussion:
                 1 페이지 당 100개의 유저 정보를 담아오는데 만약 250명의 팔로우가 있다면
                 200까지는 2페이지를 넘겨 유저 정보를 가져올수있지만 나머지 50은 3페이지가 되므로 error이 발생한다.
                 그러므로 page 를 증가시키는 로직을 멈춰야하므로 그에 대한 표시인 flag로 'hasMoreFollower'를 만들었고
                 flag가 true인지 false인지에 따라 로직이 동작하고 안하고가 바뀌게 된다.
                 */
                // MARK:- check followers count is under 100
                if followers.count < 100 {
                    print("The hasMoreFollower will filp to false")
                    self.hasMoreFollower = false
                }
                // append followers
                self.followers.append(contentsOf: followers)
                
                // MARK:- check followers array is empty
                // Check followers array isEmpty that after network call and append followers in the array
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go followe them 😝."
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                self.updateData()
            case .failure(let errorMessage):
                self.presentGithubFollowerAlertOnMainThread(alertTitle: "Bad Stuff Happend", bodyMessage: errorMessage.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    // MARK:- configureViewController
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK:- configureNavigaitonController
    private func configureNavigaitonController() {
        /*
         Discussion: About navigationBar hidden methods between
         'self.navigationController?.navigationBar.isHidden = false' and
         'navigationController?.setNavigationBarHidden(false, animated: true)'
         
         These are doing same action that showing or not to navigationBar by value
         When assign or give value which true, It will be hidden and otherwise shown.
         In other word give false value to these method, doing navigaionBar hidden.
         
         But, these two method has same action but a little bit difference about animation that showing action.
         For example if using 'self.navigationController?.navigationBar.isHidden = false' and user swiped the screen the navigaitonBar is hidden during swipped
         But using this 'navigationController?.setNavigationBarHidden(false, animated: true)' method, It's not disappeared when during swipped screen.
         In other word is not hidden navigationBar when during user swipped the screen.
         */
        navigationController?.setNavigationBarHidden(false, animated: true)
        // Setup to large title in navigationBar.
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK:- configureCollectionView
    private func configureCollectionView() {
        // initialize collectionView
        // c.f: setup the frame by 'view.bound' means 'fill up the whole screen'
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: self.view))
        
        guard let collectionView = collectionView else {
            return
        }
        /*
         Discussion: Why did I initialize collectionView first that before collectionView added subview.
         Because If I do not init the collection view first, in other words added by subview first.
         The collectionView is 'nil', because collection view object not create yet.
         So, I'm initialize the collectionView object and use that
         That's why I did initialize collectionView first that before added by subview.
         */
        view.addSubview(collectionView)
        
        // MARK:- Confirm UICollectionViewDelegate to self.
        // c.f: collectionView delegate what listen to? -> listen to self.
        collectionView.delegate = self
        
        // cofigure collectionView
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.cellIdentifier)
        
    }
    
    // MARK:- configureDataSource
    private func configureDataSource() {
        /*
         have to test this code for unwrap dataSouce
         
        guard self.dataSource == DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.cellIdentifier, for: indexPath) as? FollowerCell else {
                return UICollectionViewCell()
            }
            cell.set(follower: follower)
            return cell
        }) else {
            return
        }
        */
        guard let collectionView = collectionView else {
            return
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            /*
             c.f: Workflow of this block
             1. Create cell that reusable.
             2. Configure cell.
             3. Return the cell.
             */
            
            // create cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.cellIdentifier, for: indexPath) as? FollowerCell else {
                return UICollectionViewCell()
            }
            
            // configure cell
            /*
             c.f: It good habbit to make one line code
             For example in this code.
             'cell.set(follower: follwer)', This code means pass the follower data through 'set(follower:)' method,
             And give to cell label text.
             If it has not create function, It will be 'cell.usernameLabel.text = follower.login'
             It very simple and reduce whole line of code.
             If I want reduce code, make habbit to create functions and handle that.
             */
            cell.set(follower: follower)
            
            // return the cell
            return cell
        })
    }
    
    // MARK:- updateData
    // About snapShot stuff. It's related to update data
    func updateData() {
        // initialize snap shot
        snapShot = SnapShot()
        
        guard var snapShot = self.snapShot else {
            return
        }
        
        // configure
        // c.f: add section to the snapShot
        snapShot.appendSections([.main])
        
        // added array of follower
        snapShot.appendItems(followers)
        
        guard let dataSource = self.dataSource else {
            return
        }
        
        // dataSouce update
        DispatchQueue.main.async {
            dataSource.apply(snapShot, animatingDifferences: true) {
                print("DataSource is Update complete")
            }
        }
    }
}

// MARK:- Extension
extension FollowerListViewController: UICollectionViewDelegate {
    /*
     c.f: UICollectionViewDelegate is have ScrolleView stuff
     So, If I confirm the UICollectionViewDelegate, automatically implement scroll view protocols.
     */
    
    /*
     Discussion: About Delegate.
     Delegate is sitting back and waitting for an action, like 'didSelectCell'
     Waitting for user tap the cell and then access.
     
     Here the 'scrollViewDidEndDragging' waitting for user end dragging then access.
     
     That's the delegate to-do.
     */
    
    /*
     Discussion: About Scroll View
     Scroll view stretch pretty far down.
     Even the my phone screen me only see that section of it.
     But reality Scroll view is really big that's the 'content height'
     */
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // c.f: Set the Y cordinate because I want scroll up and down not a side to side
        // c.f: If I want to create horizontal view access X
        let offSet = scrollView.contentOffset.y
        
        // c.f: 'contentSize.height' code means 'entire scroll view'.
        let contentHeight = scrollView.contentSize.height
        
        // c.f: This is scroll view's height. It's kind of height the screen, The end point of iPhone.
        let height = scrollView.frame.height
        
        /*
         Discussion: This math logic
         
         offSet -> 유저가 스크롤 한 치수
         contentHeight -> 스크롤 뷰의 총 높이
         height -> 스크롤 뷰가 스크린에 보여지는 부분의 높이
         
         즉, 유저가 더 많은 follower를 보기 위해 현재 보여지는 부분에서 더 scroll down 했을 때
         getFollowers 를 실행.
         */
        
        if offSet > contentHeight - height {
            // check user has more follower?
            if hasMoreFollower == false {
                print("🙌 No the user has not more follower")
                return
            } else if hasMoreFollower == true {
                // If user scroll the view, page have to increase
                guard let username = username else {
                    return
                }
                page += 1
                getFollowers(username: username, page: page)
            }
        }
    }
}
