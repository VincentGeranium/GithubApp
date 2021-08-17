//
//  FollowerModel.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/17.
//

import Foundation

/*
 Used Codable for my networking model.
 So, confirm the 'Codable'.
 */

/*
 Discussion: About correlation to match data structure between custom model structure and some API's structure when using Codable for get data from API.
 
 If use data from some API, maybe create model about what I want to get data.
 So, create structure inheritance Codabel.
 When use Codable have to caution about correlation to match data structure.
 Custom structure and API's data structure must to match.
 If not it can't get data.
 In other words it occur the networking error.
 
 For example, If API's have name of data that 'identifier'.
 If I want to get the 'identifier' data, I have to match when create structure.
 I can't use like 'var id: String' or 'var ID: String'.
 I have to create structure match with API's like 'var identifier: String'
 Also It's very important about data's type.
 */
struct Follower: Codable {
    /*
     Discussion: About variable name's case
     
     When swift typically not use underscoer.
     Swift use the 'camelCase'
     Use undersocre called 'snake_case'
     
     If the API's some data write down by snake case, It have to convert to camel case use by decoder's method which doing convert snake case to camel case.
     */
    
    var login: String
    var avatarUrl: String
}
