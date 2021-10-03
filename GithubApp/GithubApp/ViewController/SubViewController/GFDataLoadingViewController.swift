//
//  GFDataLoadingViewController.swift
//  GithubApp
//
//  Created by Morgan Kang on 2021/10/02.
//

import UIKit

class GFDataLoadingViewController: UIViewController {

    var containerView: UIView!

    // MARK:- showLoadingView
    // first I need the container view, this is the background view whole all activity indicator
    func showLoadingView() {
        // initilize uiview
        // c.f: 'view.bounds' means fill up the whole screen.
        containerView = UIView(frame: view.bounds)
     
        
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
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        // MARK:- Configure the indicator
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        // add the indicator view to the container view
        containerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        activityIndicatorView.startAnimating()
    }
    
    // MARK:- dismissLoadingView
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    //MARK:- showEmptyStateView
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GithubFollowerEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }

}
