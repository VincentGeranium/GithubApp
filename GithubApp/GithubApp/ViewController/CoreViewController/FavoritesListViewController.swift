//
//  FavoritesListViewController.swift
//  GithubApp
//
//  Created by 김광준 on 2021/07/23.
//

import UIKit

class FavoritesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         c.f : About color and system color
         -> System color is different with color.
         When user using dark mode, whole colors are little bit different to see and recognize.
         So, Apple develop systemColor which is the color that use at dark mode.
         */
        view.backgroundColor = .systemBlue
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                print(error)
            }
        }
    }

}
