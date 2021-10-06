//
//  ScreenSize.swift
//  GithubApp
//
//  Created by Morgan Kang on 2021/09/30.
//

import UIKit

enum ScreenSize {
    // width and height of actuall screen
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}
