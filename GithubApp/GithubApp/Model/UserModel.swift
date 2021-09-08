//
//  UserModel.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/17.
//

import Foundation
// c.f: parse the JSON data using by 'Codable'

struct User: Codable {
    /*
     c.f: About design structure.
     
     When I create structure and modeling, I have to thinking about app design that what I showing to user.
     And I have to modeling the data structure create that what I want it.
     It have to match with what I want showing in the screen.
     */
    
    //MARK:- Header view's userInfo data.
    let login: String
    let avatarUrl: String
    /*
     Discussion: Why did I create name variable by optional ?
     Because name can be return nil value.
     So, I create by optional.
     */
    var name: String?
    var location: String?
    var bio: String?
    
    //MARK:- github repository card design's essential data.
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    
    //MARK:- github following and followers card design's essential data.
    let following: Int
    let followers: Int
    
    // MARK:- Footer view's date data.
    let createdAt: String
}
