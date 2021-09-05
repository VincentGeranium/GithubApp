//
//  UIViewController+Extension.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/16.
//

import Foundation
import UIKit

/*
 Discussion: Create global property use by fileprivate.
 Can't create variable in extension.
 In other word extension must not contain stored properties.
 So, If developer want to create or need property create by globaly
 */

fileprivate var containerView: UIView?

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
    
    // MARK:- showLoadingView
    // first I need the container view, this is the background view whole all activity indicator
    func showLoadingView() {
        // initilize uiview
        // c.f: 'view.bounds' means fill up the whole screen.
        containerView = UIView(frame: view.bounds)
        
        guard let containerView = containerView else {
            return
        }
        
        // add containerView in the viewController's view
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        
        /*
         Discussion: Why did I start alpha from zero?
         The reason of doing this cause animate that to 0.8 percent.
         I don't want loading view pops up, I want settle animation fade in.
         In order to do that start to alpha 0 and animate 0.8 right pops on the screen
         */
        /*
         c.f: 'alpha' = 'transparency'
         If view's alpha is zero -> View is be there but can't see
         */
        // MARK:- Create containerView's alpha and animation
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        // MARK:- Configure the indicator
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        // add the indicator view to the container view
        containerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicatorView.startAnimating()
    }
    
    // MARK:- dismissLoadingView
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
}
