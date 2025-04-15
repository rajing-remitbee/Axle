//
//  GenerateOTPResponse.swift
//  Axle
//
//  Created by Rajin Gangadharan on 09/04/25.
//

import Foundation

struct CreateUserResponse : Decodable {
    let createUser: UserResponse
}

struct UserResponse: Decodable {
    let id: Int
    let phone_number: String
}
