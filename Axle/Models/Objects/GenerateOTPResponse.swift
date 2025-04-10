//
//  GenerateOTPResponse.swift
//  Axle
//
//  Created by Rajin Gangadharan on 09/04/25.
//

import Foundation

struct GenerateOTPResponse : Decodable {
    let generateOTP: OTPResponse
}

struct OTPResponse: Decodable {
    let otp: String
    let token: String
}
