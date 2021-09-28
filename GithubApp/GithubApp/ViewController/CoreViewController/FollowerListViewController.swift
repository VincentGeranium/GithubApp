//
//  FollowerListViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/10.
//

import UIKit

protocol FollowerListViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class FollowerListViewController: UIViewController {
    
    /*
     Discussion: property and data
     When I passing data essentially I have to have variable on the screen to set
     For example I create 'username' property, that is when I pass the data which is username data.
     The username property will receive the data and stored in it.
     
     c.f: This 'username' is set when I pass the data to it
     */
    
    var username: String?
    // Followers Array
    var followers: [Follower] = []
    
    //c.f: Filtered followers array for filter collection view.
    var filteredFollowers: [Follower] = []
    
    // first page init
    var page: Int = 1
    var collectionView: UICollectionView?
    // check user's limit follower
    // c.f: the flag about user has follower
    var hasMoreFollower: Bool = true
    var searchBarHidden: Bool = true
    
    /*
     Discussion: What's the purpose of this property?
     For the sorted select item, between before and after searching follower
     If user searching value will filp, In other words if followers are filterd it will be the true.
     */
    var isSearching = false

    
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
    
    // MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigaitonController()
    }
    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = false
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowersWithUsernameAndPage()
        configureDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarToggle(searchBarHidden: self.searchBarHidden)
    }
    
    
    func searchBarToggle(searchBarHidden: Bool) {
        if searchBarHidden == true {
            navigationItem.hidesSearchBarWhenScrolling = true
        } else if searchBarHidden == false {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    // MARK:- get Followers
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
                /*
                 Discussion: Why 'updateData' method is not get pass the flexible parameter in this block?
                 
                 Because in this block main purpose is get the whole follower of the user which is entered this app.
                 */
                self.updateData(on: self.followers)
            case .failure(let errorMessage):
                self.presentGithubFollowerAlertOnMainThread(alertTitle: "Bad Stuff Happend", bodyMessage: errorMessage.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    // MARK:- configure ViewController
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK:- configure NavigaitonController
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
    
    // MARK:- configure CollectionView
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
    
    // MARK:- Configure Search Controller.
    private func configureSearchController() {
        // Initialized search controller
        let searchController = UISearchController()
        
        // Set the result update delegate
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        // Set the search bar place holder value
        // c.f: Search Controller has Seach Bar
        searchController.searchBar.placeholder = "Search for a username."
        
        // Hidden the obscure background
        searchController.obscuresBackgroundDuringPresentation = false
        
        // Show up Search Bar
        // c.f: NavigationItem have Search controller
        /*
         Discussion: Why SearchController is optional?
         Because navigation item may not have search controller.
         */
        navigationItem.searchController = searchController
        /*
         Discussion: Why did I implement 'hidesSearchBarWhenScrolling'?
         When I implemented the searchBar I couldn't see search bar
         But When I scroll down I can saw that.
         So, I want to showing this search bar always.
         That's the reason of the implement 'hidesSearchBarWhenScrolling' and assign 'false'
         */
//        navigationItem.hidesSearchBarWhenScrolling = false
    }

    
    // MARK:- configure Data Source
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
    
    // MARK:- update Data
    /*
     Discussion: Why 'updateData' function taking flexible parameter?
     Because when user using search bar which typed username that want to find user, to do update data, using the filterd follower array
     If not, in other words user not using search bar, just scrolling screen, have to use normal follower array
     So, that's the reason of 'updateData' function taking flexible parameter
     */
    // About snapShot stuff. It's related to update data
    func updateData(on followers: [Follower]) {
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
    
    // MARK:- Implement Add Button action method.
    @objc func didTapAddButton() {
        showLoadingView()
        
        guard let username = username else {
            print(ErrorMessage.unwrapError)
            return
        }
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {
                print(ErrorMessage.unwrapError)
                return
            }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager.update(with: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    
                    guard let error = error else {
                        self.presentGithubFollowerAlertOnMainThread(alertTitle: "Success!", bodyMessage: "You have successfully favorited this user 🎉", buttonTitle: "Yeah!!")
                        return
                    }
                    
                    self.presentGithubFollowerAlertOnMainThread(alertTitle: "Error: Something went wrong.", bodyMessage: error.rawValue, buttonTitle: "Ok.")
                    return
                }
                
            case .failure(let error):
                self.presentGithubFollowerAlertOnMainThread(alertTitle: "Error: Something went wrong.", bodyMessage: error.rawValue, buttonTitle: "Ok.")
            }
        }
    }
}

// MARK:- Extension for UICollectionViewDelegate
extension FollowerListViewController: UICollectionViewDelegate {
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        searchBarHidden = false
//        print("scrollViewDidScrollToTop is occur")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBarHidden = true
//        print("scrollViewDidScroll is occur")
    }
    
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
    
    // MARK:- didSelectItemAt method of UICollectionView.
    /*
     Discussion: when user did selecte itme what happen?
     When user tapped on item whatever follower is,
     It will pass the follower's login on to the next screen
     And It's gonna transition next screen.
     */
    func collectionView(_ collectionView: UICollectionView,  didSelectItemAt indexPath: IndexPath) {
        
        // MARK:- Determined Array
        /*
         c.f: What am I first to do?
         first to do determined array that filteredFollowers or not
         And then get the follower at the indexPath.
         I have to know which follower actually selected.
         */
        /*
         Base on the searching flag determine what array to use
         */
        let activeArray = isSearching ? filteredFollowers : followers
        
        // MARK:- follower pulling from activeArray
        /*
         Discussion: How IndexPath working?
         IndexPath is basically plug in whatever number user tapped
         Then the indexPath will be int that user tapped.
         
         +c.f: That's how I getting the sepecific follower from the array
         */
        let follower = activeArray[indexPath.item]
        

        let userInfoVC = UserInfoViewController(username: follower.login)
        //MARK: FollowerListViewControllerDelegate set - (to the communication pathway is set)
        // c.f : This code means 'FollowerListViewController' is listening to the 'UserInfoViewController'
        userInfoVC.delegate = self

        /*
         Discussion: Why did I implement navigationController and present navigationController in this block ?
         Because if view present by modal style, the view have to dismisses button like cancel, confirm, ect...
         It's specifi in the apple h.i.g documentation.
         */
        let navigationController = UINavigationController(rootViewController: userInfoVC)
        
        present(navigationController, animated: true) {
            print("Success to present userInfo VC")
        }
        
        
    }
}

