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

enum ErrorMessage: String {
    case invalidUsername = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. please try again."
    case invalidData = "The data received from the server was invalid. pleas try again."
}
