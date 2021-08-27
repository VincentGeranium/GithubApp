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
    var collectionView: UICollectionView?

    
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
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Follower>
    var dataSource: DataSource?
    
    /*
     c.f: the two parameter which Section and Follower
     - Section and Follower is generic
     - Section means section of collection view
     - Follower is individual item
     - Section and Follower is confirm Hashable
     - Those are have unique value cause Hashable.
     */
    
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Follower>
    var snapShot: SnapShot?
     
    
    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
    }
    
    // MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigaitonController()
    }
    
    // MARK:- getFollowers
    private func getFollowers() {
        NetworkManager.shared.getFollowers(for: username!, perpage: 100, page: 1) {[weak self] result in
            
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
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let followers):
//                print("Followers.count = \(followers.count)")
                print("Followers elements = \(followers)")
                strongSelf.followers = followers
                strongSelf.updateData()
            case .failure(let errorMessage):
                strongSelf.presentGithubFollowerAlertOnMainThread(alertTitle: "Bad Stuff Happend", bodyMessage: errorMessage.rawValue, buttonTitle: "Ok")
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
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        
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
        
        // cofigure collectionView
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.cellIdentifier)
        
    }
    
    // MARK:- createThreeColumnFlowLayout
    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        /*
         c.f:
         This 'width' is total width of screen and also the width is same things used in the all the iPhone version.
         In other words 'view.bounds.width' is means same that total width screen which any version of iPhone.
         */
        let width = view.bounds.width
        
        // c.f: padding is means give space that all around of edges which top, botton, leading and trailing.
        let padding: CGFloat = 12
        let minimumSpacing: CGFloat = 10
        
        // compute available width
        /*
         Discussion: About compute avaliable width
         
         1. why substract padding by two times?
         -> Because I want give space leading and trailing
         
         2. why substract minimumSpacing by two times?
         -> Because I will make collectionView Items are 3, in other word I will create three column
            So, I want give space between items.
            Three Items are have two space between each items.
            That's the reason I substract minimumSpacing by two times.
            In additional If, I want make 4 Items in the screen, I the space is 3.
         */
        let availableWidth = width - (padding * 2) - (minimumSpacing * 2)
        
        // c.f : Item width is actual cell
        let itemWidth = availableWidth / 3
        
        /*
         Discussion: Why cell height is gonna itemWidth + 40?
         Because the collection view cell get avatar image and 'name label'
         The name label size is 20, so I give more 20 padding each of the cell
         The point is why I did give +40 when create height size.
         The reason is cell have avatar image and also have '20 points size of name label'.
         */
        let itemHeight = itemWidth + 40
        
        /*
         Discussion: About FlowLayout
         The FlowLayout basically determinds the flow of collection view
         In other words give cell's paddind, width and height ect,,, that's determinds the flow of collection view.
         */
        // create UICollectionViewFlowLayout object.
        let flowLayout = UICollectionViewFlowLayout()
        
        // configure flowlayout
        // c.f: 'UIEdgeInsets' is give padding all around of edge
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        // this is cell size
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        return flowLayout
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
        
//        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        
      
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