// MARK:- Extension for UISearchResultsUpdating

extension FollowerListViewController: UISearchResultsUpdating {
    /*
     1. Discussion: When 'updateSearchResults' function call?
     Everytime when user typed letter in the search bar
     
     2. Discussion: About parameter the 'searchController'
     The parameter which is 'searchController', Basically get pass back the 'searchController.text'
     */
    func updateSearchResults(for searchController: UISearchController) {
        /*
         Discussion: What's gonna do in this function?
         Actually in this function I will gonna filter the array in update the collection view
         */
        
        // check the search bar actually have text
        guard let filter = searchController.searchBar.text else {
            print("please type username")
            return
        }
        
        // check the filter is not empty
        guard !filter.isEmpty else {
            print("filter is empty check this statement")
            return
        }
        
        filteredFollowers = followers.filter({ followers in
            followers.login.lowercased().contains(filter.lowercased())
        })
        /*
         Discussion: essentially this is doing?
         When every time change the search result from search bar
         It's notice that somthing chage.
         */
        print("this method is success to occur")
        
        isSearching = true
        
        // c.f: updateData get pass the flexible parameter data which is filtered folllower or normal follower.
        updateData(on: filteredFollowers)
    }
}

// MARK:- UISearchBarDelegate
extension FollowerListViewController: UISearchBarDelegate {
    // when user did tapped cancel button this function is calling
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = false
        
        /*
         Discussion: Why updateData method get the 'followers' not the 'filterdFollowers'?
         
         Because when user did tap cancel button collection view have to back to first time view
         In other words have to showing whole followers which is user's own original followers
         that the 'followers' array.
         */
        
        updateData(on: followers)
    }
}

/*
 c.f: FollowerListViewController is Listener
 FollowerListViweController dosen't know whos gonna tell and what to do
 */
extension FollowerListViewController: FollowerListViewControllerDelegate {

    // c.f: This method happen when did select item.
    func didRequestFollowers(for username: String) {
        print("👺When did Select Item this did Request Followers delegate method is occur👺")
        // get followers for that user
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView?.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}
