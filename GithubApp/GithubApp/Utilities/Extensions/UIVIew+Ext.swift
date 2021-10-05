//
//  UIVIew+Ext.swift
//  GithubApp
//
//  Created by Morgan Kang on 2021/10/05.
//

import Foundation
import UIKit

extension UIView {
    // c.f: UIView... is variadic parameter -> the 'views' parameter will change array type in the excute block
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
