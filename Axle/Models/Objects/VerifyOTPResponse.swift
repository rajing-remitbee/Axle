//
//  VerifyOTPResponse.swift
//  Axle
//
//  Created by Rajin Gangadharan on 09/04/25.
//

import Foundation

struct VerifyOTPResponse: Decodable {
    let verifyOTP: VerifyResponse
}

struct VerifyResponse: Decodable {
    let success: Bool
    let message: String
}
