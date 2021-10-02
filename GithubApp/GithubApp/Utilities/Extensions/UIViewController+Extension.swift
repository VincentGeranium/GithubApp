//
//  UIViewController+Extension.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/16.
//

import Foundation
import UIKit
import SafariServices



/*
 Discussion: Difference between Subclassing and Extension
 
 Subclassing is more specific sub setup something what I want to behavior.
 Extension is about all behavior and setup what I want to create object.
 In other words expanding something what I want to be create object.
 
 In short, Subclassing is more specific than Extension.
 */

extension UIViewController {

    /*
     Discussion: In the 'extension UIViewController'
     
     Put in the behavior to show this alert controller.
     So, any view controller can call this function as a result can show this alert.
     */
    // MARK:- Create function for 'present githubFollowerAlert On the mainThread'
    func presentGithubFollowerAlertOnMainThread(alertTitle: String, bodyMessage: ErrorMessage.RawValue, buttonTitle: String) {
        /*
         c.f: UI element and main therad.
         It's illegal to present UI element from the back ground thread.
         So, UI element's have to present from the main thread
         */
        // MARK:- Create main thread code
        // c.f: This code which 'DispathchQueue.main.async' is meaning quick throw to main thread.
        DispatchQueue.main.async {
            // This code similar with pass data.
            
            /*
             c.f:  This code similar with pass data.
             
             c.f: GithubFollowerAlertViewController's custom init is passing from presentGithubFollowerAlertOnMainThread's parameters
             */
            let githubFollowerAlertVC = GithubFollowerAlertViewController(alertTitle: alertTitle, bodyMessage: bodyMessage, buttonTitle: buttonTitle)
            
            // MARK:- configure alert vc
            githubFollowerAlertVC.modalPresentationStyle = .overFullScreen
            /*
             c.f : modalTransitionStyle.
             modalTransitionStyle is meaning animation.
             In this case when alert controller showing, crossDissolve style animation will excute.
             In other words showing alert to user like fade in animation.
             */
            githubFollowerAlertVC.modalTransitionStyle = .crossDissolve
            self.present(githubFollowerAlertVC, animated: true) {
                print("🎯success to excute : presentGithubFollowerAlertOnMainThread's githubFollowerAlertVC.")
            }
        }
    }
    
        
    // MARK:- Present Safari viewController
    // c.f: safari default preferredControlTintColor is blue
    func presentSafariViewController(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true, completion: nil)
    }
}
