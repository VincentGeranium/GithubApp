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
        tableView.removeExcessCells()
        
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
    
    // MARK:- TableView Method for the swipe delete.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // c.f: This code means if not editing style delete return, I don't need anything only need '.delete' style.
        guard editingStyle == .delete else { return }
        
        // MARK:- Discussion: PersistenceManager.update Logic
        /*
         Discussion: About Logic
         favorite Array에(실제적으로는 ViewController에 UI를 업데이트 하는 것) 데이터를 업데이트 하는 것은
         PersistenceManager 업데이트 전에 행해진다.
         이것 행위가 무엇을 의미하여 추후에 어떤 동작을 가져오는지 알아보자.
         PersistenceManager 코드를 보면 error에 관련된 코드들이 있다. 실제적으로 에러가 발생할 경우
         'self.presentGithubFollowerAlertOnMainThread(alertTitle: "Unable to remove", bodyMessage: error.rawValue, buttonTitle: "Ok.")' 코드를 실행하게 만들어두었다.
         그러나 favorite Array에 데이터를 업데이트 하는 코드가 먼저 행해지게 만들었으므로 이 error에 대응하는 코드는 무용지물이나 마찬가지가 된다.
         조금 더 상세하게 말하자면 이미 favorite array에 데이터가 업데이트 된 후에 PersistenceManager 코드가 실행되므로 서로 코드 실행에 대한 싱크가 맞지 않는 것이다.
         서로 싱크가 맞지 않으니 각각의 조각이 어긋나게 되어 무용지물이 되는 것이다.
         그렇다면 서로의 코드가 싱크가 맞게 하려먼 어떻게 해야할까?
         PersistenceManager 코드 안에 error가 발생하지 않을 경우 favorites Array가 업데이트 되게하고
         tableView(UI)또한 업데이트 되게 하는 코드를 넣어주면 싱크가 맞게 된다.
         
         ->
         
         guard let error = error else {
             // remove from the array
             self.favorites.remove(at: indexPath.row)
             
             // delete row from the tableView, and animation
             // c.f '[IndexPath]' means just one array that whatever indexPath user swiping
             tableView.deleteRows(at: [indexPath], with: .left)
             return
         }
         
         */
        
        /*
         Discussion: Why did I implement favorite constant?
         Because for the added delete style in the favorite arrray.
         In other word the cell.
         And need to update to array which data is delete.
         For the userDefault and populate tableView, reload new data at the array.
         */
        
        // handle the persistence
        PersistenceManager.update(with: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                // remove from the array
                self.favorites.remove(at: indexPath.row)
                
                // delete row from the tableView, and animation
                // c.f '[IndexPath]' means just one array that whatever indexPath user swiping
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            
            self.presentGithubFollowerAlertOnMainThread(alertTitle: "Unable to remove", bodyMessage: error.rawValue, buttonTitle: "Ok.")
        }
    }
}
