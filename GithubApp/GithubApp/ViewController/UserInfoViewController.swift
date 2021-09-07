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
    
    var username: String?
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
//        navigationItem.rightBarButtonItem = setupDoneButton()
        setupNavigationRightBarButtonItem()
        print(self.username!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupDoneButton() -> UIBarButtonItem {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(dismissViewController))
        
        return doneButton
    }
    
    private func setupNavigationRightBarButtonItem() {
        navigationItem.rightBarButtonItem = setupDoneButton()
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true) {
            print("Success to dismiss ViewController")
        }
    }
}
