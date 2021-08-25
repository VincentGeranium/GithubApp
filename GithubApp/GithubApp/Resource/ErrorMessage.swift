//
//  ErrorMessage.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/21.
//

import Foundation
/*
 Discussion: This enumeration.
 Create enum which error message that use by raw value.
 The raw value is a String type.
 
 c.f: Different between Raw value and Associate value at the enumeration.
 Raw value: All the cases are confirm the one type.
 Associate value: Each cases have differents type.
 */
/*
 c.f: ErrorMessage's rawValue and Error Protocol
 Enum dosen't have multiple raw value types
 Enum can have one raw value type and confirm protocol
 In here confirm Error protocol.
 In other words ErrorMessage have rawValue which is String type and confirm protocol that Error.
 */
enum ErrorMessage: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. please try again."
    case invalidData = "The data received from the server was invalid. please try again."
    case invalidAssetImage = "The image from the Assets.xcassets was invalid."
    case unableToOccurMethod = "Unable to occur this method. Please check the code."
}

/*
 Discussion: About Result Type
 
 Basically Result is Enum and return two cases.
 1. Success case
 2. Failure case
 The Success case can have generic which is any type
 The Any type is can be what I want to put in
 For example in 'getFollowers' function Result success case gonna be '[Follower]'
 And Error message is return Failure case, the Failure case have to confirm the 'Error' protocol.
 */