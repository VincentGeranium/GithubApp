//
//  UITableView+Ext.swift
//  GithubApp
//
//  Created by Morgan Kang on 2021/10/06.
//

import UIKit

extension UITableView {
    /*
     Dicsussion: About 'removeExcessCells' function
     This function dose remove remain tableview cell.
     In other word table footer view change with blank view.
     */
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
