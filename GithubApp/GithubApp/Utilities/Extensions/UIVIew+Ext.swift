//
//  UIVIew+Ext.swift
//  GithubApp
//
//  Created by Morgan Kang on 2021/10/05.
//

import UIKit

extension UIView {
    // c.f: extension function for the pin to the edge
    func pinToEdge(of superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor),
        ])
    }
    
    // c.f: UIView... is variadic parameter -> the 'views' parameter will change array type in the excute block
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
