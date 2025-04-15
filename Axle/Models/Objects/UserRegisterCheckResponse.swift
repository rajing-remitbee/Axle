//
//  VerifyOTPResponse.swift
//  Axle
//
//  Created by Rajin Gangadharan on 09/04/25.
//

import Foundation

struct UserRegisterCheckResponse: Decodable {
    let checkUserRegistration: RegisterCheckResponse
}

struct UserObjectResponse: Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let terms_accepted: Bool
}

struct RegisterCheckResponse: Decodable {
    let userExists: Bool
    let personalDetailsComplete: Bool
    let addressDetailsComplete: Bool
    let user: UserObjectResponse?
}
