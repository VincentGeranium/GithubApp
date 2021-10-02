//
//  FavoritesListViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/07/23.
//

import UIKit

class FavoritesListViewController: GFDataLoadingViewController {
    
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureViewController() {
        /*
         c.f : About color and system color
         -> System color is different with color.
         When user using dark mode, whole colors are little bit different to see and recognize.
         So, Apple develop systemColor which is the color that use at dark mode.
         */
        view.backgroundColor = .systemBlue
        title = "Favorites"
        // c.f: Each navigation controller is different!!
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        // tableView filled the whole view
        tableView.frame = view.bounds
        // tableView Row Hight
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // register the cell
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    func getFavorites() {
        // c.f: [weak self] -> capture list
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                // first. check the array, so if empty showEmptyStateView.
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
                } else {
                    // second. if the favorites array is not empty, set favorites and reload data on the tableView
                    self.favorites = favorites
                    // c.f: reload data is must do the main thread
                    // reload the data is pull new data and populate tableView
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        /*
                         Discussion: bringSubviewToFront
                         this is subView is gonna showing on top
                         
                         apple documentation summary
                         -> Moves the specified subview so that it appears on top of its siblings.
                         */
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentGithubFollowerAlertOnMainThread(alertTitle: "Somethin went wrong!", bodyMessage: error.rawValue, buttonTitle: "Ok.")
            }
        }
    }
}

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK:- Number of rows in section
    /*
     Discussion: About Number of Rows in section.
     The numberOfRowsInSection means number of rows in table view.
     In here, number of rows in table view have is however many favorites in array.
     So, implemented 'return favorites.count'
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // c.f: the number of rows gonna be how many favorites dose array have
        return favorites.count
    }
    
    // MARK:- Cell for row at, indexPath.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // need to create cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as? FavoriteCell else {
            print(ErrorMessage.unwrapError)
            return UITableViewCell()
        }
        
        // c.f: 'IndexPath.row' is grap the row which the specific table view's row
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    // MARK:- didSelectRowAt, when user did tap row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListViewController(username: favorite.login)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // c.f: This code means if not editing style delete return, I don't need anything only need '.delete' style.
        guard editingStyle == .delete else { return }
        
        /*
         Discussion: Why did I implement favorite constant?
         Because for the added delete style in the favorite arrray.
         In other word the cell.
         And need to update to array which data is delete.
         For the userDefault and populate tableView, reload new data at the array.
         */
        let favorite = favorites[indexPath.row]
        // remove from the array
        favorites.remove(at: indexPath.row)
        
        // delete row from the tableView, and animation
        // c.f '[IndexPath]' means just one array that whatever indexPath user swiping
        tableView.deleteRows(at: [indexPath], with: .left)
        
        // handle the persistence
        PersistenceManager.update(with: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.presentGithubFollowerAlertOnMainThread(alertTitle: "Unable to remove", bodyMessage: error.rawValue, buttonTitle: "Ok.")
        }
    }
}
